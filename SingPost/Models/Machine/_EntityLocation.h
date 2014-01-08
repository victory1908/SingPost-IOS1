// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EntityLocation.h instead.

#import <CoreData/CoreData.h>


extern const struct EntityLocationAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *contactNumber;
	__unsafe_unretained NSString *fri_closing;
	__unsafe_unretained NSString *fri_opening;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *mon_closing;
	__unsafe_unretained NSString *mon_opening;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *notification;
	__unsafe_unretained NSString *ph_closing;
	__unsafe_unretained NSString *ph_opening;
	__unsafe_unretained NSString *postingbox;
	__unsafe_unretained NSString *sat_closing;
	__unsafe_unretained NSString *sat_opening;
	__unsafe_unretained NSString *services;
	__unsafe_unretained NSString *sun_closing;
	__unsafe_unretained NSString *sun_opening;
	__unsafe_unretained NSString *thu_closing;
	__unsafe_unretained NSString *thu_opening;
	__unsafe_unretained NSString *town;
	__unsafe_unretained NSString *tue_closing;
	__unsafe_unretained NSString *tue_opening;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *wed_closing;
	__unsafe_unretained NSString *wed_opening;
} EntityLocationAttributes;

extern const struct EntityLocationRelationships {
} EntityLocationRelationships;

extern const struct EntityLocationFetchedProperties {
} EntityLocationFetchedProperties;





























@interface EntityLocationID : NSManagedObjectID {}
@end

@interface _EntityLocation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (EntityLocationID*)objectID;





@property (nonatomic, strong) NSString* address;



//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* contactNumber;



//- (BOOL)validateContactNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* fri_closing;



//- (BOOL)validateFri_closing:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* fri_opening;



//- (BOOL)validateFri_opening:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* latitude;



//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* longitude;



//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* mon_closing;



//- (BOOL)validateMon_closing:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* mon_opening;



//- (BOOL)validateMon_opening:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* notification;



//- (BOOL)validateNotification:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* ph_closing;



//- (BOOL)validatePh_closing:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* ph_opening;



//- (BOOL)validatePh_opening:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* postingbox;



//- (BOOL)validatePostingbox:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sat_closing;



//- (BOOL)validateSat_closing:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sat_opening;



//- (BOOL)validateSat_opening:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* services;



//- (BOOL)validateServices:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sun_closing;



//- (BOOL)validateSun_closing:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sun_opening;



//- (BOOL)validateSun_opening:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* thu_closing;



//- (BOOL)validateThu_closing:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* thu_opening;



//- (BOOL)validateThu_opening:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* town;



//- (BOOL)validateTown:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tue_closing;



//- (BOOL)validateTue_closing:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tue_opening;



//- (BOOL)validateTue_opening:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* wed_closing;



//- (BOOL)validateWed_closing:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* wed_opening;



//- (BOOL)validateWed_opening:(id*)value_ error:(NSError**)error_;






@end

@interface _EntityLocation (CoreDataGeneratedAccessors)

@end

@interface _EntityLocation (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;




- (NSString*)primitiveContactNumber;
- (void)setPrimitiveContactNumber:(NSString*)value;




- (NSString*)primitiveFri_closing;
- (void)setPrimitiveFri_closing:(NSString*)value;




- (NSString*)primitiveFri_opening;
- (void)setPrimitiveFri_opening:(NSString*)value;




- (NSString*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSString*)value;




- (NSString*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSString*)value;




- (NSString*)primitiveMon_closing;
- (void)setPrimitiveMon_closing:(NSString*)value;




- (NSString*)primitiveMon_opening;
- (void)setPrimitiveMon_opening:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveNotification;
- (void)setPrimitiveNotification:(NSString*)value;




- (NSString*)primitivePh_closing;
- (void)setPrimitivePh_closing:(NSString*)value;




- (NSString*)primitivePh_opening;
- (void)setPrimitivePh_opening:(NSString*)value;




- (NSString*)primitivePostingbox;
- (void)setPrimitivePostingbox:(NSString*)value;




- (NSString*)primitiveSat_closing;
- (void)setPrimitiveSat_closing:(NSString*)value;




- (NSString*)primitiveSat_opening;
- (void)setPrimitiveSat_opening:(NSString*)value;




- (NSString*)primitiveServices;
- (void)setPrimitiveServices:(NSString*)value;




- (NSString*)primitiveSun_closing;
- (void)setPrimitiveSun_closing:(NSString*)value;




- (NSString*)primitiveSun_opening;
- (void)setPrimitiveSun_opening:(NSString*)value;




- (NSString*)primitiveThu_closing;
- (void)setPrimitiveThu_closing:(NSString*)value;




- (NSString*)primitiveThu_opening;
- (void)setPrimitiveThu_opening:(NSString*)value;




- (NSString*)primitiveTown;
- (void)setPrimitiveTown:(NSString*)value;




- (NSString*)primitiveTue_closing;
- (void)setPrimitiveTue_closing:(NSString*)value;




- (NSString*)primitiveTue_opening;
- (void)setPrimitiveTue_opening:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;




- (NSString*)primitiveWed_closing;
- (void)setPrimitiveWed_closing:(NSString*)value;




- (NSString*)primitiveWed_opening;
- (void)setPrimitiveWed_opening:(NSString*)value;




@end
