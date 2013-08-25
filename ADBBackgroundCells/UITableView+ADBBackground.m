//
//  UITableView+ADBBackground.m
//  ADBBackgroundCells
//  v2.0.0
//
//  Created by Alberto De Bortoli on 2/23/13.
//  Copyright (c) 2013 Alberto De Bortoli. All rights reserved.
//

#import <objc/runtime.h>
#import "UITableView+ADBBackground.h"

static void *kUITableViewOperationQueue = "operationQueue";

@implementation UITableView (ADBBackground)

@dynamic operationQueue;

- (NSOperationQueue *)operationQueue
{
    return objc_getAssociatedObject(self, kUITableViewOperationQueue);
}

- (void)setOperationQueue:(NSOperationQueue *)operationQueue
{
    objc_setAssociatedObject(self, kUITableViewOperationQueue, operationQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
