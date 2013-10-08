// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDGame.h instead.

#import <CoreData/CoreData.h>


extern const struct CDGameAttributes {
	__unsafe_unretained NSString *gid;
	__unsafe_unretained NSString *title;
} CDGameAttributes;

extern const struct CDGameRelationships {
} CDGameRelationships;

extern const struct CDGameFetchedProperties {
} CDGameFetchedProperties;





@interface CDGameID : NSManagedObjectID {}
@end

@interface _CDGame : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CDGameID*)objectID;





@property (nonatomic, strong) NSNumber* gid;



@property int64_t gidValue;
- (int64_t)gidValue;
- (void)setGidValue:(int64_t)value_;

//- (BOOL)validateGid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






@end

@interface _CDGame (CoreDataGeneratedAccessors)

@end

@interface _CDGame (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveGid;
- (void)setPrimitiveGid:(NSNumber*)value;

- (int64_t)primitiveGidValue;
- (void)setPrimitiveGidValue:(int64_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
