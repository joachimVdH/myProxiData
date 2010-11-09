//
//  ProximusTests.m
//  myProxiData
//
//  Created by Joachim on 18/10/10.
//  Copyright 2010 4d.be. All rights reserved.
//

#import "Proximus.h"

@interface ProximusTests : GHTestCase { 
	NSData *htmlNL;
	Proximus *proximus;
}
@end


@implementation ProximusTests


- (BOOL)shouldRunOnMainThread {
	// By default NO, but if you have a UI test or test dependent on running on the main thread return YES
	return NO;
}

- (void)setUpClass {
	// Run at start of all tests in the class
	NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"resultPageNL" ofType:@"txt"];
	htmlNL = [NSData dataWithContentsOfFile:fullPath];
	proximus = [[Proximus alloc]init];
}

- (void)tearDownClass {
	// Run at end of all tests in the class	
	[htmlNL release];
	[proximus release];
}

- (void)setUp {
	// Run before each test method
}

- (void)tearDown {
	// Run after each test method
}	

- (void) testInitializesWithHTMLData
{
	GHAssertNotNULL(htmlNL, nil);
	GHAssertEqualObjects([[proximus class] description], @"Proximus", nil);
}

/*
- (void) testGetUsedData
{
	GHAssertEquals([proximus getUsedData],150.80);
}
*/

@end
