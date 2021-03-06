
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CPTColorSpace : NSObject {
	@private
    CGColorSpaceRef cgColorSpace;
}

@property (nonatomic, readonly, assign) CGColorSpaceRef cgColorSpace;

+(CPTColorSpace *)genericRGBSpace;

-(id)initWithCGColorSpace:(CGColorSpaceRef)colorSpace;

@end
