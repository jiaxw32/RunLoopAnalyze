//
//  RunLoopHelper.h
//  RunLoopAnalyze
//
//  Created by jiaxw-mac on 2017/10/19.
//  Copyright © 2017年 jiaxw32. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RunLoopHelper : NSObject

+ (void)logCurrentRunLoop:(BOOL)verbose;

+ (NSString *)getCurrentRunLoopModeName;

+ (NSString *)getRunLoopCurrentModeName:(CFRunLoopRef)runLoop;

+ (NSArray *)getCurrentRunLoopAllModes;

+ (NSArray *)getRunLoopModes:(CFRunLoopRef)runLoop;

+ (CFRunLoopObserverRef)addObserverOnMode:(CFRunLoopMode)mode observerType:(CFOptionFlags)observerType;

+ (void)removeObserver:(CFRunLoopObserverRef)observer onMode:(CFRunLoopMode)mode;

+ (void)performBlockInRunLoop:(CFRunLoopRef)rl mode:(CFRunLoopMode)mode block:(void(^)())block;

@end
