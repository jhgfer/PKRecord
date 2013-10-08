//
//  NSManagedObject+PKAggregation.m
//  PKTestProj
//
//  Created by passerbycrk on 13-9-29.
//  Copyright (c) 2013年 passerbycrk. All rights reserved.
//

#import "NSManagedObject+PKAggregation.h"
#import "NSManagedObject+PKRequest.h"
#import "NSManagedObject+PKRecord.h"
#import "PKRecord+ErrorHandling.h"

@implementation NSManagedObject (PKAggregation)

+ (NSUInteger)countOfEntitiesWithContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;
	NSUInteger count = [context countForFetchRequest:[self createFetchRequestInContext:context] error:&error];
	[PKRecord handleErrors:error];
	
    return count;
}

+ (NSUInteger)countOfEntitiesWithPredicate:(NSPredicate *)searchFilter inContext:(NSManagedObjectContext *)context;
{
    NSError *error = nil;
	NSFetchRequest *request = [self createFetchRequestInContext:context];
	[request setPredicate:searchFilter];
	
	NSUInteger count = [context countForFetchRequest:request error:&error];
	[PKRecord handleErrors:error];
    
    return count;
}

+ (BOOL)hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context
{
    return ([self countOfEntitiesWithContext:context] > 0);
}

+ (NSNumber *)aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
    NSExpression *ex = [NSExpression expressionForFunction:function
                                                 arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:attributeName]]];
    
    NSExpressionDescription *ed = [[NSExpressionDescription alloc] init];
    [ed setName:@"result"];
    [ed setExpression:ex];
    
    // determine the type of attribute, required to set the expression return type
    NSAttributeDescription *attributeDescription = [[[self entityDescriptionInContext:context] attributesByName] objectForKey:attributeName];
    [ed setExpressionResultType:[attributeDescription attributeType]];
    NSArray *properties = [NSArray arrayWithObject:ed];
    
    NSFetchRequest *request = [self requestAllWithPredicate:predicate inContext:context];
    [request setPropertiesToFetch:properties];
    [request setResultType:NSDictionaryResultType];
    
    NSDictionary *resultsDictionary = [self executeFetchRequestAndReturnFirstObject:request inContext:context];
    NSNumber *resultValue = [resultsDictionary objectForKey:@"result"];
    
    return resultValue;
}

- (instancetype)objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[self class] createFetchRequestInContext:context];
    
	NSPredicate *searchFor = [NSPredicate predicateWithFormat:@"SELF = %@ AND %K = min(%@)", self, property, property];
	[request setPredicate:searchFor];
	
	return [[self class] executeFetchRequestAndReturnFirstObject:request inContext:context];
}

@end
