//
//  NSManagedObject+PKAggregation.h
//  PKTestProj
//
//  Created by zhongsheng on 13-9-29.
//  Copyright (c) 2013年 zhongsheng. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (PKAggregation)

+ (NSUInteger)countOfEntitiesWithContext:(NSManagedObjectContext *)context;

+ (NSUInteger)countOfEntitiesWithPredicate:(NSPredicate *)searchFilter inContext:(NSManagedObjectContext *)context;

+ (BOOL)hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context;

+ (NSNumber *)aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

- (instancetype)objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context;

@end
