//
//  MainViewController.m
//  myProxiData
//
//  Created by Joachim on 25/09/10.
//  Copyright 4d.be 2010. All rights reserved.
//

#import "MainViewController.h"
#import "myProxiDataAppDelegate.h"


@implementation MainViewController
@synthesize proximus;
@synthesize mbUsed;
@synthesize mbToUse;
@synthesize progressView;
@synthesize status;

- (void)dealloc {
	[mbUsed release];
	[mbToUse release];
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
								   message:@"No mobile number and password available.\nPress i on the bottom right to enter your credentials."
									delegate:nil
								   cancelButtonTitle:@"ok"
								   otherButtonTitles:nil];
		
		[noCredentials show];
		[noCredentials release];
				
	}
	
	[self displayRecentData];
	NSLog(@"%@", @"viewDidLoad end");
}


-(void)displayRecentData{
	NSLog(@"%@", @"displayRecentData start");
	int used ;
	int volume ;
	
	myProxiDataAppDelegate *appDelegate = (myProxiDataAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSError *err = NULL;
	NSArray *rows = [appDelegate.db rowsForExpression:@"SELECT * FROM logs ORDER BY createdAt desc" error:&err];
	NSLog(@"%@", err);
	//NSLog(@"%@", rows);
	
	if ([rows count] > 0){
		NSDictionary *row = [rows objectAtIndex:0];
		//NSLog(@"%@", row);	
		
		used = [[row objectForKey:@"used"] intValue] + 1;
		volume = [[row objectForKey:@"volume"] intValue];
		
		status.text = [NSString stringWithFormat:@"data from %@", [row objectForKey:@"createdAt"]];
		
		mbUsed.text = [NSString stringWithFormat:@"%d", used];
		if (used > volume) {
			mbToUse.text = @"0" ;
			progressView.progress = 1;
		} else {
			mbToUse.text = [NSString stringWithFormat:@"%d", volume-used ] ;
			progressView.progress = (float) used/volume;
		}
	}
	NSLog(@"%@", @"displayRecentData end");
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
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
