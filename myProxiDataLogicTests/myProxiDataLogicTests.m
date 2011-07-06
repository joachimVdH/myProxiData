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

<<<<<<< HEAD
- (void)setUpClass {
=======
- (void)setUp {
  [super setUp];
>>>>>>> f890e7bc6b1d81a6e081a1b428d92b226da272cd
	// Run at start of all tests in the class
	NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"resultPageNL_110421" ofType:@"txt"];
	htmlNL = [NSData dataWithContentsOfFile:fullPath];
	proximus = [[Proximus alloc] init];
  //[proximus parseData:htmlNL];
}

<<<<<<< HEAD
- (void)tearDownClass {
	// Run at end of all tests in the class	
	[htmlNL release];
	[proximus release];
=======
- (void)tearDown {
  [super tearDown];
	// Run at end of all tests in the class	
//	[htmlNL release];
//	[proximus release];
>>>>>>> f890e7bc6b1d81a6e081a1b428d92b226da272cd
}

/*
- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in myProxiDataLogicTests");
}
*/

- (void) testInitializesWithHTMLData
{
<<<<<<< HEAD
  STAssertNil(htmlNL, @"file is loaded");
  STAssertNil(proximus, @"Proximus initialized");
}
=======
  //STAssertNil(htmlNL, @"file is loaded");
  //STAssertNil(proximus, @"Proximus initialized");
  STAssertNotNil(htmlNL, @"file is not loaded");
  STAssertNotNil(proximus, @"Proximus is not initialized 2");
}


- (void) testParseDates{
  // current input : za, mrt 5, '11 - 19:19
  //                 do, feb 10, '11 - 00:00
  // desired output : 5 mrt '11 - 19:19
  
	//proximus = [[Proximus alloc] init] ;
  STAssertEqualObjects([proximus formatBelgianDate:@"za, mrt 5, '11 - 19:19"], @"5 mrt '11 - 19:19", @"date formatting is not correct", nil);
  
  // new format since 22 june 2011
  //current input : 10/06/2011 - 00:00
  //                21/06/2011 - 22:55
  // desired output : 21 jun '11 - 22:55
  STAssertEqualObjects([proximus formatBelgianDate:@"21/06/2011 - 22:55"], @"21 Jun '11 - 22:55", @"date formatting is not correct", nil);
  
}



>>>>>>> f890e7bc6b1d81a6e081a1b428d92b226da272cd
@end
