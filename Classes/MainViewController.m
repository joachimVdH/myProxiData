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
  graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTClearTheme *theme = [[CPTClearTheme alloc]init];
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
  CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
  plotSpace.allowsUserInteraction = YES;
  plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(10100.0) length:CPTDecimalFromFloat(081500.0)];
  plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(750.0)];
  
  // Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
  CPTXYAxis *x = axisSet.xAxis;
  x.majorIntervalLength = CPTDecimalFromString(@"7");
  //x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"2");
  //x.minorTicksPerInterval = 7;
 	//NSArray *exclusionRanges = [NSArray arrayWithObjects:
  //                            [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.99) length:CPTDecimalFromFloat(0.02)], 
  //                            [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.99) length:CPTDecimalFromFloat(0.02)],
  //                            [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(2.99) length:CPTDecimalFromFloat(0.02)],
  //                            nil];
	//x.labelExclusionRanges = exclusionRanges;
  
  CPTXYAxis *y = axisSet.yAxis;
  y.majorIntervalLength = CPTDecimalFromString(@"50");
  //y.minorTicksPerInterval = 5;
  //y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"2");
	//exclusionRanges = [NSArray arrayWithObjects:
  //                   [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.99) length:CPTDecimalFromFloat(0.02)], 
  //                   [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.99) length:CPTDecimalFromFloat(0.02)],
  //                   [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(3.99) length:CPTDecimalFromFloat(0.02)],
  //                   nil];
	//y.labelExclusionRanges = exclusionRanges;
  
	// Create the white plot area
	CPTScatterPlot *boundLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
  CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
  //lineStyle.miterLimit = 1.0f;
	lineStyle.lineWidth = 1.0f;
	lineStyle.lineColor = [CPTColor whiteColor];
  boundLinePlot.dataLineStyle = lineStyle;
  boundLinePlot.identifier = @"white Plot";
  boundLinePlot.dataSource = self;
	[graph addPlot:boundLinePlot];
	
	// Do a white gradient
  
	CPTColor *areaColor1 = [CPTColor colorWithComponentRed:1.0 green:1.0 blue:1.0 alpha:0.8];
  CPTGradient *areaGradient1 = [CPTGradient gradientWithBeginningColor:areaColor1 endingColor:[CPTColor clearColor]];
  areaGradient1.angle = -90.0f;
  CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient1];
  boundLinePlot.areaFill = areaGradientFill;
  boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];  
  
  // Add Data
  //NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
  //NSUInteger i;
	//for ( i = 0; i < 60; i++ ) {
	//	id x = [NSNumber numberWithFloat:1+i*0.05];
	//	id y = [NSNumber numberWithFloat:1.2*rand()/(float)RAND_MAX + 1.2];
	//	[contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
	//}
	//self.dataForPlot = contentArray;

  [self setPlotData];
}


- (void)setPlotData{
  NSError *error = NULL;
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"EntryLog" inManagedObjectContext:managedObjectContext]];
  [request setFetchLimit:100];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	
  self.dataForPlot = [[managedObjectContext executeFetchRequest:request error:&error] copy];
	
  //DLog(@"entryLog : %@",entryLog);
	ZAssert(error == nil, @"Error accessing context: %@", [error localizedDescription]);
  
  // do not release request - crash is on your side
	//[request release];
  
	[error	release];
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
  return [dataForPlot count];
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
  NSNumber *num;
  EntryLog *entrylog;
  
  if (fieldEnum == CPTScatterPlotFieldX)
  {
    entrylog = [dataForPlot objectAtIndex:index] ;

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSHourCalendarUnit) fromDate:[entrylog xDate]];
   
    num = [NSNumber numberWithLong:[dayComponents month] * 10000 + [dayComponents day] * 100 + [dayComponents hour]+index]  ;
    
    [gregorian release];
    //[dayComponents release];
  }
  else
  {    
    entrylog = [dataForPlot objectAtIndex:index] ;
    num = [NSNumber numberWithFloat:[entrylog toUse]] ;
  }
  //NSNumber *num = [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"xDate" : @"toUse")];	
  return num;
}







@end
