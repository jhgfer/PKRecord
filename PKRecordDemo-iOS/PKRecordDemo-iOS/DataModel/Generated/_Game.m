// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Game.m instead.

#import "_Game.h"

const struct GameAttributes GameAttributes = {
	.gid = @"gid",
	.title = @"title",
};

const struct GameRelationships GameRelationships = {
};

const struct GameFetchedProperties GameFetchedProperties = {
};

@implementation GameID
@end

@implementation _Game

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Game";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Game" inManagedObjectContext:moc_];
}

- (GameID*)objectID {
	return (GameID*)[super objectID];
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
