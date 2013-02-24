//
//  UITableViewCell+Background.m
//  ADBBackgroundCells
//  v1.0.0
//
//  Created by Alberto De Bortoli on 2/23/13.
//  Copyright (c) 2013 Alberto De Bortoli. All rights reserved.
//

#import <objc/runtime.h>
#import "UITableView+Background.h"
#import "UITableViewCell+Background.h"

NSString const *kUITableViewCellIsRunning           = @"isRunning";
NSString const *kUITableViewCellInvocationOperation = @"invocationOperation";
NSString const *kUITableViewCellBackgroundBlock     = @"backgroundBlock";
NSString const *kUITableViewCellCallbackBlock       = @"callbackBlock";

@implementation UITableViewCell (Background)

@dynamic isRunning;
@dynamic invocationOperation;
@dynamic backgroundBlock;
@dynamic callbackBlock;

#pragma mark - Accessors using runtime

- (NSNumber *)isRunning
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kUITableViewCellIsRunning));
}

- (void)setIsRunning:(NSNumber *)isRunning
{
    [self willChangeValueForKey:@"isRunning"];
    objc_setAssociatedObject(self, (__bridge const void *)(kUITableViewCellIsRunning), isRunning, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"isRunning"];
}

- (NSInvocationOperation *)invocationOperation
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kUITableViewCellInvocationOperation));
}

- (void)setInvocationOperation:(NSInvocationOperation *)invocationOperation
{
    [self willChangeValueForKey:@"invocationOperation"];
    objc_setAssociatedObject(self, (__bridge const void *)(kUITableViewCellInvocationOperation), invocationOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"invocationOperation"];
}

- (VoidBlock)backgroundBlock
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kUITableViewCellBackgroundBlock));
}

- (void)setBackgroundBlock:(VoidBlock)backgroundBlock
{
    [self willChangeValueForKey:@"backgroundBlock"];
    objc_setAssociatedObject(self, (__bridge const void *)(kUITableViewCellBackgroundBlock), backgroundBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"backgroundBlock"];
}

- (CellCallbackBlock)callbackBlock
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kUITableViewCellCallbackBlock));
}

- (void)setCallbackBlock:(CellCallbackBlock)callbackBlock
{
    [self willChangeValueForKey:@"callbackBlock"];
    objc_setAssociatedObject(self, (__bridge const void *)(kUITableViewCellCallbackBlock), callbackBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"callbackBlock"];
}

#pragma mark - Public

- (void)addBackgroundBlock:(VoidBlock)backgroundBlock
             callbackBlock:(CellCallbackBlock)callbackBlock
                usingQueue:(NSOperationQueue *)operationQueue
{
    self.backgroundBlock = backgroundBlock;
    self.callbackBlock = callbackBlock;
    
    self.invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                    selector:@selector(backgroundSelector)
                                                                      object:nil];
    [operationQueue addOperation:self.invocationOperation];
}

- (void)prepareForNewBackgroundJob
{
    [self.invocationOperation cancel];
    self.invocationOperation = nil;
    self.isRunning = nil;
}

#pragma mark - Private

- (void)backgroundSelector
{
    @autoreleasepool {
        self.isRunning = @(YES);
        self.backgroundBlock();
        [self performSelectorOnMainThread:@selector(callbackSelector) withObject:nil waitUntilDone:NO];
    }
}

- (void)callbackSelector
{
    if ([self.isRunning isEqualToNumber:@YES]) {
        self.callbackBlock(self);
    }
}

@end
