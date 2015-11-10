//
//  JTCalendarDotsView.h
//  Pods
//
//  Created by Paweł Nużka on 08/07/15.
//
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"


@interface JTCalendarDotsView : UIView
@property (weak, nonatomic) JTCalendarManager *manager;
@property (nonatomic) NSDate *date;

- (void)setEventColors:(NSArray *)colors;
- (void)reload;
@end
