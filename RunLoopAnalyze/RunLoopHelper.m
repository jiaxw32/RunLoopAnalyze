//
//  RunLoopHelper.m
//  RunLoopAnalyze
//
//  Created by jiaxw-mac on 2017/10/19.
//  Copyright © 2017年 jiaxw32. All rights reserved.
//

#import "RunLoopHelper.h"


@implementation RunLoopHelper

+ (void)logCurrentRunLoop:(BOOL)verbose{
    NSString *currentModeName = [RunLoopHelper getCurrentRunLoopModeName];
    NSArray *allModesName = [RunLoopHelper getCurrentRunLoopAllModes];
    printf("\n===============begin RunLoop description===============\n");
    printf("current thread name:%s\n",[[NSThread currentThread].description UTF8String]);
    printf("current mode name:%s\n",[currentModeName UTF8String]);
    printf("all modes name:(\n");
    for (NSString *item in allModesName) {
        printf("\t%s,\n",[item UTF8String]);
    }
    printf(")\n");
    if (verbose) {
        printf("RunLoop description:\n");
        NSString *description = [[NSRunLoop currentRunLoop] debugDescription];
        //too many message,use NSLog cann't output all info
        printf("%s", [description UTF8String]);
    }
    printf("\n===============end RunLoop description===============\n");
}

+ (NSString *)getCurrentRunLoopModeName{
    return [NSRunLoop currentRunLoop].currentMode;
}

+ (NSString *)getRunLoopCurrentModeName:(CFRunLoopRef)runLoop{
    CFStringRef modeName = CFRunLoopCopyCurrentMode(runLoop);
    return CFBridgingRelease(modeName);
}

+ (NSArray *)getCurrentRunLoopAllModes{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    return [[self class] getRunLoopModes:runLoop];
}

+ (NSArray *)getRunLoopModes:(CFRunLoopRef)runLoop{
    CFArrayRef modes = CFRunLoopCopyAllModes(runLoop);
    //    return (__bridge NSArray *)modes;
    return CFBridgingRelease(modes);
}

+ (CFRunLoopObserverRef)addObserverOnMode:(NSRunLoopMode)mode observerType:(NSUInteger)observerType{
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, observerType, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        const char *mode =  [[NSRunLoop currentRunLoop].currentMode UTF8String];
        const char *threadName = [[NSThread currentThread].name UTF8String];
        
        switch (activity) {
            case kCFRunLoopEntry:
                printf("%s-%s:will enter runloop\n",threadName,mode);
                break;
            case kCFRunLoopBeforeTimers:
                printf("%s-%s:before handle timer\n",threadName,mode);
                break;
            case kCFRunLoopBeforeSources:
                printf("%s-%s:before handle source\n",threadName,mode);
                break;
            case kCFRunLoopBeforeWaiting:
                printf("%s-%s:will be sleeping\n",threadName,mode);
                break;
            case kCFRunLoopAfterWaiting:
                printf("%s-%s:waked from sleeping\n",threadName,mode);
                break;
            case kCFRunLoopExit:
                printf("%s-%s:exit runloop\n",threadName,mode);
                break;
            default:
                break;
        }
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, (__bridge CFRunLoopMode)mode);
    return observer;
}

+ (void)removeObserver:(CFRunLoopObserverRef)observer onMode:(NSRunLoopMode)mode{
    CFRunLoopRef rl = CFRunLoopGetCurrent();
    CFRunLoopRemoveObserver(rl, observer, (__bridge CFRunLoopMode)mode);
}

+ (void)performBlockOnMode:(NSRunLoopMode)mode block:(void (^)())block{
    CFRunLoopRef rl = CFRunLoopGetCurrent();
    CFRunLoopPerformBlock(rl, (__bridge CFRunLoopMode)mode, block);
}

@end
