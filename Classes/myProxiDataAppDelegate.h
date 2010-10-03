//
//  myProxiDataAppDelegate.h
//  myProxiData
//
//  Created by Joachim on 25/09/10.
//  Copyright 4d.be 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSqliteDatabase.h"
@class MainViewController;

@interface myProxiDataAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
	CSqliteDatabase *db;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) CSqliteDatabase *db;

-(void)databaseInit;
@end

