//
//  ButtonTableViewCell.m
//  RunLoopAnalyze
//
//  Created by jiaxw-mac on 2017/10/20.
//  Copyright © 2017年 jiaxw32. All rights reserved.
//

#import "ButtonTableViewCell.h"

@interface ButtonTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;

@end

@implementation ButtonTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.button.layer.cornerRadius = 4;
    self.button.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setText:(NSString *)text{
    _text = text;
    _cellTitleLabel.text = text;
}
- (IBAction)onButtonClick:(UIButton *)sender {
    if (_onButtonClickHandler) {
        _onButtonClickHandler(sender);
    }
}

@end
