// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Game.h instead.

#import <CoreData/CoreData.h>


extern const struct GameAttributes {
	__unsafe_unretained NSString *gid;
	__unsafe_unretained NSString *title;
} GameAttributes;

extern const struct GameRelationships {
} GameRelationships;

extern const struct GameFetchedProperties {
} GameFetchedProperties;





@interface GameID : NSManagedObjectID {}
@end

@interface _Game : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (GameID*)objectID;





@property (nonatomic, strong) NSNumber* gid;



@property int64_t gidValue;
- (int64_t)gidValue;
- (void)setGidValue:(int64_t)value_;

//- (BOOL)validateGid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






@end

@interface _Game (CoreDataGeneratedAccessors)

@end

@interface _Game (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveGid;
- (void)setPrimitiveGid:(NSNumber*)value;

- (int64_t)primitiveGidValue;
- (void)setPrimitiveGidValue:(int64_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
