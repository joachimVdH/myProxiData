//
//  myProxiDataLogicTests.m
//  myProxiDataLogicTests
//
//  Created by Joachim Van der Hoeven on 11/06/11.
//  Copyright 2011 4d.be. All rights reserved.
//

#import "myProxiDataLogicTests.h"


@implementation myProxiDataLogicTests
/*
- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    // Run before each test method

}

- (void)tearDown
{
  // Tear-down code here.
	// Run after each test method
    
    [super tearDown];
}
*/

- (void)setUpClass {
	// Run at start of all tests in the class
	NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"resultPageNL_110421" ofType:@"txt"];
	htmlNL = [NSData dataWithContentsOfFile:fullPath];
	proximus = [[Proximus alloc] init];
  //[proximus parseData:htmlNL];
}

- (void)tearDownClass {
	// Run at end of all tests in the class	
	[htmlNL release];
	[proximus release];
}

/*
- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in myProxiDataLogicTests");
}
*/

- (void) testInitializesWithHTMLData
{
  STAssertNil(htmlNL, @"file is loaded");
  STAssertNil(proximus, @"Proximus initialized");
}
@end
