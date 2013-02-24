//
//  UITableViewCell+Background.h
//  ADBBackgroundCells
//  v1.0.0
//
//  Created by Alberto De Bortoli on 2/23/13.
//  Copyright (c) 2013 Alberto De Bortoli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^VoidBlock)(void);
typedef void (^CellCallbackBlock)(id cell);

@interface UITableViewCell (Background)

/**
 This method should be called in tableView:cellForRowAtIndexPath:. As soon as this
 method is called the background operation will be put in the queue, and therefore scheduled.
 
 @param backgroundBlock, the block performed on a background thread
  using UIKit is forbidden since the framework is not thread safe
 
 @param callbackBlock, the block performed on the main thread as a callback
  of backgroundBlock. The cell argument of callbackBlock is the receiver of this method.
  The correct way to pass here the background output is to create a
  __block NSMutableDictionary *info = [NSMutableDictionary dictionary];
  before calling this method and call setObject:forKey: in the backgroundBlock
  when outputs are calculated.
  The info dictionary will be available in the callbackBlock.
 
 @param operationQueue, the queue to use to execute the backgroundBlock. Usually it
  should be tableView.operationQueue. It's important to create the tableView's queue
  in a safe place (the `viewDidLoad` method or the designated initializer of the
  controller containing the table view) and set maxConcurrentOperationCount property to 1.
 */
- (void)addBackgroundBlock:(VoidBlock)backgroundBlock
             callbackBlock:(CellCallbackBlock)callbackBlock
                usingQueue:(NSOperationQueue *)operationQueue;

/**
 This method should be called in the prepareForReuse method of the UITableViewCell subclass
 */
- (void)prepareForNewBackgroundJob;

@property (nonatomic, assign) NSNumber *isRunning;
@property (nonatomic, strong) NSInvocationOperation *invocationOperation;
@property (nonatomic, strong) VoidBlock backgroundBlock;
@property (nonatomic, strong) CellCallbackBlock callbackBlock;

@end
