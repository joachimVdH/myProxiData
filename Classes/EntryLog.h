#import "_EntryLog.h"

@interface EntryLog : _EntryLog {}
-(int)consumed;
-(int)toUse;
-(float)percentage;
-(id)parseDateString;
-(int)getMonthByString:(NSString*)monthString;
@end
