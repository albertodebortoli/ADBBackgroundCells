//
//  UITableViewCell+Background.m
//  ADBBackgroundCells
//  v2.0.0
//
//  Created by Alberto De Bortoli on 2/23/13.
//  Copyright (c) 2013 Alberto De Bortoli. All rights reserved.
//

#import <objc/runtime.h>
#import "UITableView+ADBBackground.h"
#import "UITableViewCell+ADBBackground.h"

static void *kUITableViewCellIsRunning           = "isRunning";
static void *kUITableViewCellInvocationOperation = "invocationOperation";
static void *kUITableViewCellBackgroundBlock     = "backgroundBlock";
static void *kUITableViewCellCallbackBlock       = "callbackBlock";

@interface UITableViewCell (ADBBackgroundInternal)

@property (nonatomic, strong) NSNumber *isRunning;
@property (nonatomic, strong) NSInvocationOperation *invocationOperation;
@property (nonatomic, copy) VoidBlock backgroundBlock;
@property (nonatomic, copy) CellCallbackBlock callbackBlock;

@end

@implementation UITableViewCell (ADBBackground)

#pragma mark - Accessors using runtime

- (NSNumber *)isRunning
{
    return objc_getAssociatedObject(self, kUITableViewCellIsRunning);
}

- (void)setIsRunning:(NSNumber *)isRunning
{
    objc_setAssociatedObject(self, kUITableViewCellIsRunning, isRunning ? isRunning : [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInvocationOperation *)invocationOperation
{
    return objc_getAssociatedObject(self, kUITableViewCellInvocationOperation);
}

- (void)setInvocationOperation:(NSInvocationOperation *)invocationOperation
{
    objc_setAssociatedObject(self, kUITableViewCellInvocationOperation, invocationOperation ? invocationOperation : [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (VoidBlock)backgroundBlock
{
    return objc_getAssociatedObject(self, kUITableViewCellBackgroundBlock);
}

- (void)setBackgroundBlock:(VoidBlock)backgroundBlock
{
    if (backgroundBlock) {
        objc_setAssociatedObject(self, kUITableViewCellBackgroundBlock, backgroundBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (CellCallbackBlock)callbackBlock
{
    return objc_getAssociatedObject(self, kUITableViewCellCallbackBlock);
}

- (void)setCallbackBlock:(CellCallbackBlock)callbackBlock
{
    if (callbackBlock) {
        objc_setAssociatedObject(self, kUITableViewCellCallbackBlock, callbackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

#pragma mark - Public

- (void)addBackgroundBlock:(VoidBlock)backgroundBlock
             callbackBlock:(CellCallbackBlock)callbackBlock
                usingQueue:(NSOperationQueue *)operationQueue
{
    [self prepareForNewBackgroundJob];
    
    self.backgroundBlock = backgroundBlock;
    self.callbackBlock = callbackBlock;
    
    self.invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                    selector:@selector(backgroundSelector)
                                                                      object:nil];
    [operationQueue addOperation:self.invocationOperation];
}

#pragma mark - Private

- (void)prepareForNewBackgroundJob
{
    [self.invocationOperation cancel];
    self.backgroundBlock = nil;
    self.callbackBlock = nil;
    self.invocationOperation = nil;
    self.isRunning = @0;
}

- (void)backgroundSelector
{
    @autoreleasepool {
        self.isRunning = @(YES);
        if (self.backgroundBlock) {
            self.backgroundBlock();
            self.backgroundBlock = nil;
        }
        [self performSelectorOnMainThread:@selector(callbackSelector) withObject:nil waitUntilDone:NO];
    }
}

- (void)callbackSelector
{
    if ([self.isRunning isEqualToNumber:@YES] && self.callbackBlock) {
        self.callbackBlock(self);
        self.callbackBlock = nil;
    }
}

@end
