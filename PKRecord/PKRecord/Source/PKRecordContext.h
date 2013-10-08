//
//  PKRecordContext.h
//  PKTestProj
//
//  Created by passerbycrk on 13-9-29.
//  Copyright (c) 2013年 passerbycrk. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PKRecord.h"

typedef NS_OPTIONS(NSUInteger, PKSaveContextOptions) {
    PKSaveParentContexts = 1<<0,    ///< When saving, continue saving parent contexts until the changes are present in the persistent store
    PKSaveSynchronously  = 1<<1     ///< Peform saves synchronously, blocking execution on the current thread until the save is complete
};

typedef void (^PKSaveContextOnCompletedBlock)(BOOL success, NSError *error);

@interface PKRecordContext : NSManagedObjectContext

@property (nonatomic, assign) NSString *workingName;

@property (nonatomic,   weak) PKRecord *record;

/*-------- init --------*/

+ (instancetype)contextWithoutParent;

+ (instancetype)contextWithParent:(PKRecordContext *)parentContext;

+ (instancetype)contextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

/*-------- save --------*/

- (void)saveOnlySelfWithCompletion:(PKSaveContextOnCompletedBlock)completed;

- (void)saveOnlySelfAndWait;

- (void)saveToPersistentStoreWithCompletion:(PKSaveContextOnCompletedBlock)completed;

- (void)saveToPersistentStoreAndWait;

- (void)saveWithOptions:(PKSaveContextOptions)options onCompleted:(PKSaveContextOnCompletedBlock)completed;

/*-------- obtain --------*/

- (void)obtainPermanentIDsBeforeSaving;

- (void)removeObtainPermanentIDsBeforeSaving;

@end
