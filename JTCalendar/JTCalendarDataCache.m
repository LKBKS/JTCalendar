//
//  JTCalendarDataCache.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDataCache.h"

#import "JTCalendar.h"

@interface JTCalendarDataCache(){
    NSMutableDictionary *events;
    NSDateFormatter *dateFormatter;
};

@end

@implementation JTCalendarDataCache

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    events = [NSMutableDictionary new];
    
    return self;
}

- (void)reloadData
{
    [events removeAllObjects];
}

- (BOOL)haveEvent:(NSDate *)date
{
    if(!self.calendarManager.dataSource){
        return NO;
    }
    
    if(!self.calendarManager.calendarAppearance.useCacheSystem){
        return [self.calendarManager.dataSource calendarHaveEvent:self.calendarManager date:date];
    }
    
    BOOL haveEvent;
    NSString *key = [dateFormatter stringFromDate:date];
    
    if(events[key] != nil){
        haveEvent = [events[key] boolValue];
    }
    else{
        haveEvent = [self.calendarManager.dataSource calendarHaveEvent:self.calendarManager date:date];
        events[key] = [NSNumber numberWithBool:haveEvent];
    }
    
    return haveEvent;
}

- (int)numberOfEvents:(NSDate *)date
{
    if(!self.calendarManager.dataSource){
        return 0;
    }
    
    if(!self.calendarManager.calendarAppearance.useCacheSystem){
        return [self.calendarManager.dataSource numberOfCalendarEvents:self.calendarManager date:date];
    }
    
    int numberOfEvents;
    NSString *key = [dateFormatter stringFromDate:date];
    
    if(events[key] != nil){
        numberOfEvents = [events[key] intValue];
    }
    else{
        numberOfEvents = [self.calendarManager.dataSource numberOfCalendarEvents:self.calendarManager date:date];
        events[key] = [NSNumber numberWithInt:numberOfEvents];
    }
    
    return numberOfEvents;
}
@end