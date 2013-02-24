//
//  DEMOUITableViewCell.m
//  ADBBackgroundCells
//
//  Created by Alberto De Bortoli on 2/23/13.
//  Copyright (c) 2013 Alberto De Bortoli. All rights reserved.
//

#import "DEMOUITableViewCell.h"
#import "UITableViewCell+Background.h"

@implementation DEMOUITableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self prepareForNewBackgroundJob];

    self.textLabel.text = @"Reused cell";
    self.detailTextLabel.text = @"performing background operation...";
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
