//
//  MainViewController.h
//  myProxiData
//
//  Created by Joachim on 25/09/10.
//  Copyright 4d.be 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "Proximus.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	Proximus *proximus;
	IBOutlet UILabel *mbUsed;
	IBOutlet UILabel *mbToUse;
	IBOutlet UIProgressView *progressView;
}

@property(nonatomic,retain)Proximus *proximus;
@property(nonatomic,retain)UILabel *mbUsed;
@property(nonatomic,retain)UILabel *mbToUse;
@property(nonatomic,retain)UIProgressView *progressView;

- (IBAction)showInfo:(id)sender;

-(void)displayRecentData;

@end
