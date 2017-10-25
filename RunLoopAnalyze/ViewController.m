//
//  ViewController.m
//  RunLoopAnalyze
//
//  Created by jiaxw-mac on 2017/10/19.
//  Copyright © 2017年 jiaxw32. All rights reserved.
//

#import "ViewController.h"
#import "RunLoopHelper.h"
#import "SwitchTableViewCell.h"
#import "ButtonTableViewCell.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


typedef NS_ENUM(NSUInteger, RLCellType) {
    RLCellTypeNormal = 0,
    RLCellTypeSwitch,
    RLCellTypeButton,
};

static NSString *const kRLNormalCellReuseIdentifier = @"NormalCell";

static NSString *const kRLSwitchCellReuseIdentifier = @"SwitchCell";

static NSString *const kRLButtonCellReuseIdentifier = @"ButtonCell";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CFRunLoopObserverRef _observer;
}

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSDate *lastDate;

@property (nonatomic,strong) NSArray *datalist;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%s——%@",__PRETTY_FUNCTION__,[NSRunLoop currentRunLoop].currentMode);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"%s——%@",__PRETTY_FUNCTION__,[NSRunLoop currentRunLoop].currentMode);
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [RunLoopHelper logCurrentRunLoop:YES];
    NSLog(@"%s——%@",__PRETTY_FUNCTION__,[NSRunLoop currentRunLoop].currentMode);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - initial data

- (void)initialData{
    _datalist = @[
                  @{
                      @"title":@"RunLoop",
                      @"cells":@[
                              @{
                                  @"title":@"add/remove observer",
                                  @"type": @1,
                                  @"action":@"addRemoveObserver:",
                                  @"showArrowIndicator": @(NO)
                                  },
                              @{
                                  @"title":@"RunLoop Details",
                                  @"type": @0,
                                  @"action":@"logCurrentRunLoopDetails",
                                  @"showArrowIndicator": @(NO)
                                  },
                              @{
                                  @"title":@"Mode Switch",
                                  @"type": @0,
                                  @"action":@"actionGotoTrackingVC",
                                  @"showArrowIndicator": @(YES)
                                  },
                              @{
                                  @"title":@"RunLoop In Child Thread",
                                  @"type": @0,
                                  @"action":@"runLoopInChildThread",
                                  @"showArrowIndicator": @(NO)
                                  },
                              @{
                                  @"title":@"performBlock",
                                  @"type": @0,
                                  @"action":@"performBlcok",
                                  @"showArrowIndicator": @(NO)
                                  },
                              ]
                      },
                  @{
                      @"title":@"Perform Selector",
                      @"cells":@[
                              @{
                                  @"title":@"Peform Selector",
                                  @"type": @0,
                                  @"action":@"",
                                  @"showArrowIndicator": @(NO)
                                  }
                              ]
                      },
                  @{
                      @"title":@"Button",
                      @"cells":@[
                              @{
                                  @"title":@"Button Click",
                                  @"type": @2,
                                  @"action":@"",
                                  @"showArrowIndicator": @(NO)
                                  }
                              ]
                      },
                  @{
                      @"title":@"Timer",
                      @"cells":@[
                              @{
                                  @"title":@"repeat timer",
                                  @"type": @1,
                                  @"action":@"onOffTimerHandler:",
                                  @"showArrowIndicator": @(NO)
                                  },
                              @{
                                  @"title":@"once timer",
                                  @"type": @0,
                                  @"action":@"timerRunOnce",
                                  @"showArrowIndicator": @(NO)
                                  }
                              ]
                      },
                  @{
                      @"title":@"GCD",
                      @"cells":@[
                              @{
                                  @"title":@"dispatch to main thread",
                                  @"type": @0,
                                  @"action":@"dispatchToMainThread",
                                  @"showArrowIndicator": @(NO)
                                  },
                              @{
                                  @"title":@"dispatch after",
                                  @"type": @0,
                                  @"action":@"dispatchAfter",
                                  @"showArrowIndicator": @(NO)
                                  }
                              ]
                      },
                  @{
                      @"title":@"Test",
                      @"cells":@[
                              @{
                                  @"title":@"test",
                                  @"type": @0,
                                  @"action":@"test",
                                  @"showArrowIndicator": @(NO)
                                  }
                              ]
                      },

                  ];
}


