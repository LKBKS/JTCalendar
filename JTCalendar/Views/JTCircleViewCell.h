//
//  JTCircleViewCell.h
//  Pods
//
//  Created by Paweł Nużka on 08/07/15.
//
//

#import <UIKit/UIKit.h>

@class JTCircleView, JTCalendar;


@interface JTCircleViewCell : UICollectionViewCell
@property (nonatomic, strong) JTCircleView* circleView;

+ (NSString *)identifier;
- (void)loadData:(UIColor *)color;
@end
