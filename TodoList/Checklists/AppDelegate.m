//
//  AppDelegate.m
//  Checklists
//
//  Created by ted zhang on 14-2-4.
//  Copyright (c) 2014年 ted zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "ChecklistsViewController.h"

@implementation AppDelegate

static NSInteger nextItemId = 0;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   //[self makeLocalNotification];
    // Override point for customization after application launch.
    nextItemId = [[NSUserDefaults standardUserDefaults] integerForKey:@"checklistItemId"];
    if (nextItemId == 0)
    {
        nextItemId = 1;
    }
    
    return YES;
}

//-(void)makeLocalNotification
//{
//    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:3];
//    
//    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = date;
//    localNotification.timeZone = [NSTimeZone defaultTimeZone];
//    localNotification.alertBody = @"I am an alert";
//    localNotification.soundName = UILocalNotificationDefaultSoundName;
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification: localNotification];
//}

-(void) saveData
{
    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
    ChecklistsViewController *controller = navigationController.viewControllers[0];
    [controller saveChecklistItems];
    
    [[NSUserDefaults standardUserDefaults] setInteger:nextItemId forKey:@"checklistItemId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveData];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveData];
}

-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"did receive notification %@",notification);
}

+(NSInteger) nextItemId
{
    return nextItemId++;
}

@end
