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
@synthesize entryLog;
@synthesize dataForPlot;
@synthesize hostingView;

@synthesize mbUsed;
@synthesize mbToUse;
@synthesize labelUsed;
@synthesize labelToUse;
@synthesize periodUsage;
@synthesize progressView;
@synthesize status;

- (void)dealloc {
	[managedObjectContext release];
	[proximus release];
  [entryLog release];
	[dataForPlot release];
  
	[mbUsed release];
	[mbToUse release];
	[labelUsed release];
	[labelToUse release];
	[periodUsage release];
	[progressView release];
	[status release];
  [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	DLog(@"%@", @"viewDidLoad start");
	[super viewDidLoad];
  [self setCurrentEntryLog];
  
	proximus = [[Proximus alloc] init] ;
	[proximus setDelegate:self]; 
	[proximus setManagedObjectContext:[self managedObjectContext]];
  [proximus setEntryLog:entryLog];
  
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
	
  // CorePlot
  [self createGraph];
  
  
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

- (void)displayRecentData{
	DLog(@"%@", @"displayRecentData start");

  if (entryLog != nil) {
		// http://unicode.org/reports/tr35/tr35-4.html#Date_Format_Patterns
		
		NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
		[outputFormatter setDateFormat:@"EEE d MMM HH:mm"];
    
		status.text = [NSString stringWithFormat:NSLocalizedString(@"Last refresh at", @"Last refresh at %@") , [outputFormatter stringFromDate:[entryLog lastRefresh]],nil];
		
		[outputFormatter release];
    
		// formatting the dates for the usage period
    NSString *temp = [[[entryLog periodFromText] substringToIndex:[[entryLog periodFromText] length]-11 ]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		periodUsage.text = [NSString stringWithFormat:NSLocalizedString(@"usage from to",@"usage from %@ to %@"),temp,[entryLog periodToText],nil];
		
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
	
	DLog(@"%@", @"displayRecentData end");
}

- (void)setCurrentEntryLog{
  NSError *error = NULL;
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"EntryLog" inManagedObjectContext:managedObjectContext]];
  [request setFetchLimit:1];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	
  entryLog = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
	
  DLog(@"entryLog : %@",entryLog);
	ZAssert(error == nil, @"Error accessing context: %@", [error localizedDescription]);
  
	[request release];
	[error	release];
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
  [self setCurrentEntryLog];
	[self displayRecentData];
	DLog(@"%@", @"proximusDidAddData end");
}

#pragma mark -
#pragma mark Plot Data Methods

-(void)createGraph{
  graph = [[CPXYGraph alloc] initWithFrame:CGRectZero];
	CPClearTheme *theme = [[CPClearTheme alloc]init];
  [graph applyTheme:theme];
  [theme release];
  
	hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
  hostingView.hostedGraph = graph;
  [graph release];
  
  
  graph.paddingLeft = 15.0;
	graph.paddingTop = 15.0;
	graph.paddingRight = 15.0;
	graph.paddingBottom = 0.0;
  
  // Setup plot space
  CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
  plotSpace.allowsUserInteraction = YES;
  plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.0) length:CPDecimalFromFloat(2.0)];
  plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.0) length:CPDecimalFromFloat(3.0)];
  
  // Axes
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
  CPXYAxis *x = axisSet.xAxis;
  x.majorIntervalLength = CPDecimalFromString(@"0.5");
  x.orthogonalCoordinateDecimal = CPDecimalFromString(@"2");
  x.minorTicksPerInterval = 2;
 	NSArray *exclusionRanges = [NSArray arrayWithObjects:
                              [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.99) length:CPDecimalFromFloat(0.02)], 
                              [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.99) length:CPDecimalFromFloat(0.02)],
                              [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(2.99) length:CPDecimalFromFloat(0.02)],
                              nil];
	x.labelExclusionRanges = exclusionRanges;
  
  CPXYAxis *y = axisSet.yAxis;
  y.majorIntervalLength = CPDecimalFromString(@"0.5");
  y.minorTicksPerInterval = 5;
  y.orthogonalCoordinateDecimal = CPDecimalFromString(@"2");
	exclusionRanges = [NSArray arrayWithObjects:
                     [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.99) length:CPDecimalFromFloat(0.02)], 
                     [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.99) length:CPDecimalFromFloat(0.02)],
                     [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(3.99) length:CPDecimalFromFloat(0.02)],
                     nil];
	y.labelExclusionRanges = exclusionRanges;
  
	// Create a blue plot area
	CPScatterPlot *boundLinePlot = [[[CPScatterPlot alloc] init] autorelease];
  CPMutableLineStyle *lineStyle = [CPMutableLineStyle lineStyle];
  lineStyle.miterLimit = 1.0f;
	lineStyle.lineWidth = 3.0f;
	lineStyle.lineColor = [CPColor whiteColor];
  boundLinePlot.dataLineStyle = lineStyle;
  boundLinePlot.identifier = @"white Plot";
  boundLinePlot.dataSource = self;
	[graph addPlot:boundLinePlot];
	
	// Do a white gradient
  
	CPColor *areaColor1 = [CPColor colorWithComponentRed:1.0 green:1.0 blue:1.0 alpha:0.8];
  CPGradient *areaGradient1 = [CPGradient gradientWithBeginningColor:areaColor1 endingColor:[CPColor clearColor]];
  areaGradient1.angle = -90.0f;
  CPFill *areaGradientFill = [CPFill fillWithGradient:areaGradient1];
  boundLinePlot.areaFill = areaGradientFill;
  boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];  
  
}

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
  return [dataForPlot count];
}

/*
-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
  NSNumber *num = [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPScatterPlotFieldX ? @"x" : @"y")];
	
  return num;
}*/
@end
