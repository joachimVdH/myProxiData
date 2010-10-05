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

- (void)dealloc {
	[mbUsed release];
	[mbToUse release];
	[progressView release];
	[proximus release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
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
}


-(void)displayRecentData{
	
	int used ;
	int volume ;
	
	myProxiDataAppDelegate *appDelegate = (myProxiDataAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSError *err = NULL;
	NSArray *rows = [appDelegate.db rowsForExpression:@"SELECT * FROM logs ORDER BY timestamp desc" error:&err];
	NSLog(@"%@", err);
	//NSLog(@"%@", rows);
	
	if ([rows count] > 0){
		NSDictionary *row = [rows objectAtIndex:0];
		//NSLog(@"%@", row);	
		
		used = [[row objectForKey:@"used"] intValue];
		volume = [[row objectForKey:@"volume"] intValue];
		
		mbUsed.text = [NSString stringWithFormat:@"%d", used];
		mbToUse.text = [NSString stringWithFormat:@"%d", volume-used ] ;
		
		progressView.progress = (float) used/volume;
	}
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
	[self displayRecentData];
}


@end
