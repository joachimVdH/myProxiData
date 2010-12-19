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

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController <MFMailComposeViewControllerDelegate> 
{
	id <FlipsideViewControllerDelegate> delegate;
	IBOutlet UITextField *mobileNumber;
	IBOutlet UITextField *password;
  IBOutlet UIButton *visitProximusWebsite;
  IBOutlet UIButton *mailFeedback;
  IBOutlet UIButton *visit4dbe;
}

@property (nonatomic,retain) UITextField *mobileNumber;
@property (nonatomic,retain) UITextField *password;
@property (nonatomic,retain) UIButton *visitProximusWebsite;
@property (nonatomic,retain) UIButton *mailFeedback;
@property (nonatomic,retain) UIButton *visit4dbe;

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

