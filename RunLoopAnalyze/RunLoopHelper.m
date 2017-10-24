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

+ (CFRunLoopObserverRef)addObserverOnMode:(CFRunLoopMode)mode observerType:(CFOptionFlags)observerType{
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, observerType, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        NSString *mode = CFBridgingRelease(CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent()));
//        NSRunLoopMode mode =  [NSRunLoop currentRunLoop].currentMode;
        
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"%@-%@:will enter runloop",[NSThread currentThread].name,mode);
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"%@-%@:before handle timer",[NSThread currentThread].name,mode);
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"%@-%@:before handle source",[NSThread currentThread].name,mode);
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"%@-%@:will be sleeping",[NSThread currentThread].name,mode);
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"%@-%@:waked from sleeping",[NSThread currentThread].name,mode);
                break;
            case kCFRunLoopExit:
                NSLog(@"%@-%@:exit runloop",[NSThread currentThread].name,mode);
                break;
            default:
                break;
        }
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, mode);
    return observer;
}

+ (void)removeObserver:(CFRunLoopObserverRef)observer onMode:(CFRunLoopMode)mode{
    CFRunLoopRef rl = CFRunLoopGetCurrent();
    CFRunLoopRemoveObserver(rl, observer, mode);
}

+ (void)performBlockInRunLoop:(CFRunLoopRef)rl mode:(CFRunLoopMode)mode block:(void(^)())block{
    CFRunLoopPerformBlock(rl, mode, block);
}


@end
