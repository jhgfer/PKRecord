//
//  PKRecordContext.m
//  PKTestProj
//
//  Created by zhongsheng on 13-9-29.
//  Copyright (c) 2013年 zhongsheng. All rights reserved.
//

#import "PKRecordContext.h"
#import "PKRecord+ErrorHandling.h"

static NSString * const kPKRecordContextWorkingName = @"kPKRecordContextWorkingName";

@implementation PKRecordContext

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)contextWithoutParent
{
    PKRecordContext *context = [[self alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    return context;
}

+ (instancetype)contextWithParent:(PKRecordContext *)parentContext
{
    PKRecordContext *context = [self contextWithoutParent];
    context.record = parentContext.record;
    [context setParentContext:parentContext];
    [context obtainPermanentIDsBeforeSaving];
    return context;
}

+ (instancetype)contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
	PKRecordContext *context = nil;
    if (coordinator != nil)
	{
        context = [self contextWithoutParent];
        [context performBlockAndWait:^{
            [context setPersistentStoreCoordinator:coordinator];
        }];
    }
    return context;
}

- (void)saveOnlySelfWithCompletion:(PKSaveContextOnCompletedBlock)completed
{
    [self saveWithOptions:0 onCompleted:completed];
}

- (void)saveOnlySelfAndWait
{
    [self saveWithOptions:PKSaveSynchronously onCompleted:nil];
}

- (void)saveToPersistentStoreWithCompletion:(PKSaveContextOnCompletedBlock)completed
{
    [self saveWithOptions:PKSaveParentContexts onCompleted:completed];
}

- (void)saveToPersistentStoreAndWait
{
    [self saveWithOptions:PKSaveParentContexts|PKSaveSynchronously onCompleted:nil];
}

- (void)saveWithOptions:(PKSaveContextOptions)options onCompleted:(PKSaveContextOnCompletedBlock)completed
{
    BOOL syncSave           = (options & PKSaveSynchronously);
    BOOL saveParentContexts = (options & PKSaveParentContexts);

    if (![self hasChanges]) {
        NSLog(@"NO CHANGES IN ** %@ ** CONTEXT - NOT SAVING", [self workingName]);
        
        if (completed)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completed(YES, nil);
            });
        }
        
        return;
    }
    
    NSLog(@"→ Saving %@", self);
    NSLog(@"→ Save Parents? %@", @(saveParentContexts));
    NSLog(@"→ Save Synchronously? %@", @(syncSave));
    
    id saveBlock = ^{
        NSError *error = nil;
        BOOL     saved = NO;
        
        @try
        {
            saved = [self save:&error];
        }
        @catch(NSException *exception)
        {
            NSLog(@"Unable to perform save: %@", (id)[exception userInfo] ? : (id)[exception reason]);
        }
        
        @finally
        {
            if (!saved) {
                [PKRecord handleErrors:error];
                
                if (completed) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completed(saved, error);
                    });
                }
            } else {
                // If we're the default context, save to disk too (the user expects it to persist)
                BOOL isDefaultContext = ((nil != self.record) && (self == self.record.defaultContext));
                BOOL shouldSaveParentContext = ((YES == saveParentContexts) || isDefaultContext);
                
                if (shouldSaveParentContext && [self parentContext]) {
                    PKRecordContext *parentContext = (PKRecordContext *)self.parentContext;
                    [parentContext saveWithOptions:options onCompleted:completed];
                }
                // If we should not save the parent context, or there is not a parent context to save (root context), call the completion block
                else {
                    NSLog(@"→ Finished saving: %@", self);
                    
                    if (completed) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completed(saved, error);
                        });
                    }
                }
            }
        }
    };
    
    if (syncSave) {
        [self performBlockAndWait:saveBlock];
    } else {
        [self performBlock:saveBlock];
    }

}

- (void)removeObtainPermanentIDsBeforeSaving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextWillSaveNotification
                                                  object:self];
}

- (void)obtainPermanentIDsBeforeSaving
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextWillSave:)
                                                 name:NSManagedObjectContextWillSaveNotification
                                               object:self];
}

#pragma mark - Private

- (void)contextWillSave:(NSNotification *)notification
{
    PKRecordContext *context = [notification object];
    NSSet *insertedObjects = [context insertedObjects];
    
    if ([insertedObjects count])
    {
        NSLog(@"Context %@ is about to save. Obtaining permanent IDs for new %lu inserted objects", context.workingName, (unsigned long)[insertedObjects count]);
        NSError *error = nil;
        BOOL success = [context obtainPermanentIDsForObjects:[insertedObjects allObjects] error:&error];
        if (!success)
        {
            [PKRecord handleErrors:error];
        }
    }
}

#pragma mark - Propertys

- (void)setWorkingName:(NSString *)workingName;
{
    [[self userInfo] setObject:workingName forKey:kPKRecordContextWorkingName];
}

- (NSString *)workingName;
{
    NSString *workingName = [[self userInfo] objectForKey:kPKRecordContextWorkingName];
    if (nil == workingName)
    {
        workingName = @"UNNAMED";
    }
    return workingName;
}

- (NSString *)description
{
    NSString *contextLabel = [NSString stringWithFormat:@"*** %@ ***", [self workingName]];
    NSString *onMainThread = [NSThread isMainThread] ? @"*** MAIN THREAD ***" : @"*** BACKGROUND THREAD ***";
    
    return [NSString stringWithFormat:@"<%@ (%p): %@> on %@", NSStringFromClass([self class]), self, contextLabel, onMainThread];
}


@end
