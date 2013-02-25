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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseCellId];
        cell.textLabel.text = @"New cell";
    } else {
        cell.textLabel.text = @"Reused cell";
    }
    
    cell.detailTextLabel.text = @"performing background operation...";
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    __block NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    [cell addBackgroundBlock:^{
        // long time job performed on a background thread
        for (int i = 0; i < 5000000; i++) {
            i++;
            i--;
        }
        [info setObject:@"Long job output" forKey:@"output"];
    } callbackBlock:^(id theCell){
        // callback to update the UI
        UITableViewCell *c = (UITableViewCell *)theCell;
        c.textLabel.text = [NSString stringWithFormat:@"Done (%d): <%@>", indexPath.row, [info objectForKey:@"output"]];
        c.detailTextLabel.text = @"callback updated the UI on main thread";
        c.backgroundColor = [UIColor greenColor];
        c.accessoryType = UITableViewCellAccessoryCheckmark;
    } usingQueue:tableView.operationQueue];
    
    return cell;
}

@end
