//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"

#import "JTCircleView.h"

@interface JTCalendarDayView (){
    UIView *backgroundView;
    JTCircleView *circleView;
    UILabel *textLabel;
    NSArray *dotViews;
    
    BOOL isSelected;
    
    int cacheIsToday;
    NSString *cacheCurrentDateText;
}
@end

static NSString *const kJTCalendarDaySelected = @"kJTCalendarDaySelected";

@implementation JTCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)commonInit
{
    isSelected = NO;
    self.isOtherMonth = NO;

    {
        backgroundView = [UIView new];
        [self addSubview:backgroundView];
    }
    
    {
        circleView = [JTCircleView new];
        [self addSubview:circleView];
    }
    
    {
        textLabel = [UILabel new];
        [self addSubview:textLabel];
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];

        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
    
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDaySelected:) name:kJTCalendarDaySelected object:nil];
    }
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    // No need to call [super layoutSubviews]
}

// Avoid to calcul constraints (very expensive)
- (void)configureConstraintsForSubviews
{
    JTCalendarAppearance *calendarAppearance = self.calendarManager.calendarAppearance;
    
    CGFloat y = calendarAppearance.dayLabelTopSpaceConstant;
    CGFloat height = self.frame.size.height * calendarAppearance.dayLabelHeightRatio;
    
    textLabel.frame = CGRectMake(0, y, self.frame.size.width, height);
    backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);


    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * self.calendarManager.calendarAppearance.dayCircleRatio;
    sizeDot = sizeDot * self.calendarManager.calendarAppearance.dayDotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    circleView.center = textLabel.center;
    circleView.layer.cornerRadius = sizeCircle / 2.;
    
    CGFloat x = 0.0;
    y = (self.frame.size.height / 2.) +sizeDot * 2.5;
    int dotCounter = 0;
    for (JTCircleView *dotView in dotViews) {
        dotCounter++;
        if (dotCounter >= 4) {
            y += sizeDot * 2.5;
        }
        dotView.frame = CGRectMake(x, y, sizeDot, sizeDot);
        dotView.layer.cornerRadius = sizeDot / 2.;
        x = CGRectGetMaxX(dotView.frame);
    }
}

- (void)setDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:self.calendarManager.calendarAppearance.dayFormat];
    }
    
    self->_date = date;
    
    textLabel.text = [dateFormatter stringFromDate:date];
    
    cacheIsToday = -1;
    cacheCurrentDateText = nil;
}

- (void)didTouch
{
    if([self.calendarManager.dataSource respondsToSelector:@selector(calendar:canSelectDate:)]){
        if(![self.calendarManager.dataSource calendar:self.calendarManager canSelectDate:self.date]){
            return;
        }
    }
    
    [self setSelected:YES animated:YES];
    [self.calendarManager setCurrentDateSelected:self.date];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTCalendarDaySelected object:self.date];
    
    [self.calendarManager.dataSource calendarDidDateSelected:self.calendarManager date:self.date];
    
    if(!self.isOtherMonth || !self.calendarManager.calendarAppearance.autoChangeMonth){
        return;
    }
    
    NSInteger currentMonthIndex = [self monthIndexForDate:self.date];
    NSInteger calendarMonthIndex = [self monthIndexForDate:self.calendarManager.currentDate];
        
    currentMonthIndex = currentMonthIndex % 12;
    
    if(currentMonthIndex == (calendarMonthIndex + 1) % 12){
        [self.calendarManager loadNextPage];
    }
    else if(currentMonthIndex == (calendarMonthIndex + 12 - 1) % 12){
        [self.calendarManager loadPreviousPage];
    }
}

