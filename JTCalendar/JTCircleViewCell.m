//
//  JTCircleViewCell.m
//  Pods
//
//  Created by Paweł Nużka on 08/07/15.
//
//

#import "JTCircleViewCell.h"
#import "JTCalendar.h"

@implementation JTCircleViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self commonInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self commonInit];
    return self;
}

- (void)loadData:(UIColor *)color
{
    self.backgroundColor = color;
//    self.circleView.color = color;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.width / 2.0;
}

+ (NSString *)identifier {
    return @"JTCircleViewCell";
}

@end
