//
//  NSManagedObject+PKRecord.m
//  PKTestProj
//
//  Created by zhongsheng on 13-9-29.
//  Copyright (c) 2013年 zhongsheng. All rights reserved.
//

#import "NSManagedObject+PKRecord.h"
#import "NSManagedObject+PKRequest.h"
#import "NSManagedObject+PKFinder.h"
#import "PKRecord+ErrorHandling.h"

static NSUInteger defaultBatchSize = kPKRecordDefaultBatchSize;


@implementation NSManagedObject (PKRecord)

+ (NSUInteger)defaultBatchSize
{
    return defaultBatchSize;
}

+ (void)setDefaultBatchSize:(NSUInteger)newBatchSize
{
    @synchronized(self)
	{
		defaultBatchSize = newBatchSize;
	}
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
    __block NSArray *results = nil;
    [context performBlockAndWait:^{
        
        NSError *error = nil;
        
        results = [context executeFetchRequest:request error:&error];
        
        if (results == nil)
        {
            [PKRecord handleErrors:error];
        }
    }];
	return results;
}
+ (instancetype)executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
    [request setFetchLimit:1];
	
	NSArray *results = [self executeFetchRequest:request inContext:context];
	if ([results count] == 0)
	{
		return nil;
	}
	return [results objectAtIndex:0];
}

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
+ (void)performFetch:(NSFetchedResultsController *)controller
{
    NSError *error = nil;
	if (![controller performFetch:&error])
	{
		[PKRecord handleErrors:error];
	}
}
#endif

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context
{
    if ([self respondsToSelector:@selector(entityInManagedObjectContext:)])
    {// mogenerator script
        NSEntityDescription *entity = [self performSelector:@selector(entityInManagedObjectContext:) withObject:context];
        return entity;
    }
    else
    {
        return [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
    }

}
+ (NSArray *)propertiesNamed:(NSArray *)properties inContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *description = [self entityDescriptionInContext:context];
	NSMutableArray *propertiesWanted = [NSMutableArray array];
	
	if (properties)
	{
		NSDictionary *propDict = [description propertiesByName];
		
		for (NSString *propertyName in properties)
		{
			NSPropertyDescription *property = [propDict objectForKey:propertyName];
			if (property)
			{
				[propertiesWanted addObject:property];
			}
			else
			{
				NSLog(@"Property '%@' not found in %lx properties for %@", propertyName, (unsigned long)[propDict count], NSStringFromClass(self));
			}
		}
	}
	return propertiesWanted;
}

+ (instancetype)createInContext:(NSManagedObjectContext *)context
{
    if ([self respondsToSelector:@selector(insertInManagedObjectContext:)])
    {// mogenerator script
        id entity = [self performSelector:@selector(insertInManagedObjectContext:) withObject:context];
        return entity;
    }
    else
    {
        return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
    }
}

- (BOOL)deleteInContext:(NSManagedObjectContext *)context
{
    [context deleteObject:self];
	return YES;
}

+ (BOOL)deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllWithPredicate:predicate inContext:context];
    [request setReturnsObjectsAsFaults:YES];
	[request setIncludesPropertyValues:NO];
    
	NSArray *objectsToTruncate = [self executeFetchRequest:request inContext:context];
    
	for (id objectToTruncate in objectsToTruncate)
    {
		[objectToTruncate deleteInContext:context];
	}
    
	return YES;
}

+ (BOOL)truncateAllInContext:(NSManagedObjectContext *)context
{
    NSArray *allEntities = [self findAllInContext:context];
    for (NSManagedObject *obj in allEntities)
    {
        [obj deleteInContext:context];
    }
    return YES;
}

+ (NSArray *)ascendingSortDescriptors:(NSArray *)attributesToSortBy
{
    return [self sortAscending:YES attributes:attributesToSortBy];
}
+ (NSArray *)descendingSortDescriptors:(NSArray *)attributesToSortBy
{
    return [self sortAscending:NO attributes:attributesToSortBy];
}

- (instancetype)objectInContext:(NSManagedObjectContext *)otherContext
{
    NSError *error = nil;
    NSManagedObject *inContext = [otherContext existingObjectWithID:[self objectID] error:&error];
    [PKRecord handleErrors:error];
    return inContext;
}

#pragma mark - Private

+ (NSArray *)sortAscending:(BOOL)ascending attributes:(NSArray *)attributesToSortBy
{
	NSMutableArray *attributes = [NSMutableArray array];
    
    for (NSString *attributeName in attributesToSortBy)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending];
        [attributes addObject:sortDescriptor];
    }
    
	return attributes;
}


@end
