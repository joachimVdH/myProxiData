//
//  Proximus.m
//  Proximus
//
//  Created by Joachim on 31/08/10.
//  Copyright 2010 4d.be. All rights reserved.
//

#import "Proximus.h"
#import "ASIFormDataRequest.h"
#import "TFHpple.h"
#import "AppDelegate.h"
#import "EntryLog.h"

@implementation Proximus

@synthesize delegate;
@synthesize managedObjectContext;
@synthesize entryLog;

- (void)dealloc {
  [entryLog release];
	[managedObjectContext release];
	[delegate release];
	[super dealloc];
}

- (void)setCredentials:(NSString *)mobileNumber yourPassword:(NSString *)password {
	DLog(@"setCredentials start") ;
  if (entryLog != nil &&  [[NSDate date] timeIntervalSinceDate:entryLog.createdAt] < 3600 ){
    entryLog.lastRefresh = [NSDate date];
		[[self delegate] proximusDidAddData];
    DLog(@"setCredentials stopped : refresh in less then an hour") ;
  }else{
	NSURL *url = [NSURL URLWithString:@"https://secure.proximus.be/LOG/login"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setDelegate:self];
	[request setPostValue:mobileNumber forKey:@"msisdn"];
	[request setPostValue:password forKey:@"password"];
	[request setPostValue:@"http://m.skynet.be/my-account/login?new_lang=nl" forKey:@"referrerurl"];
	[request setPostValue:@"mobile" forKey:@"laf"];
	[request setPostValue:@"https://secure.proximus.be/selfcare/usage/view/usage/show?&lan=nl&new_lang=nl" forKey:@"fromurl"];
	[request setPostValue:@"nl" forKey:@"lan"];
	[request setPostValue:@"login" forKey:@"login"];
	[request setPostValue:@"Submit !" forKey:@"submit"];
	[request setDidFinishSelector:@selector(loginDone:)];
	[request setDidFailSelector:@selector(loginError:)];
	[request startAsynchronous];
  }
	DLog(@"setCredentials end") ;
}

- (void)grabURLInBackground {
	DLog(@"grabURLInBackground start") ;
	// 2010
  //NSURL *url = [NSURL URLWithString:@"https://secure.proximus.be/selfcare/usage/view/usage/show?&lan=nl&new_lang=en"];
  // 2011
  NSURL *url = [NSURL URLWithString:@"https://secure.proximus.be/selfcare/usage/view/usage/show?lan=nl"];
  
	ASIFormDataRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(getDataDone:)];
	[request setDidFailSelector:@selector(getDataError:)];
	[request startAsynchronous];
	DLog(@"grabURLInBackground end") ;
}

- (void)loginDone:(ASIHTTPRequest *)request {
	DLog(@"loginDone start") ;
	NSString *responsedata = [request responseString];	
	//DLog(@"loginDone : %@",responsedata);
	ZAssert([responsedata length] <= 160,@"lenght of login response : %i",[responsedata length]);
	if ([responsedata length] <= 160) {
		//DLog(@"lenght ok : %d",[responsedata length]);
		[self grabURLInBackground];
	} else {
		DLog(@"lenght not ok : %d",[responsedata length]);
		UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:NSLocalizedString(@"no success",@"no success alert title")
                               message:NSLocalizedString(@"Mobile number or password are not correct",@"Mobile number or password are not correct")
                               delegate:nil
                               cancelButtonTitle:@"ok"
                               otherButtonTitles:nil];
		
		[errorAlert show];
		[errorAlert release];
	}	
	DLog(@"loginDone end") ;
}

- (void)loginError:(ASIHTTPRequest *)request {
	//NSError *error = [request error];
	//DLog(@"loginError : %@",error);
	
	UIAlertView *errorAlert = [[UIAlertView alloc]
                             initWithTitle:NSLocalizedString(@"connection error",@"connection error alert title")
                             message:NSLocalizedString(@"No internet connection available",@"No internet connection available")
                             delegate:nil
                             cancelButtonTitle:@"ok"
                             otherButtonTitles:nil];
	
	[errorAlert show];
	[errorAlert release];
	
}

- (void)getDataDone:(ASIHTTPRequest *)request {
	DLog(@"getDataDone start") ;
	NSData *responsedata = [request responseData];	
	//DLog(@"getDataDone : %@",responsedata);
	[self parseData:responsedata];
	DLog(@"getDataDone end");
}

