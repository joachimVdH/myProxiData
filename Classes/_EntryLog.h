// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EntryLog.h instead.

#import <CoreData/CoreData.h>










@interface EntryLogID : NSManagedObjectID {}
@end

@interface _EntryLog : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (EntryLogID*)objectID;



@property (nonatomic, retain) NSDate *createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *lastRefresh;

//- (BOOL)validateLastRefresh:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *used;

@property float usedValue;
- (float)usedValue;
- (void)setUsedValue:(float)value_;

//- (BOOL)validateUsed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *periodFrom;

//- (BOOL)validatePeriodFrom:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *volume;

@property float volumeValue;
- (float)volumeValue;
- (void)setVolumeValue:(float)value_;

//- (BOOL)validateVolume:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *periodTo;

//- (BOOL)validatePeriodTo:(id*)value_ error:(NSError**)error_;





@end

@interface _EntryLog (CoreDataGeneratedAccessors)

@end

@interface _EntryLog (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;


- (NSDate*)primitiveLastRefresh;
- (void)setPrimitiveLastRefresh:(NSDate*)value;


- (NSNumber*)primitiveUsed;
- (void)setPrimitiveUsed:(NSNumber*)value;

- (float)primitiveUsedValue;
- (void)setPrimitiveUsedValue:(float)value_;


- (NSDate*)primitivePeriodFrom;
- (void)setPrimitivePeriodFrom:(NSDate*)value;


- (NSNumber*)primitiveVolume;
- (void)setPrimitiveVolume:(NSNumber*)value;

- (float)primitiveVolumeValue;
- (void)setPrimitiveVolumeValue:(float)value_;


- (NSDate*)primitivePeriodTo;
- (void)setPrimitivePeriodTo:(NSDate*)value;



@end
