//
//  ViewController.h
//  Checklists
//
//  Created by ted zhang on 14-2-4.
//  Copyright (c) 2014年 ted zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"

@interface ChecklistsViewController : UITableViewController<ItemDetailViewControllerDelegate>

-(void)saveChecklistItems;

@end
