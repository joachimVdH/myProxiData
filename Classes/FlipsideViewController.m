//
//  FlipsideViewController.m
//  myProxiData
//
//  Created by Joachim on 25/09/10.
//  Copyright 4d.be 2010. All rights reserved.
//

#import "FlipsideViewController.h"
//#import "Proximus.h"


@implementation FlipsideViewController

@synthesize delegate;
@synthesize mobileNumber;
@synthesize password;
@synthesize visitProximusWebsite;
@synthesize mailFeedback;
@synthesize visit4dbe;


- (void)dealloc {
  [visit4dbe release];
  [mailFeedback release];
  [visitProximusWebsite release];
	[mobileNumber release]; 
	[password release]; 
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [mobileNumber setPlaceholder:NSLocalizedString(@"Proximus Mobile Number",@"Proximus Mobile Number") ];
	[password setPlaceholder:NSLocalizedString(@"Password",@"Password")];
  
  [visit4dbe useBlackStyle];
  [visit4dbe setTitle:NSLocalizedString(@"visit4dbe", @"Go to our website") forState:UIControlStateNormal];
  
  [mailFeedback useBlackStyle];
  [mailFeedback setTitle:NSLocalizedString(@"mailFeedback", @"Email your feedback") forState:UIControlStateNormal];
  
  [visitProximusWebsite useBlackStyle];
  [visitProximusWebsite setTitle:NSLocalizedString(@"visitProximusWebsite", @"Go to Proximus Mobile website") forState:UIControlStateNormal];
  
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [mobileNumber setText:[prefs stringForKey:@"loginMobileNumber"]];
	[password setText:[prefs stringForKey:@"loginPassword"]];
}


- (IBAction)done:(id)sender {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:mobileNumber.text forKey:@"loginMobileNumber"];
	[prefs setObject:password.text forKey:@"loginPassword"];	
	
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (IBAction)textFieldDoneEditing:(id)sender{ 
	[sender resignFirstResponder];
}

- (IBAction)visitProximusWebsite:(id)sender{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.proximus.be"]];  
}

- (IBAction)visit4dbe:(id)sender{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.4d.be/apps/myProxiData"]];
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


#pragma mark -
#pragma mark Feedback Mail

- (IBAction)mailFeedback:(id)sender{
  // Based on Mailcomposer example from Apple Inc.
  // We must always check whether the current device is configured for sending emails
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
  if ([mailClass canSendMail]){
    [self displayComposerSheet];
  } else {
    [self launchMailAppOnDevice];
  }
}

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"myProxiData Feedback"];
	
  
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"myProxiData@4d.be"]; 
	
	[picker setToRecipients:toRecipients];
	
	// Attach an image to the email
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
  //NSData *myData = [NSData dataWithContentsOfFile:path];
	//[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString *emailBody = [NSString stringWithFormat:@"\n\n\n\nThanks from 4d.be Apps!\n---\nVersion: %@\nOS: %@\nUDID: %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[UIDevice currentDevice] systemVersion],[[UIDevice currentDevice] uniqueIdentifier],nil ] ;
                         
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
  [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// Notifies about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			DLog (@"Result: canceled",@"");
			break;
		case MFMailComposeResultSaved:
			DLog (@"Result: saved",@"");
			break;
		case MFMailComposeResultSent:
			DLog (@"Result: sent",@"");
			break;
		case MFMailComposeResultFailed:
			DLog (@"Result: failed",@"");
			break;
		default:
			DLog (@"Result: not sent",@"");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:myProxiData@4d.be?subject=myProxiData Feedback";
	NSString *body = [NSString stringWithFormat:@"\n\n\n\nThanks from 4d.be Apps!\n---\nVersion: %@\nOS: %@\nUDID: %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[UIDevice currentDevice] systemVersion],[[UIDevice currentDevice] uniqueIdentifier],nil ] ;
  
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark -

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


@end
