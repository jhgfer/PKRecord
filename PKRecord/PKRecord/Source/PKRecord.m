//
//  PKRecord.m
//  PKTestProj
//
//  Created by zhongsheng on 13-9-27.
//  Copyright (c) 2013年 zhongsheng. All rights reserved.
//

#import "PKRecord.h"
#import "PKRecord+Threading.h"
#import "PKRecord+ErrorHandling.h"
#import "PKRecordContext.h"

@interface PKRecord ()
@property (nonatomic, readwrite, strong) PKRecordContext                *rootContext;
@property (nonatomic, readwrite, strong) PKRecordContext                *defaultContext;
@property (nonatomic, readwrite, strong) NSManagedObjectModel           *model;
@property (nonatomic, readwrite, strong) NSPersistentStoreCoordinator   *storeCoordinator;
@end

@implementation PKRecord
{
    BOOL _isMemoryStore;
    dispatch_queue_t _recordRootQueue;
}

- (void)dealloc
{
    [self cleanup];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _recordRootQueue = dispatch_queue_create([[NSString stringWithFormat:@"PKRecord-RootQueue-%@",self] UTF8String], NULL);
    }
    return self;
}

#pragma mark - Setup

- (void)setupCoreDataStackInMemoryStore
{
    _isMemoryStore = YES;
    [self checkStoreCoordinator];
    
    NSError *error = nil;
    NSPersistentStore *store = [self.storeCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                                   configuration:nil
                                                                             URL:nil
                                                                         options:nil
                                                                           error:&error];
    if (!store) {
        [PKRecord handleErrors:error];
    }
    [self initializeDefaultContext];
}

- (void)setupCoreDataStackInStoreURL:(NSURL *)URL;
{
    [self setupCoreDataStackAutoMigrating:NO inStoreURL:URL];
    [self initializeDefaultContext];
}

- (void)setupCoreDataStackAutoMigratingInStoreURL:(NSURL *)URL
{
    [self setupCoreDataStackAutoMigrating:YES inStoreURL:URL];
    //HACK: lame solution to fix automigration error "Migration failed after first pass"
    if (0 == self.storeCoordinator.persistentStores.count) {
        [self performSelector:@selector(setupCoreDataStackAutoMigratingInStoreURL:) withObject:URL afterDelay:.5f];
    }else{
        [self initializeDefaultContext];
    }
}

- (void)setupCoreDataStackAutoMigrating:(BOOL)autoMigrating inStoreURL:(NSURL *)URL
{
    _isMemoryStore = NO;
    [self checkStoreCoordinator];
    [self checkStorePathURL:URL];
    
    NSError *error = nil;
    NSDictionary *options = autoMigrating?
                            @{
                              NSMigratePersistentStoresAutomaticallyOption:@(YES),
                              NSInferMappingModelAutomaticallyOption:@(YES),
                              NSSQLitePragmasOption:@{@"journal_mode":@"WAL"}
                              }
                            :nil;
    NSPersistentStore *store = [self.storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                   configuration:nil
                                                                             URL:URL
                                                                         options:options
                                                                           error:&error];
    if (!store /* && [MagicalRecord shouldDeleteStoreOnModelMismatch]*/)
    {
        BOOL isMigrationError = [error code] == NSPersistentStoreIncompatibleVersionHashError || [error code] == NSMigrationMissingSourceModelError;
        if ([[error domain] isEqualToString:NSCocoaErrorDomain] && isMigrationError)
        {
            // Could not open the database, so... kill it!
            [[NSFileManager defaultManager] removeItemAtURL:URL error:nil];
            
            NSLog(@"Removed incompatible model version: %@", [URL lastPathComponent]);
            
            // Try one more time to create the store
            store = [self.storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                        configuration:nil
                                                                  URL:URL
                                                              options:options
                                                                error:&error];
            if (store)
            {
                // If we successfully added a store, remove the error that was initially created
                error = nil;
            }
        }
        
        [PKRecord handleErrors:error];
    }
}

- (void)cleanup
{
    _isMemoryStore = NO;
    self.rootContext = nil;
    self.defaultContext = nil;
    self.model = nil;
    self.storeCoordinator = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setting

- (void)setModelName:(NSString *)name
{
    if (![name hasSuffix:@".momd"]) {
        name = [name stringByAppendingPathExtension:@"momd"];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension]
                                                     ofType:[name pathExtension]];
	NSURL *momURL = [NSURL fileURLWithPath:path];
	
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
	self.model = model;
}

