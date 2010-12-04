//
//  myProxiDataAppDelegate.m
//  myProxiData
//
//  Created by Joachim on 25/09/10.
//  Copyright 4d.be 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate


@synthesize window;
@synthesize mainViewController;
@synthesize db;

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[db release];
    [mainViewController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.  
	[self databaseInit];
    // Add the main view controller's view to the window and display.
    [window addSubview:mainViewController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	[mainViewController displayRecentData];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}



#pragma mark -
#pragma mark database management

-(void)databaseInit{
	
	BOOL result;
	
	//Where do documents go
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path =[paths objectAtIndex:0];
	
	//What would be the name of my database file
	NSString *fullPath = [path stringByAppendingPathComponent:@"myProxyData.db"];
	
	//Get a file manager for file operations
	NSFileManager *fm = [NSFileManager defaultManager];
	
	//Does the file already exist?
	BOOL exists = [fm fileExistsAtPath:fullPath];
	
	if(exists){
		NSLog(@"%@ exists", fullPath);
		db = [[CSqliteDatabase alloc] initWithPath:fullPath];
		// init the db
		result = [db open:nil];
		NSLog(@"db open : %d",result);
	} else {
		NSLog(@"%@ does not exist - creating one",fullPath);
		db = [[CSqliteDatabase alloc] initWithPath:fullPath];
		// init the db
		result = [db open:nil];
		NSLog(@"db open : %d",result);
		
		NSString *expression = @"CREATE  TABLE logs (used NUMERIC, volume NUMERIC, periodFrom DATETIME, periodTo DATETIME, createdAt DATETIME DEFAULT CURRENT_TIMESTAMP);";
		result = [db executeExpression:expression error:NULL];
		NSLog(@"db table created : %d",result);
	}
}


@end
