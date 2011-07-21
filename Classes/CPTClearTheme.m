//
//  CPClearTheme.h
//  myProxiData
//
//  Created by Joachim Van der Hoeven on 18/04/11.
//  Copyleft 2011 4d.be
//

#import "CPTClearTheme.h"
#import "CPTXYGraph.h"
#import "CPTColor.h"
#import "CPTGradient.h"
#import "CPTFill.h"
#import "CPTPlotAreaFrame.h"
#import "CPTXYPlotSpace.h"
#import "CPTUtilities.h"
#import "CPTXYAxisSet.h"
#import "CPTXYAxis.h"
#import "CPTMutableLineStyle.h"
#import "CPTMutableTextStyle.h"
#import "CPTBorderedLayer.h"
#import "CPTExceptions.h"

/** @brief Creates a CPTXYGraph instance formatted with a clear background and white lines.
 **/
@implementation CPTClearTheme

+(NSString *)defaultName 
{
  return @"CPTClearTheme";
}

-(void)applyThemeToBackground:(CPTXYGraph *)graph 
{	
  graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
}

-(void)applyThemeToPlotArea:(CPTPlotAreaFrame *)plotAreaFrame
{	
  plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
}

-(void)applyThemeToAxisSet:(CPTXYAxisSet *)axisSet 
{	
  CPTMutableLineStyle *majorLineStyle = [CPTMutableLineStyle lineStyle];
  majorLineStyle.lineCap = kCGLineCapRound;
  majorLineStyle.lineColor = [CPTColor whiteColor];
  majorLineStyle.lineWidth = 1.0;
  
  CPTMutableLineStyle *minorLineStyle = [CPTMutableLineStyle lineStyle];
  minorLineStyle.lineColor = [CPTColor whiteColor];
  minorLineStyle.lineWidth = 1.0;
	
  CPTXYAxis *x = axisSet.xAxis;
	CPTMutableTextStyle *whiteTextStyle = [[[CPTMutableTextStyle alloc] init] autorelease];
	whiteTextStyle.color = [CPTColor whiteColor];
	whiteTextStyle.fontSize = 14.0;
	CPTMutableTextStyle *minorTickWhiteTextStyle = [[[CPTMutableTextStyle alloc] init] autorelease];
	minorTickWhiteTextStyle.color = [CPTColor whiteColor];
	minorTickWhiteTextStyle.fontSize = 12.0;
  x.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
  x.majorIntervalLength = CPTDecimalFromDouble(0.5);
  x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
	x.tickDirection = CPTSignNone;
  x.minorTicksPerInterval = 4;
  x.majorTickLineStyle = majorLineStyle;
  x.minorTickLineStyle = minorLineStyle;
  x.axisLineStyle = majorLineStyle;
  x.majorTickLength = 7.0;
  x.minorTickLength = 5.0;
	x.labelTextStyle = whiteTextStyle;
	x.minorTickLabelTextStyle = minorTickWhiteTextStyle;
	x.titleTextStyle = whiteTextStyle;
	
  CPTXYAxis *y = axisSet.yAxis;
  y.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
  y.majorIntervalLength = CPTDecimalFromDouble(0.5);
  y.minorTicksPerInterval = 4;
  y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
	y.tickDirection = CPTSignNone;
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
