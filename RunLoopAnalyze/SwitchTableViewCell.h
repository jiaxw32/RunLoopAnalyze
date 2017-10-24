//
//  SwitchTableViewCell.h
//  RunLoopAnalyze
//
//  Created by jiaxw-mac on 2017/10/20.
//  Copyright © 2017年 jiaxw32. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString *text;

@property (nonatomic,copy) void(^onSwitchValueChangedBlock)(BOOL isOn);

@end