- (void)getDataError:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	DLog(@"getDataError : %@",error);
}

- (void)parseData:(NSData *)html {
	DLog(@"parseData ---- start");
	TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:html];
	NSArray *elements  = [xpathParser search:@"//div[@class='articleBody']//p//strong"];
	
	if ([elements count] == 3){
		
		float used = 0.0;
		float volume = 0.0;
		NSDate *periodFrom = nil;
		NSDate *periodTo = nil;
		int counter;
		counter = 1;
		
		NSRange textRange;
		
		// assume when 3 you've got the data (less are remarks or not available ?)
		for (TFHppleElement *element in elements) {
			DLog(@"element: %@", [element content]);
			if(1 == counter){
				textRange =[[element content] rangeOfString:@"GB"];
				if(textRange.location != NSNotFound)
				{
					used = [[[element content] stringByReplacingOccurrencesOfString:@" GB" withString:@""] floatValue] * 1024;
				} else	{
					used = [[[element content] stringByReplacingOccurrencesOfString:@" MB" withString:@""] floatValue];
				}
			}else if (3 == counter) {
				textRange =[[element content] rangeOfString:@"GB"];
				if(textRange.location != NSNotFound)
				{
					volume = [[[element content] stringByReplacingOccurrencesOfString:@" MB" withString:@""] floatValue] *1024;
				} else	{
					volume = [[[element content] stringByReplacingOccurrencesOfString:@" MB" withString:@""] floatValue];
				}
			}
			counter++;
		}
		
		//[elements release],elements = nil;
		elements = [xpathParser search:@"//div[@class='articleBody']//p//span[@class='date']"];
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		// 2010 format
    //[dateFormat setDateFormat:@"dd/MM/yyyy - HH:mm"];
		// 2011 format              ma, jan 10, '11 - 00:00 after parsing => jan 10, 11 - 00:00
    [dateFormat setDateFormat:@"MMM dd, yy - HH:mm"];
    
		counter = 1;
		for (TFHppleElement *element in elements) {
			DLog(@"element: %@", [element content]);
			if(1 == counter){
				periodFrom = [dateFormat dateFromString:[[[element content] stringByReplacingOccurrencesOfString:@"'" withString:@""] substringFromIndex:4 ]];
				ZAssert(periodFrom != nil ,@"Must be a date !! : %@",[element content]);
			}else {
				periodTo = [dateFormat dateFromString:[[[element content] stringByReplacingOccurrencesOfString:@"'" withString:@""] substringFromIndex:4 ]];
				ZAssert(periodTo != nil ,@"Must be a date !! : %@",[element content]);
			}
			counter++;
		}
		
		NSError *error = nil;
		
		EntryLog *newEntryLog = [NSEntityDescription insertNewObjectForEntityForName:@"EntryLog" inManagedObjectContext:managedObjectContext];
		
		newEntryLog.used = [NSNumber numberWithFloat:used];
		newEntryLog.volume = [NSNumber numberWithFloat:volume];
		newEntryLog.periodFrom = periodFrom;
		newEntryLog.periodTo = periodTo;
		newEntryLog.createdAt = [NSDate date];
		newEntryLog.lastRefresh = [NSDate date];
    
		/*
     [entryLog setValue:[NSNumber numberWithFloat:used] forKey:@"used"];
     [entryLog setValue:[NSNumber numberWithFloat:volume] forKey:@"volume"];
     [entryLog setValue:periodFrom  forKey:@"periodFrom"];
     [entryLog setValue:periodTo forKey:@"periodTo"];
     [entryLog setValue:[NSDate date] forKey:@"createdAt"];
     */
		
		ZAssert([managedObjectContext save:&error], @"Error %@\n%@", [error localizedDescription], [error userInfo]);
    
		[dateFormat release];
    [error	release];
		
	} else {
		DLog(@"%@",@"no three elements for data");
    
    if (entryLog != nil) {
      entryLog.lastRefresh = [NSDate date];
      //ZAssert([managedObjectContext save:&error], @"Error %@\n%@", [error localizedDescription], [error userInfo]);
    }
	}
  
  [[self delegate] proximusDidAddData];
	[xpathParser release];
	DLog(@"parseData ---- end");
	//return myTitle;
}

@end
