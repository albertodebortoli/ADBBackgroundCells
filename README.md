ADBBackgroundCells
===========================

ADBBackgroundCells main goals are:

* non-bocking UI while scrolling UITableViews
* performing in background long time jobs whose output is to be presented in cells
* performing jobs only for currently visible cells

![Example-Short](./images/short.gif)

ADBBackgroundCells allow lazy loading for UITableViewCell objects performing a long time job in background without blocking the UI. NSInvocationOperation are used under the hood in place of GCD (Grand Central Dispatch) since operations put in a NSOperationQueue object can be canceled. This threading fashion allows optimized long scrolling where a lot of cells are displayed and immediately reused/disappeared, without the obligation to execute the job of no more visible cells.
ADBBackgroundCells are block-based and use Objective-C runtime. 

If you'd like to include this component as a pod using [CocoaPods](http://cocoapods.org/), just add the following line to your Podfile: `pod "ADBBackgroundCells"`

Try out the included demo project.

Usage:
- copy `UITableViewCell+Background.{h|m}` and `UITableView+Background.{h|m}` into your project
- import `UITableView+Background.h` and `UITableViewCell+Background.h` in your code
- implement `tableView:cellForRowAtIndexPath:` similarly as follows:

``` objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseCellId = @"reuseCellId";
    MyUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    if (!cell) {
        cell = [[MyUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseCellId];
    }
    	
    NSMutableDictionary *info = [NSMutableDictionary dictionary];

    [cell addBackgroundBlock:^{
		// long time job performed on a background thread
		...
		[info setObject:@"Long job output" forKey:@"output"];
    } callbackBlock:^(id cell){
		MyUITableViewCell *c = (MyUITableViewCell *)cell;
        // callback to update the UI
		c.textLabel.text = [info objectForKey:@"output"];
		...
    } usingQueue:tableView.operationQueue];
    
    return cell;
}
```

- last but not least, create a `NSOperationQueue` in a safe place (the `viewDidLoad` method or the designated initializer of the controller containing the table view)

``` objective-c
- (void)viewDidLoad
{
	[super viewDidLoad];
    self.tableView.operationQueue = [[NSOperationQueue alloc] init];
    self.tableView.operationQueue.maxConcurrentOperationCount = 1;
	...
}
```

# License

Licensed under the New BSD License.

Copyright (c) 2012, Alberto De Bortoli
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Alberto De Bortoli nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Alberto De Bortoli BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Resources

Info can be found on [my website](http://www.albertodebortoli.it), [and on Twitter](http://twitter.com/albertodebo).