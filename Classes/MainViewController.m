//
//  MainViewController.m
//  myProxiData
//
//  Created by Joachim on 25/09/10.
//  Copyright 4d.be 2010. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "EntryLog.h"

@implementation MainViewController

@synthesize managedObjectContext;
@synthesize proximus;
@synthesize mbUsed;
@synthesize mbToUse;
@synthesize labelUsed;
@synthesize labelToUse;
@synthesize periodUsage;
@synthesize progressView;
@synthesize status;

- (void)dealloc {
	[managedObjectContext release];
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
	DLog(@"%@", @"viewDidLoad start");
	[super viewDidLoad];
  
	proximus = [[Proximus alloc] init] ;
	[proximus setDelegate:self]; 
	[proximus setManagedObjectContext:[self managedObjectContext]];
  
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	NSString *loginMobileNumber = [prefs stringForKey:@"loginMobileNumber"];
	NSString *loginPassword = [prefs stringForKey:@"loginPassword"];
	
	if (nil != loginMobileNumber && nil != loginPassword ){
    
		[proximus setCredentials:loginMobileNumber yourPassword:loginPassword];
		
	} else {
		DLog(@"NO credentials - Time to flip the screen");		
		
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
	DLog(@"Current Locale: %@", [[NSLocale currentLocale] localeIdentifier]);
	DLog(@"Current language: %@", [[prefs objectForKey:@"AppleLanguages"] objectAtIndex:0]);
	
	//[self displayRecentData];
	DLog(@"%@", @"viewDidLoad end");
}

// Implement viewWillAppear: to do additional setup before the view is presented. 
// You might, for example, fetch objects from the managed object context if necessary.
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)displayRecentData{
	DLog(@"%@", @"displayRecentData start");

	NSError *error = NULL;
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"EntryLog" inManagedObjectContext:managedObjectContext]];
  [request setFetchLimit:1];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	EntryLog *entryLog = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
	DLog(@"entryLog : %@",entryLog);
	ZAssert(error == nil, @"Error accessing context: %@", [error localizedDescription]);
	
  if (entryLog != nil) {
		
		//--- formatting data start
		// http://unicode.org/reports/tr35/tr35-4.html#Date_Format_Patterns
		//DLog(@"Raw Date : %@",[entryLog createdAt]);
		
		NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
		[outputFormatter setDateFormat:@"EEE d MMM HH:mm"];
    
		status.text = [NSString stringWithFormat:NSLocalizedString(@"Last refresh at", @"Last refresh at %@") , [outputFormatter stringFromDate:[entryLog createdAt]],nil];
		//--- formatting data end
		
		// formatting the dates for the usage period
	  [outputFormatter setDateFormat:@"d MMM"];
		NSString *temp = [outputFormatter stringFromDate:[entryLog periodFrom]];
		
		[outputFormatter setDateFormat:@"d MMM H:mm"];
		
		periodUsage.text = [NSString stringWithFormat:NSLocalizedString(@"usage from to",@"usage from %@ to %@"),temp,[outputFormatter stringFromDate:[entryLog periodTo]],nil];
		
		if ([entryLog consumed] > 999) { 
			labelUsed.text = [NSString stringWithFormat:NSLocalizedString(@"MB used",@"%@ used"),@"GB",nil];
		} else {
			labelUsed.text = [NSString stringWithFormat:NSLocalizedString(@"MB used",@"%@ used"),@"MB",nil];
		}
		
		if ([entryLog toUse] > 999) { 
			labelToUse.text = [NSString stringWithFormat:NSLocalizedString(@"MB to use",@"%@ to use"),@"GB",nil];
		} else {
			labelToUse.text = [NSString stringWithFormat:NSLocalizedString(@"MB to use",@"%@ to use"),@"MB",nil];
		}
    
		[outputFormatter release];
		
		// setting the data labels
		if ([entryLog consumed] > 999) {
			mbUsed.text = [NSString stringWithFormat:@"%d", [entryLog consumed] /1024];
		} else {
			mbUsed.text = [NSString stringWithFormat:@"%d", [entryLog consumed] ];
		}
    
    if ([entryLog toUse] > 999) {
      mbToUse.text = [NSString stringWithFormat:@"%d", [entryLog toUse]/1024 ] ;
    } else {
      mbToUse.text = [NSString stringWithFormat:@"%d", [entryLog toUse] ] ;
    }
    //DLog(@"[entryLog percentage] : %f",[entryLog percentage]);
    progressView.progress = [entryLog percentage];
    
	}
	
	[request release];
	[error	release];
	DLog(@"%@", @"displayRecentData end");
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
	
	DLog(@"%@", @"didReceiveMemoryWarning");
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
	DLog(@"%@", @"proximusDidAddData start");
	[self displayRecentData];
	DLog(@"%@", @"proximusDidAddData end");
}


@end
