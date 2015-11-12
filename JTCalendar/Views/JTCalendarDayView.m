//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"

#import "JTCalendarManager.h"
#import "JTCalendarDotsView.h"


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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.clipsToBounds = YES;
    
    _circleRatio = .9;
    _dotRatio = 1. / 9.;
    _textLabelHeightRatio = 0.5;
    _textLabelTopSpaceConstant = 6.0;
    
    {
        _circleView = [UIView new];
        [self addSubview:_circleView];
        
        _circleView.backgroundColor = [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5];
        _circleView.hidden = YES;

        _circleView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _circleView.layer.shouldRasterize = YES;
    }
    
    {
        _dotViews = [JTCalendarDotsView new];
        _dotViews.manager = _manager;
        _dotViews.date = self.date;
        [self addSubview:_dotViews];
    }
    
    {
        _dotView = [UIView new];
        [self addSubview:_dotView];
        
        _dotView.backgroundColor = [UIColor redColor];
        _dotView.hidden = YES;

        _dotView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _dotView.layer.shouldRasterize = YES;
    }
    
    {
        _textLabel = [UILabel new];
        [self addSubview:_textLabel];
        
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
}

- (void)layoutSubviews
{
    CGFloat height = self.bounds.size.height * _textLabelHeightRatio;
    
    _textLabel.frame = CGRectMake(0, _textLabelTopSpaceConstant, self.frame.size.width, height);
    
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * _circleRatio;
    sizeDot = sizeDot * _dotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    _circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _circleView.center = _textLabel.center;
    _circleView.layer.cornerRadius = sizeCircle / 2.;
    
    _dotView.frame = CGRectMake(0, 0, sizeDot, sizeDot);
    _dotView.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) +sizeDot * 2.5);
    _dotView.layer.cornerRadius = sizeDot / 2.;
    
    CGFloat y = CGRectGetMaxY(_textLabel.frame);
    y += self.manager.settings.dayDotTopSpace;
    sizeDot = self.manager.settings.dayDotDiameter;
    CGFloat dotMargin = self.manager.settings.dayDotMargin;
    int dayDotLineLimit = self.manager.settings.dayDotLineWidthLimit;
    int dayDotHeightLimit = self.manager.settings.dayDotLineHeightLimit;
    
    CGFloat width = dayDotLineLimit * (sizeDot + dotMargin);
    height = dayDotHeightLimit * (sizeDot + dotMargin);
    _dotViews.frame = CGRectMake(0, y, width, height);
    _dotViews.center = CGPointMake(_textLabel.center.x, _dotViews.center.y);
}

- (void)setDate:(NSDate *)date
{
    NSAssert(date != nil, @"date cannot be nil");
    NSAssert(_manager != nil, @"manager cannot be nil");
    
    self->_date = date;
    [_dotViews setDate:_date];
    [self reload];
}

- (void)reload
{
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [_manager.dateHelper createDateFormatter];
        [dateFormatter setDateFormat:@"d"];
    }
    
    _textLabel.text = [dateFormatter stringFromDate:_date];
    _dotViews.manager = _manager;
    [_manager.delegateManager prepareDayView:self];
//    [_dotViews reload];
}

- (void)didTouch
{
    [_manager.delegateManager didTouchDayView:self];
}

@end
