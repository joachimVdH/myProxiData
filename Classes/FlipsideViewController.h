//
//  FlipsideViewController.h
//  myProxiData
//
//  Created by Joachim on 25/09/10.
//  Copyright 4d.be 2010. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "GradientButton.h"

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController <MFMailComposeViewControllerDelegate> 
{
	id <FlipsideViewControllerDelegate> delegate;
	IBOutlet UITextField *mobileNumber;
	IBOutlet UITextField *password;
  IBOutlet GradientButton *visitProximusWebsite;
  IBOutlet GradientButton *mailFeedback;
  IBOutlet GradientButton *visit4dbe;
}

@property (nonatomic,retain) UITextField *mobileNumber;
@property (nonatomic,retain) UITextField *password;
@property (nonatomic,retain) GradientButton *visitProximusWebsite;
@property (nonatomic,retain) GradientButton *mailFeedback;
@property (nonatomic,retain) GradientButton *visit4dbe;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)visitProximusWebsite:(id)sender;
- (IBAction)mailFeedback:(id)sender;
- (IBAction)visit4dbe:(id)sender;
- (void)displayComposerSheet;
- (void)launchMailAppOnDevice;

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
@end

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

