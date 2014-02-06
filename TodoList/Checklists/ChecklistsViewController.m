//
//  ViewController.m
//  Checklists
//
//  Created by ted zhang on 14-2-4.
//  Copyright (c) 2014年 ted zhang. All rights reserved.
//

#import "ChecklistsViewController.h"
#import "ChecklistItem.h"

@interface ChecklistsViewController ()

-(void) updateCell:(UITableViewCell*)cell cellForRowAtIndexPath:(NSIndexPath*)indexPath;

@end

@implementation ChecklistsViewController
{
    NSMutableArray * _items;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self loadChecklistItems];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewDataSource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistsItem"];
    UILabel *label = (UILabel*)[cell viewWithTag:1000];
    label.textAlignment = NSTextAlignmentLeft;
   
    ChecklistItem *item = _items[indexPath.row];
    label.text = item.text;
    [self updateCell:cell cellForRowAtIndexPath:indexPath];
    
    return cell;
}

-(void) updateCell:(UITableViewCell*)cell cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    ChecklistItem *item = _items[indexPath.row];
    UILabel *flagLabel = (UILabel*)[cell viewWithTag:1001];
    if (item.checked)
    {
        flagLabel.text = @"√";
    }
    else
    {
        flagLabel.text = @"";
    }
    UILabel *txtLabel = (UILabel*)[cell viewWithTag:1000];
    txtLabel.text = item.text;
}

#pragma mark tableViewDelegate
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ChecklistItem *item = _items[indexPath.row];
    [item toggleChecked];
    
    [self updateCell:cell cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_items removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)addItemViewControllerDidCancel:(ItemDetailViewController*)controller
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)addItemViewController:(ItemDetailViewController*)controller didFinishAddingItem:(ChecklistItem*)item
{
    [self dismissViewControllerAnimated:FALSE completion:nil];
    NSInteger newRowIndex = [_items count];
    [_items addObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *array = @[indexPath];
    
    [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)addItemViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item
{
    NSInteger index = [_items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self updateCell:cell cellForRowAtIndexPath:indexPath];
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddItem"])
    {
        UINavigationController *navController = segue.destinationViewController;
        ItemDetailViewController *addItemViewController = (ItemDetailViewController*)navController.topViewController;
        addItemViewController.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"EditItem"])
    {
        UINavigationController *navController = segue.destinationViewController;
        ItemDetailViewController *addItemViewController = (ItemDetailViewController*)navController.topViewController;
        addItemViewController.delegate = self;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        addItemViewController.itemToEdit = _items[indexPath.row];
    }
}


#pragma mark seralization

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Checklists.plist"];
}

-(void)loadChecklistItems
{
    NSString *path = [self dataFilePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _items = [unarchiver decodeObjectForKey:@"ChecklistItems"];
        [unarchiver finishDecoding];
    }
    else
    {
        _items = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

-(void)saveChecklistItems
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:_items forKey:@"ChecklistItems"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
    NSLog(@"the file path is %@",[self dataFilePath]);
}



@end
