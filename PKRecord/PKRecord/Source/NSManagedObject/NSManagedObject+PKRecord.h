//
//  NSManagedObject+PKRecord.h
//  PKTestProj
//
//  Created by zhongsheng on 13-9-29.
//  Copyright (c) 2013年 zhongsheng. All rights reserved.
//

#import <CoreData/CoreData.h>

#define kPKRecordDefaultBatchSize 20

@interface NSManagedObject (PKRecord)

+ (NSUInteger)defaultBatchSize;
+ (void)setDefaultBatchSize:(NSUInteger)newBatchSize;

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;
+ (instancetype)executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
+ (void)performFetch:(NSFetchedResultsController *)controller;
#endif

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;
+ (NSArray *)propertiesNamed:(NSArray *)properties inContext:(NSManagedObjectContext *)context;

+ (instancetype)createInContext:(NSManagedObjectContext *)context;

- (BOOL)deleteInContext:(NSManagedObjectContext *)context;

+ (BOOL)deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

+ (BOOL)truncateAllInContext:(NSManagedObjectContext *)context;

+ (NSArray *)ascendingSortDescriptors:(NSArray *)attributesToSortBy;
+ (NSArray *)descendingSortDescriptors:(NSArray *)attributesToSortBy;

- (id)objectInContext:(NSManagedObjectContext *)otherContext;


@end
