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

+ (NSArray *)getCurrentRunLoopAllModes;

+ (id)addObserverOnMode:(NSRunLoopMode)mode observerType:(NSUInteger)observerType;

+ (void)removeObserver:(id)observer onMode:(NSRunLoopMode)mode;

+ (void)performBlockOnMode:(NSRunLoopMode)mode block:(void(^)())block;

@end
