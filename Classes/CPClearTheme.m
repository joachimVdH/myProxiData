//
//  CPClearTheme.h
//  myProxiData
//
//  Created by Joachim Van der Hoeven on 18/04/11.
//  Copyleft 2011 4d.be
//

#import "CPClearTheme.h"
#import "CPXYGraph.h"
#import "CPColor.h"
#import "CPGradient.h"
#import "CPFill.h"
#import "CPPlotAreaFrame.h"
#import "CPXYPlotSpace.h"
#import "CPUtilities.h"
#import "CPXYAxisSet.h"
#import "CPXYAxis.h"
#import "CPMutableLineStyle.h"
#import "CPMutableTextStyle.h"
#import "CPBorderedLayer.h"
#import "CPExceptions.h"

/** @brief Creates a CPXYGraph instance formatted with a clear background and white lines.
 **/
@implementation CPClearTheme

+(NSString *)defaultName 
{
  return @"CPClearTheme";
}

-(void)applyThemeToBackground:(CPXYGraph *)graph 
{	
  graph.fill = [CPFill fillWithColor:[CPColor clearColor]];
}

-(void)applyThemeToPlotArea:(CPPlotAreaFrame *)plotAreaFrame
{	
  plotAreaFrame.fill = [CPFill fillWithColor:[CPColor clearColor]];
}

-(void)applyThemeToAxisSet:(CPXYAxisSet *)axisSet 
{	
  CPMutableLineStyle *majorLineStyle = [CPMutableLineStyle lineStyle];
  majorLineStyle.lineCap = kCGLineCapRound;
  majorLineStyle.lineColor = [CPColor whiteColor];
  majorLineStyle.lineWidth = 2.0;
  
  CPMutableLineStyle *minorLineStyle = [CPMutableLineStyle lineStyle];
  minorLineStyle.lineColor = [CPColor whiteColor];
  minorLineStyle.lineWidth = 2.0;
	
  CPXYAxis *x = axisSet.xAxis;
	CPMutableTextStyle *whiteTextStyle = [[[CPMutableTextStyle alloc] init] autorelease];
	whiteTextStyle.color = [CPColor whiteColor];
	whiteTextStyle.fontSize = 14.0;
	CPMutableTextStyle *minorTickWhiteTextStyle = [[[CPMutableTextStyle alloc] init] autorelease];
	minorTickWhiteTextStyle.color = [CPColor whiteColor];
	minorTickWhiteTextStyle.fontSize = 12.0;
  x.labelingPolicy = CPAxisLabelingPolicyFixedInterval;
  x.majorIntervalLength = CPDecimalFromDouble(0.5);
  x.orthogonalCoordinateDecimal = CPDecimalFromDouble(0.0);
	x.tickDirection = CPSignNone;
  x.minorTicksPerInterval = 4;
  x.majorTickLineStyle = majorLineStyle;
  x.minorTickLineStyle = minorLineStyle;
  x.axisLineStyle = majorLineStyle;
  x.majorTickLength = 7.0;
  x.minorTickLength = 5.0;
	x.labelTextStyle = whiteTextStyle;
	x.minorTickLabelTextStyle = minorTickWhiteTextStyle;
	x.titleTextStyle = whiteTextStyle;
	
  CPXYAxis *y = axisSet.yAxis;
  y.labelingPolicy = CPAxisLabelingPolicyFixedInterval;
  y.majorIntervalLength = CPDecimalFromDouble(0.5);
  y.minorTicksPerInterval = 4;
  y.orthogonalCoordinateDecimal = CPDecimalFromDouble(0.0);
	y.tickDirection = CPSignNone;
  y.majorTickLineStyle = majorLineStyle;
  y.minorTickLineStyle = minorLineStyle;
  y.axisLineStyle = majorLineStyle;
  y.majorTickLength = 7.0;
  y.minorTickLength = 5.0;
	y.labelTextStyle = whiteTextStyle;
	y.minorTickLabelTextStyle = minorTickWhiteTextStyle;
	y.titleTextStyle = whiteTextStyle;
}

@end
