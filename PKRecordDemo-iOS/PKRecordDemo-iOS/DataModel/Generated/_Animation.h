// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Animation.h instead.

#import <CoreData/CoreData.h>


extern const struct AnimationAttributes {
	__unsafe_unretained NSString *aid;
	__unsafe_unretained NSString *title;
} AnimationAttributes;

extern const struct AnimationRelationships {
} AnimationRelationships;

extern const struct AnimationFetchedProperties {
} AnimationFetchedProperties;





@interface AnimationID : NSManagedObjectID {}
@end

@interface _Animation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AnimationID*)objectID;





@property (nonatomic, strong) NSNumber* aid;



@property int64_t aidValue;
- (int64_t)aidValue;
- (void)setAidValue:(int64_t)value_;

//- (BOOL)validateAid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






@end

@interface _Animation (CoreDataGeneratedAccessors)

@end

@interface _Animation (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAid;
- (void)setPrimitiveAid:(NSNumber*)value;

- (int64_t)primitiveAidValue;
- (void)setPrimitiveAidValue:(int64_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
