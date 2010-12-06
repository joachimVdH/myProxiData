//
//  Proximus.h
//  Proximus
//
//  Created by Joachim on 31/08/10.
//  Copyright 2010 4d.be. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>


@protocol ProximusDelegate<NSObject>

@optional
- (void)proximusDidAddData;
@end

@interface Proximus : NSObject {
	id<ProximusDelegate> delegate;
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic,assign) id<ProximusDelegate> delegate;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)setCredentials:(NSString *)mobileNumber yourPassword:(NSString *)password;
- (void)grabURLInBackground;
- (void)parseData:(NSData *)html;
//- (float)getUsedData:(NSData *)html;

@end

