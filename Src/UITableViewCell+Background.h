//
//  UITableViewCell+Background.h
//  ADBBackgroundCells
//
//  Created by Alberto De Bortoli on 2/23/13.
//  Copyright (c) 2013 Alberto De Bortoli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^VoidBlock)(void);
typedef void (^CellCallbackBlock)(id cell);

@interface UITableViewCell (Background)

- (void)addBackgroundBlock:(VoidBlock)backgroundBlock
             callbackBlock:(CellCallbackBlock)callbackBlock
                usingQueue:(NSOperationQueue *)operationQueue;

@property (nonatomic, assign) NSNumber *isRunning;
@property (nonatomic, strong) NSInvocationOperation *invocationOperation;
@property (nonatomic, strong) VoidBlock backgroundBlock;
@property (nonatomic, strong) CellCallbackBlock callbackBlock;

@end
