// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Animation.m instead.

#import "_Animation.h"

const struct AnimationAttributes AnimationAttributes = {
	.aid = @"aid",
	.title = @"title",
};

const struct AnimationRelationships AnimationRelationships = {
};

const struct AnimationFetchedProperties AnimationFetchedProperties = {
};

@implementation AnimationID
@end

@implementation _Animation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Animation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Animation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Animation" inManagedObjectContext:moc_];
}

- (AnimationID*)objectID {
	return (AnimationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"aidValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"aid"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic aid;



- (int64_t)aidValue {
	NSNumber *result = [self aid];
	return [result longLongValue];
}

- (void)setAidValue:(int64_t)value_ {
	[self setAid:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveAidValue {
	NSNumber *result = [self primitiveAid];
	return [result longLongValue];
}

- (void)setPrimitiveAidValue:(int64_t)value_ {
	[self setPrimitiveAid:[NSNumber numberWithLongLong:value_]];
}





@dynamic title;











@end
