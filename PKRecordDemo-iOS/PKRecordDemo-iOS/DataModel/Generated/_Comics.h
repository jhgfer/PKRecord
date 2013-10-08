// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Comics.h instead.

#import <CoreData/CoreData.h>


extern const struct ComicsAttributes {
	__unsafe_unretained NSString *cid;
	__unsafe_unretained NSString *title;
} ComicsAttributes;

extern const struct ComicsRelationships {
} ComicsRelationships;

extern const struct ComicsFetchedProperties {
} ComicsFetchedProperties;





@interface ComicsID : NSManagedObjectID {}
@end

@interface _Comics : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ComicsID*)objectID;





@property (nonatomic, strong) NSNumber* cid;



@property int64_t cidValue;
- (int64_t)cidValue;
- (void)setCidValue:(int64_t)value_;

//- (BOOL)validateCid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






@end

@interface _Comics (CoreDataGeneratedAccessors)

@end

@interface _Comics (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCid;
- (void)setPrimitiveCid:(NSNumber*)value;

- (int64_t)primitiveCidValue;
- (void)setPrimitiveCidValue:(int64_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
