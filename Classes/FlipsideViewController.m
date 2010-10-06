//
//  FlipsideViewController.m
//  myProxiData
//
//  Created by Joachim on 25/09/10.
//  Copyright 4d.be 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "Proximus.h"


@implementation FlipsideViewController

@synthesize delegate;
@synthesize mobileNumber;
@synthesize password;


- (void)dealloc {
	[mobileNumber release];
	[password release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	mobileNumber.text = [prefs stringForKey:@"loginMobileNumber"];
	password.text = [prefs stringForKey:@"loginPassword"];
}


- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:mobileNumber.text forKey:@"loginMobileNumber"];
	[prefs setObject:password.text forKey:@"loginPassword"];	
	
	/*
	if (nil != mobileNumber.text && nil != mobileNumber.text ){
		Proximus *proximus = [[[Proximus alloc] init] autorelease] ;
		[proximus setCredentials:mobileNumber.text yourPassword:password.text];
	}
	 */
	
}

- (IBAction)textFieldDoneEditing:(id)sender{ 
	[sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


@end
