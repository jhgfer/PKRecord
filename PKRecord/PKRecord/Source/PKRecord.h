//
//  PKRecord.h
//  PKTestProj
//
//  Created by zhongsheng on 13-9-27.
//  Copyright (c) 2013年 zhongsheng. All rights reserved.
//

#import <CoreData/CoreData.h>

#if TARGET_OS_IPHONE == 0
#define MAC_PLATFORM_ONLY YES
#endif

@class PKRecord;
@class PKRecordContext;

typedef void (^PKSavingBlock)(PKRecord *record, PKRecordContext *context);

typedef void (^PKSaveOnCompletedBlock)(PKRecord *record, PKRecordContext *context, BOOL success, NSError *error);

@interface PKRecord : NSObject

@property (nonatomic, readonly) PKRecordContext *rootContext;

@property (nonatomic, readonly) PKRecordContext *defaultContext;

@property (nonatomic, readonly) NSManagedObjectModel *model;

@property (nonatomic, readonly) NSPersistentStoreCoordinator *storeCoordinator;

/*--------      Setup     --------*/

- (void)setupCoreDataStackInMemoryStore;

- (void)setupCoreDataStackInStoreURL:(NSURL *)URL;

- (void)setupCoreDataStackAutoMigratingInStoreURL:(NSURL *)URL;

- (void)cleanup;

/*--------     Setting    --------*/

- (void)setModelName:(NSString *)name;

/*--------  Default Save --------*/

- (void)saveUsingCurrentThreadContextWithBlock:(PKSavingBlock)block;

- (void)saveUsingCurrentThreadContextWithBlock:(PKSavingBlock)block onCompleted:(PKSaveOnCompletedBlock)completed;

- (void)saveAndWaitWithBlock:(PKSavingBlock)block;

- (void)saveAndWaitUsingCurrentThreadContextWithBlock:(PKSavingBlock)block;

@end
