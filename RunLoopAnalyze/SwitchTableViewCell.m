//
//  SwitchTableViewCell.m
//  RunLoopAnalyze
//
//  Created by jiaxw-mac on 2017/10/20.
//  Copyright © 2017年 jiaxw32. All rights reserved.
//

#import "SwitchTableViewCell.h"

@interface SwitchTableViewCell ()
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation SwitchTableViewCell
- (IBAction)onSwitchValueChanged:(UISwitch *)sender {
    if (_onSwitchValueChangedBlock) {
        _onSwitchValueChangedBlock(sender.isOn);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setText:(NSString *)text{
    _text = text;
    _lblTitle.text = _text;
}

@end
