// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDGame.m instead.

#import "_CDGame.h"

const struct CDGameAttributes CDGameAttributes = {
	.gid = @"gid",
	.title = @"title",
};

const struct CDGameRelationships CDGameRelationships = {
};

const struct CDGameFetchedProperties CDGameFetchedProperties = {
};

@implementation CDGameID
@end

@implementation _CDGame

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CDGame" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CDGame";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CDGame" inManagedObjectContext:moc_];
}

- (CDGameID*)objectID {
	return (CDGameID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"gidValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"gid"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic gid;



- (int64_t)gidValue {
	NSNumber *result = [self gid];
	return [result longLongValue];
}

- (void)setGidValue:(int64_t)value_ {
	[self setGid:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveGidValue {
	NSNumber *result = [self primitiveGid];
	return [result longLongValue];
}

- (void)setPrimitiveGidValue:(int64_t)value_ {
	[self setPrimitiveGid:[NSNumber numberWithLongLong:value_]];
}





@dynamic title;











@end
