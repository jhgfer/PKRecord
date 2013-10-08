// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDAnimation.h instead.

#import <CoreData/CoreData.h>


extern const struct CDAnimationAttributes {
	__unsafe_unretained NSString *aid;
	__unsafe_unretained NSString *title;
} CDAnimationAttributes;

extern const struct CDAnimationRelationships {
} CDAnimationRelationships;

extern const struct CDAnimationFetchedProperties {
} CDAnimationFetchedProperties;





@interface CDAnimationID : NSManagedObjectID {}
@end

@interface _CDAnimation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CDAnimationID*)objectID;





@property (nonatomic, strong) NSNumber* aid;



@property int64_t aidValue;
- (int64_t)aidValue;
- (void)setAidValue:(int64_t)value_;

//- (BOOL)validateAid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






@end

@interface _CDAnimation (CoreDataGeneratedAccessors)

@end

@interface _CDAnimation (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAid;
- (void)setPrimitiveAid:(NSNumber*)value;

- (int64_t)primitiveAidValue;
- (void)setPrimitiveAidValue:(int64_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
