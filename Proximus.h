//
//  Proximus.h
//  Proximus
//
//  Created by Joachim on 31/08/10.
//  Copyright 2010 4d.be. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Proximus : NSObject {

}
- (void)setCredentials:(NSString *)mobileNumber yourPassword:(NSString *)password;
- (void)grabURLInBackground;
- (void)parseData:(NSData *)html;

@end
