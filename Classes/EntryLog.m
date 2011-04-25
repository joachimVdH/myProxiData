#import "EntryLog.h"

@implementation EntryLog

-(int)consumed{
	return [[self used] intValue]+1;
}

-(int)toUse{
	if ([[self volume] intValue] == 0 || [[self volume] intValue] < [self consumed] ) {
		return 0;
	}		
	return	[[self volume] intValue]-[self consumed];
}

-(float)percentage{
	//DLog(@"used : %f", [[self used] floatValue]);
	//DLog(@"volume : %f", [[self volume] floatValue]);
  
	if ([[self volume] intValue] <= [self consumed]) {
		return 1;
	}
	
  NSDecimalNumber *u =[NSDecimalNumber decimalNumberWithDecimal:[[self used] decimalValue]];
  NSDecimalNumber *v =[NSDecimalNumber decimalNumberWithDecimal:[[self volume] decimalValue]];
  NSDecimalNumber *r =[u decimalNumberByDividingBy:v];
  //DLog(@"NSDecimalNumber : %@ / %@ = %@",u,v,r);
  
  if ([r floatValue] > 1) {
    return 1;
  } else if ([r floatValue] < 0) {
    return 0;
  }
  return [r floatValue];
}

-(NSDate*)xDate{
  
  if ([self periodFrom] == nil ) {
    [self parseDateString];
  }
  return [self periodFrom];
}

-(id)parseDateString{
  NSDate *date = nil;
  @try{
    //9 mrt '11 - 18:19
    //10 mrt '11 - 23:32
    
    NSString *t = [[[self periodFromText] substringWithRange:NSMakeRange(0,2)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int day = [t integerValue];
    [t release];
    
    t = [[[self periodFromText] substringWithRange:NSMakeRange(2,4)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int month = [self getMonthByString:t];
    [t release];
    
    t = [[[[self periodFromText] substringWithRange:NSMakeRange(7,3)] stringByReplacingOccurrencesOfString:@"'" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int year = [t integerValue];
    [t release];
    
    t = [[[self periodFromText] substringWithRange:NSMakeRange([[self periodFromText] length] -5 ,2)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int hours = [t integerValue];
    [t release];
    
    t = [[[self periodFromText] substringWithRange:NSMakeRange([[self periodFromText] length] -2 ,2)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int minutes = [t integerValue];
    [t release];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    [components setHour:hours];
    [components setMinute:minutes];
    [components setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CET"]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    date = [calendar dateFromComponents:components];
    
    [self setValue:date forKey:@"periodFrom"];
    [components release];
    [calendar release];
  }
  @catch(id theException){
    DLog(@"%@", theException);
    date = nil;
  }
  return date;
}

-(int)getMonthByString:(NSString*)monthString{
  /*
   
  ,['janv.','f&eacute;vr.','mars','avr.','mai','juin','juil.','ao&#369;t','sept.','oct.','nov.','d&eacute;c.']
 
  */
  
  if([[monthString lowercaseString] isEqualToString:@"jan"] == true){return 1;}
  if([[monthString lowercaseString] isEqualToString:@"feb"] == true){return 2;}
  if([[monthString lowercaseString] isEqualToString:@"mrt"] == true){return 3;}
  if([[monthString lowercaseString] isEqualToString:@"mar"] == true){return 3;}
  if([[monthString lowercaseString] isEqualToString:@"apr"] == true){return 4;}
  if([[monthString lowercaseString] isEqualToString:@"mei"] == true){return 5;}
  if([[monthString lowercaseString] isEqualToString:@"may"] == true){return 5;}
  if([[monthString lowercaseString] isEqualToString:@"jun"] == true){return 6;}
  if([[monthString lowercaseString] isEqualToString:@"jul"] == true){return 7;}
  if([[monthString lowercaseString] isEqualToString:@"aug"] == true){return 8;}
  if([[monthString lowercaseString] isEqualToString:@"sep"] == true){return 9;}
  if([[monthString lowercaseString] isEqualToString:@"okt"] == true){return 10;}
  if([[monthString lowercaseString] isEqualToString:@"oct"] == true){return 10;}  
  if([[monthString lowercaseString] isEqualToString:@"nov"] == true){return 11;}
  if([[monthString lowercaseString] isEqualToString:@"dec"] == true){return 12;}
  return 0;

}

@end
