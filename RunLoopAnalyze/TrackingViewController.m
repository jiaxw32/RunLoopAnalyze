//
//  TrackingViewController.m
//  RunLoopAnalyze
//
//  Created by jiaxw-mac on 2017/10/19.
//  Copyright © 2017年 jiaxw32. All rights reserved.
//

#import "TrackingViewController.h"
#import "RunLoopHelper.h"

@interface TrackingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CFRunLoopObserverRef _defaultObserver;
    CFRunLoopObserverRef _trackingObserver;
}

@property (nonatomic,strong) NSDate *lastDate;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation TrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionBack)];
    
    //if you have added observer in 'ViewController',please remove it before push 'TrackingViewController'
    _defaultObserver = [RunLoopHelper addObserverOnMode:NSDefaultRunLoopMode observerType:kCFRunLoopEntry|kCFRunLoopExit];
    _trackingObserver = [RunLoopHelper addObserverOnMode:UITrackingRunLoopMode observerType:kCFRunLoopEntry|kCFRunLoopExit];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
    [self.timer fire];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - aciton

- (void)actionBack{
    [self.timer invalidate];
    self.timer = nil;
    
    [RunLoopHelper removeObserver:_defaultObserver onMode:NSDefaultRunLoopMode];
    [RunLoopHelper removeObserver:_trackingObserver onMode:UITrackingRunLoopMode];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - handler

- (void)timerHandler:(id)sender{
    if (_lastDate) {
        NSDate *date = [NSDate new];
        NSTimeInterval timerInterval = [date timeIntervalSinceDate:_lastDate];
        _lastDate = date;
        printf("\ntimeInterval:%f,mode name:%s\n\n",timerInterval,[[NSRunLoop currentRunLoop].currentMode UTF8String]);
    } else {
        //first time fired
        _lastDate = [NSDate new];
        [RunLoopHelper logCurrentRunLoop:NO];
    }
}

#pragma mark - UITableView Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = [NSString stringWithFormat:@"cell-%lu",(long)indexPath.row];
    return cell;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    printf("\n===============begin %s===============\n",__PRETTY_FUNCTION__);
    printf("%s",[[NSRunLoop currentRunLoop].currentMode UTF8String]);
    printf("\n===============end %s===============\n",__PRETTY_FUNCTION__);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    printf("\n===============begin %s===============\n",__PRETTY_FUNCTION__);
    printf("%s",[[NSRunLoop currentRunLoop].currentMode UTF8String]);
    printf("\n===============end %s===============\n",__PRETTY_FUNCTION__);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    printf("\n===============begin %s===============\n",__PRETTY_FUNCTION__);
    printf("%s",[[NSRunLoop currentRunLoop].currentMode UTF8String]);
    printf("\n===============end %s===============\n",__PRETTY_FUNCTION__);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    printf("\n===============begin %s===============\n",__PRETTY_FUNCTION__);
    printf("%s",[[NSRunLoop currentRunLoop].currentMode UTF8String]);
    printf("\n===============end %s===============\n",__PRETTY_FUNCTION__);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    printf("\n===============begin %s===============\n",__PRETTY_FUNCTION__);
    printf("%s",[[NSRunLoop currentRunLoop].currentMode UTF8String]);
    printf("\n===============end %s===============\n",__PRETTY_FUNCTION__);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    printf("\n===============begin %s===============\n",__PRETTY_FUNCTION__);
    printf("%s",[[NSRunLoop currentRunLoop].currentMode UTF8String]);
    printf("\n===============end %s===============\n",__PRETTY_FUNCTION__);
}


@end
