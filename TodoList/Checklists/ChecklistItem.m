//
//  ChecklistItem.m
//  Checklists
//
//  Created by ted zhang on 14-2-5.
//  Copyright (c) 2014年 ted zhang. All rights reserved.
//

#import "ChecklistItem.h"
#import "AppDelegate.h"

@implementation ChecklistItem

@synthesize text = _text;
@synthesize checked =_checked;




+(id)initWithTextAndState:(NSString*) text checked:(BOOL)isChecked
{
    ChecklistItem *item = [[ChecklistItem alloc] init];
    if (item)
    {
        item.text = text;
        item.checked = isChecked;
    }
    return item;
}

-(id)init
{
    if (self = [super init])
    {
        self.itemId = [AppDelegate nextItemId];
    }
    return self;
}

-(void)toggleChecked
{
    self.checked = !self.checked;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeBool:self.checked forKey:@"checked"];
    [aCoder encodeObject:self.dueDate forKey:@"dueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"shouldRemind"];
    [aCoder encodeInteger:self.itemId forKey:@"itemId"];
    
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
    {
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.checked =[aDecoder decodeBoolForKey:@"checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"dueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"shouldRemind"];
        self.itemId       = [aDecoder decodeIntegerForKey:@"itemId"];
    }
    return self;
}

-(void)scheduleNotification
{
    UILocalNotification *existNotification = [self notificationForThisItem];
    if (existNotification)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:existNotification];
    }
    if(self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedAscending)
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo= @{@"itemid":@(self.itemId)};
        [[UIApplication sharedApplication] scheduleLocalNotification: localNotification];
        
    }
}

-(UILocalNotification*)notificationForThisItem
{
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in allNotifications)
    {
        NSNumber *number =[notification.userInfo objectForKey:@"itemid"];
        if (number != nil && [number integerValue] == self.itemId)
        {
            return notification;
        }
    }
    return nil;
}

-(void)dealloc
{
    UILocalNotification *existNotification = [self notificationForThisItem];
    if (existNotification)
    {
       [[UIApplication sharedApplication] cancelLocalNotification:existNotification];
    }
}

@end
