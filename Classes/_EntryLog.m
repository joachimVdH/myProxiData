// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EntryLog.m instead.

#import "_EntryLog.h"

@implementation EntryLogID
@end

@implementation _EntryLog

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"EntryLog" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"EntryLog";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"EntryLog" inManagedObjectContext:moc_];
}

- (EntryLogID*)objectID {
	return (EntryLogID*)[super objectID];
}




@dynamic used;



- (float)usedValue {
	NSNumber *result = [self used];
	return [result floatValue];
}

- (void)setUsedValue:(float)value_ {
	[self setUsed:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveUsedValue {
	NSNumber *result = [self primitiveUsed];
	return [result floatValue];
}

- (void)setPrimitiveUsedValue:(float)value_ {
	[self setPrimitiveUsed:[NSNumber numberWithFloat:value_]];
}





@dynamic periodTo;






@dynamic volume;



- (float)volumeValue {
	NSNumber *result = [self volume];
	return [result floatValue];
}

- (void)setVolumeValue:(float)value_ {
	[self setVolume:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveVolumeValue {
	NSNumber *result = [self primitiveVolume];
	return [result floatValue];
}

- (void)setPrimitiveVolumeValue:(float)value_ {
	[self setPrimitiveVolume:[NSNumber numberWithFloat:value_]];
}





@dynamic periodFrom;






@dynamic periodFromText;






@dynamic lastRefresh;






@dynamic periodToText;






@dynamic createdAt;










@end
