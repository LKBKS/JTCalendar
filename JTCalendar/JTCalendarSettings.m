//
//  JTCalendarSettings.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarSettings.h"

@implementation JTCalendarSettings

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    _pageViewHideWhenPossible = NO;
    _pageViewNumberOfWeeks = 6;
    _pageViewHaveWeekDaysView = YES;
    _weekDayFormat = JTCalendarWeekDayFormatShort;
    _weekModeEnabled = NO;
    _dayModeEnabled = NO;
    _pageViewWeekModeNumberOfWeeks = 1;
    _menuMonthHeight = 30.0;
    _weekendDayTextColor = [UIColor blackColor];
    _weekDayTextColor = [UIColor blackColor];
    _weekDayTextFont = [UIFont systemFontOfSize:12];
    _weekDayHeight = 20.0;
    
    _dayDotDiameter = 5.0;
    _dayDotMargin = 2;
    _dayDotLineWidthLimit = 4;
    _dayDotLineHeightLimit = 2;
    _dayDotTopSpace = 4.0;
}

@end
