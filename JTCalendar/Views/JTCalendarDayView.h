//
//  JTCalendarDayView.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

#import "JTCalendarDay.h"

@class JTCalendarDotsView;

@interface JTCalendarDayView : UIView<JTCalendarDay>

@property (nonatomic, weak) JTCalendarManager *manager;

@property (nonatomic) NSDate *date;

@property (nonatomic, readonly) UIView *circleView;
@property (nonatomic, readonly) UIView *dotView;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) JTCalendarDotsView *dotViews;


@property (nonatomic) CGFloat circleRatio;
@property (nonatomic) CGFloat dotRatio;
@property (nonatomic) CGFloat textLabelTopSpaceConstant;
@property (nonatomic) CGFloat textLabelHeightRatio;

@property (nonatomic) BOOL isFromAnotherMonth;

/*!
 * Must be call if override the class
 */
- (void)commonInit;

@end
