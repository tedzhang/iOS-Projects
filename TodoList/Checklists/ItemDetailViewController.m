//
//  AddItemViewController.m
//  Checklists
//
//  Created by ted zhang on 14-2-5.
//  Copyright (c) 2014年 ted zhang. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ChecklistItem.h"

@interface ItemDetailViewController ()


@end

@implementation ItemDetailViewController
{
    NSDate *_dueDate;
    BOOL _datePickerVisible;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.itemToEdit != nil)
    {
        self.title = @"Edit Item";
        self.txtField.text = self.itemToEdit.text;
        self.remindSwitch.on = self.itemToEdit.shouldRemind;
        _dueDate = self.itemToEdit.dueDate;
    }
    else
    {
        self.remindSwitch.on = NO;
        _dueDate = [NSDate date];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)updateDueDateLabel
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.dueDateLabel.text = [formatter stringFromDate:_dueDate];
}

-(void)showDatePicker
{
    _datePickerVisible = YES;
    
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    cell.detailTextLabel.textColor = cell.detailTextLabel.tintColor;
    
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker*)[datePickerCell viewWithTag:100];
   
    _dueDate = _dueDate ? _dueDate:[NSDate date];
    [datePicker setDate:_dueDate animated:NO];

    
}

-(void)hideDatePicker
{
   
    if(!_datePickerVisible)
        return;
    _datePickerVisible = NO;
    
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    
    
    [self.tableView beginUpdates];
    
    //[self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
    

}




-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2 && indexPath.section == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DatePickerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
            datePicker.tag = 100;
            [cell.contentView addSubview:datePicker];
            
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        }
        return cell;
    }
    else
    {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

-(void)dateChanged:(UIDatePicker*)datePicker
{
    _dueDate = datePicker.date;
    [self updateDueDateLabel];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 && _datePickerVisible)
    {
        return 3;
    }
    else
    {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 && indexPath.section == 1)
    {
        return indexPath;
    }
    return nil;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 2 && indexPath.section == 1)
    {
        return 217.0f;
    }
    else
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.txtField resignFirstResponder];
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        if(_datePickerVisible)
            [self hideDatePicker];
        else
            [self showDatePicker];
    }
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2)
    {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    }
    else
    {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

-(IBAction)done
{
    NSLog(@"the string is %@",self.txtField.text);
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    if (self.itemToEdit)
    {
        self.itemToEdit.text = self.txtField.text;
        self.itemToEdit.shouldRemind = self.remindSwitch.on;
        self.itemToEdit.dueDate = _dueDate;
        [self.delegate addItemViewController:self didFinishEditingItem:self.itemToEdit];
        [self.itemToEdit scheduleNotification];
    }
    else
    {
        ChecklistItem *item = [[ChecklistItem alloc] init];
        item.text = self.txtField.text;
        item.checked = NO;
        item.shouldRemind = self.remindSwitch.on;
        item.dueDate = _dueDate;
        
        [self.delegate addItemViewController:self didFinishAddingItem:item];
        [item scheduleNotification];

    }
}

-(IBAction)cancel
{
    [self.delegate addItemViewControllerDidCancel:self];
    
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.txtField becomeFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string // return NO to not change text
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = [newText length] > 0;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hideDatePicker];
}


@end
