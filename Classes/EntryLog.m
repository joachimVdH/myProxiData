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

@end
