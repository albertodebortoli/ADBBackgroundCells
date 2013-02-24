//
//  UITableView+Background.m
//  ADBBackgroundCells
//  v1.0.0
//
//  Created by Alberto De Bortoli on 2/23/13.
//  Copyright (c) 2013 Alberto De Bortoli. All rights reserved.
//

#import <objc/runtime.h>
#import "UITableView+Background.h"

NSString const *kUITableViewOperationQueue = @"operationQueue";

@implementation UITableView (Background)

@dynamic operationQueue;

- (NSOperationQueue *)operationQueue
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kUITableViewOperationQueue));
}

- (void)setOperationQueue:(NSOperationQueue *)operationQueue
{
    [self willChangeValueForKey:@"operationQueue"];
    objc_setAssociatedObject(self, (__bridge const void *)(kUITableViewOperationQueue), operationQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"operationQueue"];
}

@end
