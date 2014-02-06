//
//  AppDelegate.h
//  Checklists
//
//  Created by ted zhang on 14-2-4.
//  Copyright (c) 2014年 ted zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(NSInteger) nextItemId;

@end
