//
//  NSManagedObject+PKFinder.m
//  PKTestProj
//
//  Created by zhongsheng on 13-9-29.
//  Copyright (c) 2013年 zhongsheng. All rights reserved.
//

#import "NSManagedObject+PKFinder.h"
#import "NSManagedObject+PKRequest.h"
#import "NSManagedObject+PKRecord.h"

@implementation NSManagedObject (PKFinder)

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context
{
    return [self executeFetchRequest:[self requestAllInContext:context] inContext:context];
}
+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllSortedBy:sortTerm ascending:ascending inContext:context];
    
	return [self executeFetchRequest:request inContext:context];
}
+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllSortedBy:sortTerm
                                             ascending:ascending
                                         withPredicate:searchTerm
                                             inContext:context];
    
	return [self executeFetchRequest:request inContext:context];
}
+ (NSArray *)findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
	[request setPredicate:searchTerm];
	
	return [self executeFetchRequest:request inContext:context];
}

+ (instancetype)findFirstInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    
	return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}
+ (instancetype)findFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestFirstWithPredicate:searchTerm inContext:context];
    
    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}
+ (instancetype)findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllSortedBy:property ascending:ascending withPredicate:searchterm inContext:context];
    
	return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}
+ (instancetype)findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
	[request setPredicate:searchTerm];
	[request setPropertiesToFetch:attributes];
	
	return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}
+ (instancetype)findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context andRetrieveAttributes:(id)attributes, ...
{
    NSFetchRequest *request = [self requestAllSortedBy:sortBy
                                             ascending:ascending
                                         withPredicate:searchTerm
                                             inContext:context];
	[request setPropertiesToFetch:[self propertiesNamed:attributes inContext:context]];
	
	return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}
+ (instancetype)findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestFirstByAttribute:attribute withValue:searchValue inContext:context];
    
	return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}
+ (instancetype)findFirstOrderedByAttribute:(NSString *)attribute ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllSortedBy:attribute ascending:ascending inContext:context];
    [request setFetchLimit:1];
    
    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllWhere:attribute isEqualTo:searchValue inContext:context];
	
	return [self executeFetchRequest:request inContext:context];
}
+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    NSPredicate *searchTerm = [NSPredicate predicateWithFormat:@"%K = %@", attribute, searchValue];
	NSFetchRequest *request = [self requestAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm inContext:context];
	
	return [self executeFetchRequest:request inContext:context];
}

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSFetchedResultsController *)fetchController:(NSFetchRequest *)request delegate:(id<NSFetchedResultsControllerDelegate>)delegate useFileCache:(BOOL)useFileCache groupedBy:(NSString *)groupKeyPath inContext:(NSManagedObjectContext *)context
{
    NSString *cacheName = useFileCache ? [NSString stringWithFormat:@"PKRecord-Cache-%@", NSStringFromClass([self class])] : nil;
    
	NSFetchedResultsController *controller =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                        managedObjectContext:context
                                          sectionNameKeyPath:groupKeyPath
                                                   cacheName:cacheName];
    controller.delegate = delegate;
    
    return controller;
}


+ (NSFetchedResultsController *)fetchAllWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllInContext:context];
    NSFetchedResultsController *controller = [self fetchController:request delegate:delegate useFileCache:NO groupedBy:nil inContext:context];
    
    [self performFetch:controller];
    return controller;
}

+ (NSFetchedResultsController *)fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context
{
    NSFetchedResultsController *controller = [self fetchAllGroupedBy:groupingKeyPath
                                                       withPredicate:searchTerm
                                                            sortedBy:sortTerm
                                                           ascending:ascending
                                                            delegate:delegate
                                                           inContext:context];
	
	[self performFetch:controller];
	return controller;
}

+ (NSFetchedResultsController *)fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    return [self fetchAllGroupedBy:group
                     withPredicate:searchTerm
                          sortedBy:sortTerm
                         ascending:ascending
                          delegate:nil
                         inContext:context];
}

+ (NSFetchedResultsController *)fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllSortedBy:sortTerm
                                             ascending:ascending
                                         withPredicate:searchTerm
                                             inContext:context];
    
    NSFetchedResultsController *controller = [self fetchController:request
                                                          delegate:delegate
                                                      useFileCache:NO
                                                         groupedBy:group
                                                         inContext:context];
    
    [self performFetch:controller];
    return controller;
}


#endif



@end
