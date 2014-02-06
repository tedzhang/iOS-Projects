//
//  AddItemViewController.h
//  Checklists
//
//  Created by ted zhang on 14-2-5.
//  Copyright (c) 2014年 ted zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChecklistItem;
@class ItemDetailViewController;

@protocol ItemDetailViewControllerDelegate<NSObject>

-(void)addItemViewControllerDidCancel:(ItemDetailViewController*)controller;
-(void)addItemViewController:(ItemDetailViewController*)controller didFinishAddingItem:(ChecklistItem*)item;
-(void)addItemViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item;

@end


@interface ItemDetailViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UITextField *txtField;

@property (weak, nonatomic) IBOutlet UISwitch *remindSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;

@property (weak,nonatomic)id<ItemDetailViewControllerDelegate> delegate;
@property (strong,nonatomic) ChecklistItem *itemToEdit;

-(IBAction)done;
-(IBAction)cancel;

@end
