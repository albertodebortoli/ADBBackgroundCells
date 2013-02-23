//
//  ADBViewController.m
//  ADBBackgroundCells
//
//  Created by Alberto De Bortoli on 2/23/13.
//  Copyright (c) 2013 Alberto De Bortoli. All rights reserved.
//

#import "ADBViewController.h"
#import "UITableView+Background.h"
#import "UITableViewCell+Background.h"
#import "DEMOUITableViewCell.h"

@interface ADBViewController ()

@end

@implementation ADBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.operationQueue = [[NSOperationQueue alloc] init];
    self.tableView.operationQueue.maxConcurrentOperationCount = 1;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseCellId = @"reuseCellId";
    DEMOUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    if (!cell) {
        cell = [[DEMOUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseCellId];
        cell.textLabel.text = @"New cell";
        cell.detailTextLabel.text = @"performing background operation...";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    __block NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    [cell addBackgroundBlock:^{
        for (int i = 0; i < 5000000; i++) {
            i++;
            i--;
        }
        [info setObject:@"Long job output" forKey:@"output"];
    } callbackBlock:^(id theCell){
        DEMOUITableViewCell *c = (DEMOUITableViewCell *)theCell;
        c.textLabel.text = [NSString stringWithFormat:@"Done (%d): <%@>", indexPath.row, [info objectForKey:@"output"]];
        c.detailTextLabel.text = @"callback updated the UI on main thread";
        c.backgroundColor = [UIColor greenColor];
        c.accessoryType = UITableViewCellAccessoryCheckmark;
    } usingQueue:tableView.operationQueue];
    
    return cell;
}

@end
