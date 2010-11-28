//
//  MainViewController.h
//  myProxiData
//
//  Created by Joachim on 25/09/10.
//  Copyright 4d.be 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "Proximus.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate,ProximusDelegate> {
	Proximus *proximus;
	IBOutlet UILabel *mbUsed;
	IBOutlet UILabel *mbToUse;
	IBOutlet UILabel *labelUsed;
	IBOutlet UILabel *labelToUse;
	IBOutlet UILabel *periodUsage;
	IBOutlet UIProgressView *progressView;
	IBOutlet UILabel *status;
}

@property(nonatomic,retain)Proximus *proximus;
@property(nonatomic,retain)UILabel *mbUsed;
@property(nonatomic,retain)UILabel *mbToUse;
@property(nonatomic,retain)UILabel *labelUsed;
@property(nonatomic,retain)UILabel *labelToUse;
@property(nonatomic,retain)UILabel *periodUsage;
@property(nonatomic,retain)UILabel *status;
@property(nonatomic,retain)UIProgressView *progressView;

- (IBAction)showInfo:(id)sender;

- (void)displayRecentData;
- (void)flipSide;

@end
