//
//  NSManagedObject+PKRequest.h
//  PKTestProj
//
//  Created by zhongsheng on 13-9-29.
//  Copyright (c) 2013年 zhongsheng. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (PKRequest)

+ (NSFetchRequest *)createFetchRequestInContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)requestAllInContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)requestAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)requestAllWhere:(NSString *)property isEqualTo:(id)value inContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)requestFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

@end
