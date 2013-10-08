// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDComics.m instead.

#import "_CDComics.h"

const struct CDComicsAttributes CDComicsAttributes = {
	.cid = @"cid",
	.title = @"title",
};

const struct CDComicsRelationships CDComicsRelationships = {
};

const struct CDComicsFetchedProperties CDComicsFetchedProperties = {
};

@implementation CDComicsID
@end

@implementation _CDComics

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CDComics" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CDComics";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CDComics" inManagedObjectContext:moc_];
}

- (CDComicsID*)objectID {
	return (CDComicsID*)[super objectID];
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
