//
//  MainViewController.m
//  myProxiData
//
//  Created by Joachim on 25/09/10.
//  Copyright 4d.be 2010. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@implementation MainViewController
@synthesize proximus;
@synthesize mbUsed;
@synthesize mbToUse;
@synthesize labelUsed;
@synthesize labelToUse;
@synthesize periodUsage;
@synthesize progressView;
@synthesize status;

- (void)dealloc {
	[mbUsed release];
	[mbToUse release];
	[labelUsed release];
	[labelToUse release];
	[periodUsage release];
	[progressView release];
	[proximus release];
	[status release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"%@", @"viewDidLoad start");
	[super viewDidLoad];

	proximus = [[Proximus alloc] init] ;
	[proximus setDelegate:self]; 
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	NSString *loginMobileNumber = [prefs stringForKey:@"loginMobileNumber"];
	NSString *loginPassword = [prefs stringForKey:@"loginPassword"];
	
	if (nil != loginMobileNumber && nil != loginPassword ){
	
		[proximus setCredentials:loginMobileNumber yourPassword:loginPassword];
		
	} else {
		NSLog(@"NO credentials - Time to flip the screen");		
		
		UIAlertView *noCredentials = [[UIAlertView alloc]
								   initWithTitle:@""
								   message: NSLocalizedString(@"no credentials", @"No mobile number and password available.\nPress i on the bottom right to enter your credentials.") 
									delegate:nil
								   cancelButtonTitle:@"ok"
								   otherButtonTitles:nil];
		
		[noCredentials show];
		[noCredentials release];
		[self flipSide];		
	}
	
	// for debugging
	NSArray *languages = [prefs objectForKey:@"AppleLanguages"];
	NSString *currentLanguage = [languages objectAtIndex:0];
	
	NSLog(@"Current Locale: %@", [[NSLocale currentLocale] localeIdentifier]);
	NSLog(@"Current language: %@", currentLanguage);
	
	[self displayRecentData];
	NSLog(@"%@", @"viewDidLoad end");
}


-(void)displayRecentData{
	NSLog(@"%@", @"displayRecentData start");
	int used ;
	int volume ;
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSError *err = NULL;
	NSArray *rows = [appDelegate.db rowsForExpression:@"SELECT * FROM logs ORDER BY createdAt desc" error:&err];
	NSLog(@"%@", err);
	//NSLog(@"%@", rows);
	
	if ([rows count] > 0){
		NSDictionary *row = [rows objectAtIndex:0];
		//NSLog(@"%@", row);	
		
		used = [[row objectForKey:@"used"] intValue] + 1;
		volume = [[row objectForKey:@"volume"] intValue];
		
		// formatting data start
		NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
		// http://unicode.org/reports/tr35/tr35-4.html#Date_Format_Patterns
		[inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
		//NSLog(@"Raw Date : %@",[row objectForKey:@"createdAt"]);
		NSDate *formatterDate = [inputFormatter dateFromString:[row objectForKey:@"createdAt"]];
		
		NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
		[outputFormatter setDateFormat:@"EEE d MMM HH:mm"];

		status.text = [NSString stringWithFormat:NSLocalizedString(@"Last refresh at", @"Last refresh at %@") , [outputFormatter stringFromDate:formatterDate],nil];
		// formatting data end
		
		// formatting the dates for the usage period
		[inputFormatter setDateFormat:@"dd/MM/yyyy - HH:mm"];
		[outputFormatter setDateFormat:@"d MMM"];
		formatterDate = [inputFormatter dateFromString:[row objectForKey:@"periodFrom"]];
		NSString *temp = [outputFormatter stringFromDate:formatterDate];
		
		[outputFormatter setDateFormat:@"d MMM H:mm"];
		formatterDate = [inputFormatter dateFromString:[row objectForKey:@"periodTo"]];
		
		periodUsage.text = [NSString stringWithFormat:NSLocalizedString(@"usage from to",@"usage from %@ to %@"),temp,[outputFormatter stringFromDate:formatterDate],nil];
		
		if (used > 999) { 
			labelUsed.text = [NSString stringWithFormat:NSLocalizedString(@"MB used",@"%@ used"),@"GB",nil];
		} else {
			labelUsed.text = [NSString stringWithFormat:NSLocalizedString(@"MB used",@"%@ used"),@"MB",nil];
		}
		
		if ((volume-used) > 999) { 
			labelToUse.text = [NSString stringWithFormat:NSLocalizedString(@"MB to use",@"%@ to use"),@"GB",nil];
		} else {
			labelToUse.text = [NSString stringWithFormat:NSLocalizedString(@"MB to use",@"%@ to use"),@"MB",nil];
		}

		[inputFormatter release];
		[outputFormatter release];
		
		// setting the data labels
		if (used > 999) {
			mbUsed.text = [NSString stringWithFormat:@"%d", used/1024];
		} else {
			mbUsed.text = [NSString stringWithFormat:@"%d", used];
		}

		if (used > volume) {
			mbToUse.text = @"0" ;
			progressView.progress = 1;
		} else {
			if ((volume-used) > 999) {
				mbToUse.text = [NSString stringWithFormat:@"%d", (volume-used)/1024 ] ;
			} else {
				mbToUse.text = [NSString stringWithFormat:@"%d", volume-used ] ;
			}
			progressView.progress = (float) used/volume;
		}
	}
	NSLog(@"%@", @"displayRecentData end");
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	NSString *loginMobileNumber = [prefs stringForKey:@"loginMobileNumber"];
	NSString *loginPassword = [prefs stringForKey:@"loginPassword"];
	
	if (nil != loginMobileNumber && nil != loginPassword ){
		[proximus setCredentials:loginMobileNumber yourPassword:loginPassword];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}


- (void)flipSide {
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction)showInfo:(id)sender {    
	[self flipSide];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	NSLog(@"%@", @"didReceiveMemoryWarning");
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)proximusDidAddData{
	NSLog(@"%@", @"proximusDidAddData start");
	[self displayRecentData];
	NSLog(@"%@", @"proximusDidAddData end");
}


@end
