// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDComics.h instead.

#import <CoreData/CoreData.h>


extern const struct CDComicsAttributes {
	__unsafe_unretained NSString *cid;
	__unsafe_unretained NSString *title;
} CDComicsAttributes;

extern const struct CDComicsRelationships {
} CDComicsRelationships;

extern const struct CDComicsFetchedProperties {
} CDComicsFetchedProperties;





@interface CDComicsID : NSManagedObjectID {}
@end

@interface _CDComics : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CDComicsID*)objectID;





@property (nonatomic, strong) NSNumber* cid;



@property int64_t cidValue;
- (int64_t)cidValue;
- (void)setCidValue:(int64_t)value_;

//- (BOOL)validateCid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






@end

@interface _CDComics (CoreDataGeneratedAccessors)

@end

@interface _CDComics (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCid;
- (void)setPrimitiveCid:(NSNumber*)value;

- (int64_t)primitiveCidValue;
- (void)setPrimitiveCidValue:(int64_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
