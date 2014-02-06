//
//  ChecklistItem.h
//  Checklists
//
//  Created by ted zhang on 14-2-5.
//  Copyright (c) 2014年 ted zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChecklistItem : NSObject<NSCoding>

@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) BOOL checked;
@property (nonatomic,copy) NSDate *dueDate;
@property (nonatomic,assign) BOOL shouldRemind;
@property (nonatomic,assign) NSInteger itemId;


-(void)toggleChecked;

+(id)initWithTextAndState:(NSString*) text checked:(BOOL)isChecked;
-(id)init;
-(void)scheduleNotification;

@end
