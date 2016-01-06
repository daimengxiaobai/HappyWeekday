//
//  MainTableViewCell.m
//  HappyWeekday
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MainTableViewCell ()
//活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
//活动名称
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
//活动价格
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
//距离
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceBtn;

@end

@implementation MainTableViewCell
//在model的set方法赋值
- (void)setModel:(MainModel *)model{
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:model.image_big] placeholderImage:nil];
    self.activityPriceLabel.text = model.price;
    self.activityNameLabel.text = model.title;
    if ([model.type integerValue] != RecommendTypeActivity) {
        self.activityPriceLabel.hidden = YES;
        self.activityDistanceBtn.hidden = YES;
    }else{
        self.activityDistanceBtn.hidden = NO;
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
