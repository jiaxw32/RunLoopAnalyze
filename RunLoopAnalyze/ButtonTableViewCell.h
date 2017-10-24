//
//  ButtonTableViewCell.h
//  RunLoopAnalyze
//
//  Created by jiaxw-mac on 2017/10/20.
//  Copyright © 2017年 jiaxw32. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonTableViewCell : UITableViewCell

@property (nonatomic,copy) void(^onButtonClickHandler)(UIButton *sender);

@property (nonatomic,copy) NSString *text;

@end
