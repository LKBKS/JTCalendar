//
//  JTCalendarSettings.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JTCalendarWeekDayFormat) {
    JTCalendarWeekDayFormatSingle,
    JTCalendarWeekDayFormatShort,
    JTCalendarWeekDayFormatFull
};

@interface JTCalendarSettings : NSObject


// Content view

@property (nonatomic) BOOL pageViewHideWhenPossible;
@property (nonatomic) BOOL weekModeEnabled;
@property (nonatomic) BOOL dayModeEnabled;


// Page view

// Must be less or equalt to 6, 0 for automatic
@property (nonatomic) NSUInteger pageViewNumberOfWeeks;
@property (nonatomic) BOOL pageViewHaveWeekDaysView;
@property (nonatomic) NSUInteger pageViewWeekModeNumberOfWeeks;

// WeekDay view

@property (nonatomic) JTCalendarWeekDayFormat weekDayFormat;
@property (nonatomic, strong) UIColor* weekendDayTextColor;
@property (nonatomic, strong) UIColor* weekDayTextColor;
@property (nonatomic) UIFont* weekDayTextFont;

// MenuView
@property (nonatomic) CGFloat menuMonthHeight;

// Day Dots View
@property (nonatomic) CGFloat dayDotDiameter;
@property (nonatomic) CGFloat dayDotMargin;
@property (nonatomic) int dayDotLineWidthLimit;
@property (nonatomic) int dayDotLineHeightLimit;
@property (nonatomic) CGFloat dayDotTopSpace;


// Use for override
- (void)commonInit;

@end
