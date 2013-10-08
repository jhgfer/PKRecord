// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDAnimation.m instead.

#import "_CDAnimation.h"

const struct CDAnimationAttributes CDAnimationAttributes = {
	.aid = @"aid",
	.title = @"title",
};

const struct CDAnimationRelationships CDAnimationRelationships = {
};

const struct CDAnimationFetchedProperties CDAnimationFetchedProperties = {
};

@implementation CDAnimationID
@end

@implementation _CDAnimation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CDAnimation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CDAnimation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CDAnimation" inManagedObjectContext:moc_];
}

- (CDAnimationID*)objectID {
	return (CDAnimationID*)[super objectID];
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
