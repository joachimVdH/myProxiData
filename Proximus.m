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
#import "CSqliteDatabase.h"
#import "myProxiDataAppDelegate.h"

@implementation Proximus

@synthesize delegate;

- (void)dealloc {
	[delegate release];
    [super dealloc];
}

- (void)setCredentials:(NSString *)mobileNumber yourPassword:(NSString *)password
{
	NSLog(@"setCredentials start") ;
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
	NSLog(@"setCredentials end") ;
}

- (void)grabURLInBackground
{
	NSLog(@"grabURLInBackground start") ;
	NSURL *url = [NSURL URLWithString:@"https://secure.proximus.be/selfcare/usage/view/usage/show?&lan=nl&new_lang=nl"];
	ASIFormDataRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(getDataDone:)];
	[request setDidFailSelector:@selector(getDataError:)];
	[request startAsynchronous];
	NSLog(@"grabURLInBackground end") ;
}

- (void)loginDone:(ASIHTTPRequest *)request
{
	NSLog(@"loginDone start") ;
	NSString *responsedata = [request responseString];	
	//NSLog(@"loginDone : %@",responsedata);
	if ([responsedata length] == 159) {
		NSLog(@"lenght ok : %d",[responsedata length]);
		
		[self grabURLInBackground];
	} else {
		NSLog(@"lenght not ok : %d",[responsedata length]);
		
		UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle:@"no success"
								   message:[NSString stringWithFormat:@"%@",@"Mobile number or password are not correct"]
								   delegate:nil
								   cancelButtonTitle:@"ok"
								   otherButtonTitles:nil];
		
		[errorAlert show];
		[errorAlert release];
	}	
	NSLog(@"loginDone end") ;
}

- (void)loginError:(ASIHTTPRequest *)request
{
	//NSError *error = [request error];
	//NSLog(@"loginError : %@",error);
	
	UIAlertView *errorAlert = [[UIAlertView alloc]
							  initWithTitle:@"connection error"
							  message:[NSString stringWithFormat:@"%@",@"No internet connection available"]
							  delegate:nil
							  cancelButtonTitle:@"ok"
							  otherButtonTitles:nil];
	
	[errorAlert show];
	[errorAlert release];
	
}

- (void)getDataDone:(ASIHTTPRequest *)request
{
	NSLog(@"getDataDone start") ;
	NSData *responsedata = [request responseData];	
	//NSLog(@"getDataDone : %@",responsedata);
	[self parseData:responsedata];
	NSLog(@"getDataDone end");
}

- (void)getDataError:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"getDataError : %@",error);
}

- (void)parseData:(NSData *)html
{
	NSLog(@"parseData ---- start");
	TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:html];
	NSArray *elements  = [xpathParser search:@"//div[@class='articleBody']//p//strong"];
	
	if ([elements count] == 3){
		
		BOOL result;
		NSString *expression;
		NSString *used = nil;
		NSString *volume = nil;
		NSString *periodFrom = nil;
		NSString *periodTo = nil;
		int counter;
		counter = 1;
		
		// assume when 3 you've got the data (less are remarks or not available ?)
		for (TFHppleElement *element in elements) {
			NSLog(@"element: %@", [element content]);
			if(1 == counter){
				used = [[element content] stringByReplacingOccurrencesOfString:@" MB" withString:@""];
			}else if (3 == counter) {
				volume = [[element content] stringByReplacingOccurrencesOfString:@" MB" withString:@""];
			}
			counter++;
		}
		
		//[elements release],elements = nil;
		elements = [xpathParser search:@"//div[@class='articleBody']//p//span[@class='date']"];
		
		//NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		//[dateFormat setDateFormat:@"dd/MM/yyyy - HHmm"];
		
		counter = 1;
		for (TFHppleElement *element in elements) {
			NSLog(@"element: %@", [element content]);
			if(1 == counter){
				periodFrom = [element content];
			}else {
				periodTo = [element content];
			}
			counter++;
		}
		
		expression = [NSString stringWithFormat:@"INSERT INTO logs (used,volume,periodFrom,periodTo) VALUES (%@,%@,'%@','%@')", used ,volume, periodFrom,periodTo, nil];
		NSLog(@"sql expression : %@",expression);
		myProxiDataAppDelegate *appDelegate = (myProxiDataAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		result = [appDelegate.db executeExpression:expression error:NULL];
		NSLog(@"dbresult %d", result);
		//[appDelegate release];
		
		[[self delegate] proximusDidAddData];
		
		//[elements release],elements = nil;
		//[dateFormat release],dateFormat = nil;
		
	} else {
		NSLog(@"%@",@"no three elements for data");
	}

	[xpathParser release];
	NSLog(@"parseData ---- end");
	//return myTitle;
}

@end