#pragma mark - UITableView Delgate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datalist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *sectionConfig = _datalist[section];
    NSArray *cells = sectionConfig[@"cells"];
    return cells.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 12 * 2;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, width, 60)];
    NSDictionary *sectionConfig = _datalist[section];
    lbl.text = sectionConfig[@"title"];
    [view addSubview:lbl];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *sectionConfig = _datalist[indexPath.section];
    NSArray *cells = sectionConfig[@"cells"];
    NSDictionary *cellConfig = cells[indexPath.row];
    NSString *title = cellConfig[@"title"];
    RLCellType cellType = [cellConfig[@"type"] integerValue];
    switch (cellType) {
        case RLCellTypeSwitch:{
            SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRLSwitchCellReuseIdentifier forIndexPath:indexPath];
            cell.text = title;
            __weak typeof(self) weakSelf = self;
            cell.onSwitchValueChangedBlock = ^(BOOL isOn) {
                NSString *action = cellConfig[@"action"];
                if (action && action.length > 0 && [self respondsToSelector:NSSelectorFromString(action)]) {
                    SuppressPerformSelectorLeakWarning(
                                                       [weakSelf performSelector:NSSelectorFromString(action) withObject:@(isOn)];
                                                       );
                }

            };
            return cell;
        }
            break;
        case RLCellTypeButton:{
            ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRLButtonCellReuseIdentifier forIndexPath:indexPath];
            cell.text = title;
            cell.onButtonClickHandler = ^(UIButton *sender) {
                NSLog(@"button clicked");
            };
            return cell;
        }
            break;
        default:{
            BOOL showIndicator = [cellConfig[@"showArrowIndicator"] boolValue];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRLNormalCellReuseIdentifier forIndexPath:indexPath];
            if (showIndicator) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = title;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *sectionConfig = _datalist[indexPath.section];
    NSArray *cells = sectionConfig[@"cells"];
    NSDictionary *cellConfig = cells[indexPath.row];
    RLCellType cellType = [cellConfig[@"type"] integerValue];
    if (cellType == RLCellTypeNormal) {
        NSString *action = cellConfig[@"action"];
        if (action && action.length > 0 && [self respondsToSelector:NSSelectorFromString(action)]) {
            SuppressPerformSelectorLeakWarning(
                                               [self performSelector:NSSelectorFromString(action) withObject:nil];
                                               );
        }
    }

}

#pragma mark - Timer

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(repeadTimerHandler:) userInfo:nil repeats:YES];
        _timer.tolerance = 3.0 * 0.1;
    }
    return _timer;
}

- (void)repeadTimerHandler:(id)sender{
    if (_lastDate) {
        NSDate *date = [NSDate new];
        NSTimeInterval timerInterval = [date timeIntervalSinceDate:_lastDate];
        _lastDate = date;
        NSLog(@"timeInterval:%f",timerInterval);
    } else {
        //first time fired
        _lastDate = [NSDate new];
        [RunLoopHelper logCurrentRunLoop:NO];
    }
}

- (void)timerRunOnce{
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate new] interval:3.0 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
    //        [timer fire];
    //if you doesn't add timer to runloop,even you fire it,it doesn't work
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)timerHandler:(id)sender{
    NSLog(@"current datetime:%@",[NSDate new]);
    NSLog(@"current mode name:%@\n",[RunLoopHelper getCurrentRunLoopModeName]);
}

- (void)onOffTimerHandler:(NSNumber *)isOn{
    if ([isOn boolValue]) {
        [self.timer fire];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}


#pragma mark - action

- (void)onButtonClick:(UIButton *)sender {
    NSLog(@"button click event handler");
    [RunLoopHelper logCurrentRunLoop:NO];
    /*
     printf("\n===============begin %s===============\n",__PRETTY_FUNCTION__);
     NSArray *symbols = [NSThread callStackSymbols];
     for (id item in symbols) {
     printf("%s\n",[item UTF8String]);
     }
     printf("\n===============end %s===============\n",__PRETTY_FUNCTION__);
     */
}


#pragma mark - GCD

- (void)dispatchToMainThread{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:1.0];
        [RunLoopHelper logCurrentRunLoop:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [RunLoopHelper logCurrentRunLoop:NO];
        });
    });
}

- (void)dispatchAfter{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%s:dispatch_after",__func__);
    });
}


#pragma mark - RunLoop

- (void)performBlcok{
    [RunLoopHelper performBlockInRunLoop:CFRunLoopGetCurrent() mode:kCFRunLoopDefaultMode block:^{
        NSLog(@"haha");
        NSLog(@"%s",__func__);
    }];
}

- (void)logCurrentRunLoopDetails{
    [RunLoopHelper logCurrentRunLoop:YES];
}

- (void)actionGotoTrackingVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tracking" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TrackingViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addRemoveObserver:(NSNumber *)isAdd{
    if ([isAdd boolValue]) {
        _observer = [RunLoopHelper addObserverOnMode:kCFRunLoopDefaultMode observerType:kCFRunLoopAllActivities];
    } else {
        [RunLoopHelper removeObserver:_observer onMode:kCFRunLoopDefaultMode];
    }
}

- (void)runLoopInChildThread{
    [self performSelector:@selector(logCurrentRunLoopDetails)
                 onThread:[[self class] runLoopThread]
               withObject:nil
            waitUntilDone:NO
                    modes:[NSArray arrayWithObject:NSRunLoopCommonModes]
     ];
}

+ (NSThread *)runLoopThread{
    static NSThread *thread = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(runLoopThreadEntryPoint:) object:nil];
        [thread start];
    });
    return thread;
}

+ (void)runLoopThreadEntryPoint:(id) __unused obj{
    @autoreleasepool {
        [[NSThread currentThread] setName:@"com.RunLoopAnalyze.runloop"];
        [RunLoopHelper logCurrentRunLoop:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [RunLoopHelper addObserverOnMode:kCFRunLoopDefaultMode observerType:kCFRunLoopAllActivities];
        [runLoop run];
    }
}

#pragma mark - Perform Selector

- (void)test{

}


@end