#pragma mark - Default Save

- (void)saveUsingCurrentThreadContextWithBlock:(PKSavingBlock)block
{
    [self saveUsingCurrentThreadContextWithBlock:block onCompleted:nil];
}

- (void)saveUsingCurrentThreadContextWithBlock:(PKSavingBlock)block onCompleted:(PKSaveOnCompletedBlock)completed
{
    PKRecordContext *threadContext = [self contextForCurrentThread];
    
    [threadContext performBlock:^{
        if (block) {
            block(self,threadContext);
        }
        [threadContext saveWithOptions:PKSaveParentContexts onCompleted:^(BOOL success, NSError *error) {
            if (completed) {
                completed(self,threadContext,success,error);
            }
        }];
    }];
}

- (void)saveAndWaitWithBlock:(PKSavingBlock)block
{
    PKRecordContext *localContext = [PKRecordContext contextWithParent:self.rootContext];
    
    [localContext performBlockAndWait:^{
        if (block) {
            block(self,localContext);
        }
        
        [localContext saveWithOptions:PKSaveParentContexts|PKSaveSynchronously onCompleted:nil];
    }];
}

- (void)saveAndWaitUsingCurrentThreadContextWithBlock:(PKSavingBlock)block
{
    PKRecordContext *threadContext = [self contextForCurrentThread];
    
    [threadContext performBlockAndWait:^{
        if (block) {
            block(self,threadContext);
        }
        [threadContext saveWithOptions:PKSaveParentContexts|PKSaveSynchronously onCompleted:nil];
    }];
}

#pragma mark - Private

- (void)checkStoreCoordinator
{
    if (nil == self.storeCoordinator) {
        if (nil == self.model) {
            self.model = [NSManagedObjectModel mergedModelFromBundles:nil];;
        }
        NSParameterAssert(self.model != nil);
        self.storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    }
}

- (void)checkStorePathURL:(NSURL *)urlForStore
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *pathToStore = [urlForStore URLByDeletingLastPathComponent];
    
    NSError *error = nil;
    BOOL pathWasCreated = [fileManager createDirectoryAtPath:[pathToStore path] withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!pathWasCreated)
    {
        [PKRecord handleErrors:error];
    }
}

- (void)initializeDefaultContext
{
    if (self.defaultContext == nil)
    {
        PKRecordContext *rootContext = [PKRecordContext contextWithStoreCoordinator:self.storeCoordinator];
        [self setRootContext:rootContext];
        
        PKRecordContext *defaultContext = [[PKRecordContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [self setDefaultContext:defaultContext];
        [defaultContext setParentContext:rootContext];
    }
}

- (void)rootContextChanged:(NSNotification *)notification
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self rootContextChanged:notification];
        });
    }else{
        dispatch_async(_recordRootQueue, ^{
            [self.defaultContext mergeChangesFromContextDidSaveNotification:notification];
        });
    }
}


#pragma mark - Propertys

- (void)setRootContext:(PKRecordContext *)rootContext
{
    if (self.rootContext)
    {
        [self.rootContext removeObtainPermanentIDsBeforeSaving];
    }
    rootContext.record = self;
    [rootContext obtainPermanentIDsBeforeSaving];
    [rootContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    [rootContext setWorkingName:@"BACKGROUND SAVING (ROOT)"];
    _rootContext = rootContext;
    NSLog(@"Set Root Saving Context: %@", _rootContext);
}

- (void)setDefaultContext:(PKRecordContext *)defaultContext
{
    if (self.defaultContext)
    {
        [self.defaultContext removeObtainPermanentIDsBeforeSaving];
    }
    [defaultContext setWorkingName:@"DEFAULT"];
    defaultContext.record = self;
    
    // TODO: iCloud
    
    if ((defaultContext != nil) && (self.rootContext != nil)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rootContextChanged:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:self.rootContext];
    }
    
    [defaultContext obtainPermanentIDsBeforeSaving];
    _defaultContext = defaultContext;
    NSLog(@"Set Default Context: %@", _defaultContext);
}


@end