- (void)didDaySelected:(NSNotification *)notification
{
    NSDate *dateSelected = [notification object];
    
    if([self isSameDate:dateSelected]){
        if(!isSelected){
            [self setSelected:YES animated:YES];
        }
    }
    else if(isSelected){
        [self setSelected:NO animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(isSelected == selected){
        animated = NO;
    }
    
    isSelected = selected;
    
    circleView.transform = CGAffineTransformIdentity;
    CGAffineTransform tr = CGAffineTransformIdentity;
    CGFloat opacity = 1.;
    
    if(selected){
        if(!self.isOtherMonth){
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorSelected];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelected];
//            dotView.color = [self.calendarManager.calendarAppearance dayDotColorSelected];
        }
        else{
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorSelectedOtherMonth];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelectedOtherMonth];
//            dotView.color = [self.calendarManager.calendarAppearance dayDotColorSelectedOtherMonth];
        }
        textLabel.font = self.calendarManager.calendarAppearance.dayTextFontSelected;
        circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        tr = CGAffineTransformIdentity;
    }
    else if([self isToday]){
        if(!self.isOtherMonth){
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorToday];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorToday];
//            dotView.color = [self.calendarManager.calendarAppearance dayDotColorToday];
        }
        else{
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorTodayOtherMonth];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorTodayOtherMonth];
//            dotView.color = [self.calendarManager.calendarAppearance dayDotColorTodayOtherMonth];
        }
        textLabel.font = self.calendarManager.calendarAppearance.dayTextFont;
    }
    else{
        if(!self.isOtherMonth){
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColor];
//            dotView.color = [self.calendarManager.calendarAppearance dayDotColor];
        }
        else{
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
//            dotView.color = [self.calendarManager.calendarAppearance dayDotColorOtherMonth];
        }
        textLabel.font = self.calendarManager.calendarAppearance.dayTextFont;
        opacity = 0.;
    }
    
    if(animated){
        [UIView animateWithDuration:.3 animations:^{
            circleView.layer.opacity = opacity;
            circleView.transform = tr;
        }];
    }
    else{
        circleView.layer.opacity = opacity;
        circleView.transform = tr;
    }
}


- (void)setIsOtherMonth:(BOOL)isOtherMonth
{
    self->_isOtherMonth = isOtherMonth;
    [self setSelected:isSelected animated:NO];
}

- (void)reloadData
{
    int numberOfEvents = [self.calendarManager.dataCache numberOfEvents:self.date];
    if (numberOfEvents > 8) numberOfEvents = 8;
    
    if (!dotViews) {
        NSMutableArray *dotArray = [NSMutableArray arrayWithCapacity:numberOfEvents];
        for (int i = 0; i < numberOfEvents; i++) {
            JTCircleView *dotView = [JTCircleView new];
            [self addSubview:dotView];
            [dotArray addObject:dotView];
        }
        dotViews = dotArray;
    }
    
    BOOL selected = [self isSameDate:[self.calendarManager currentDateSelected]];
    [self setSelected:selected animated:NO];
}

- (BOOL)isToday
{
    if(cacheIsToday == 0){
        return NO;
    }
    else if(cacheIsToday == 1){
        return YES;
    }
    else{
        if([self isSameDate:[NSDate date]]){
            cacheIsToday = 1;
            return YES;
        }
        else{
            cacheIsToday = 0;
            return NO;
        }
    }
}

- (BOOL)isSameDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    
    if(!cacheCurrentDateText){
        cacheCurrentDateText = [dateFormatter stringFromDate:self.date];
    }
    
    NSString *dateText2 = [dateFormatter stringFromDate:date];
    
    if ([cacheCurrentDateText isEqualToString:dateText2]) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)monthIndexForDate:(NSDate *)date
{
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

- (void)reloadAppearance
{
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = self.calendarManager.calendarAppearance.dayTextFont;
    backgroundView.backgroundColor = self.calendarManager.calendarAppearance.dayBackgroundColor;
    backgroundView.layer.borderWidth = self.calendarManager.calendarAppearance.dayBorderWidth;
    backgroundView.layer.borderColor = self.calendarManager.calendarAppearance.dayBorderColor.CGColor;
    
    [self configureConstraintsForSubviews];
    [self setSelected:isSelected animated:NO];
}

@end
