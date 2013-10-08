// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Comics.m instead.

#import "_Comics.h"

const struct ComicsAttributes ComicsAttributes = {
	.cid = @"cid",
	.title = @"title",
};

const struct ComicsRelationships ComicsRelationships = {
};

const struct ComicsFetchedProperties ComicsFetchedProperties = {
};

@implementation ComicsID
@end

@implementation _Comics

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Comics" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Comics";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Comics" inManagedObjectContext:moc_];
}

- (ComicsID*)objectID {
	return (ComicsID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"cidValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"cid"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic cid;



- (int64_t)cidValue {
	NSNumber *result = [self cid];
	return [result longLongValue];
}

- (void)setCidValue:(int64_t)value_ {
	[self setCid:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveCidValue {
	NSNumber *result = [self primitiveCid];
	return [result longLongValue];
}

- (void)setPrimitiveCidValue:(int64_t)value_ {
	[self setPrimitiveCid:[NSNumber numberWithLongLong:value_]];
}





@dynamic title;











@end
