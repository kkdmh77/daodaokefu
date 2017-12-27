//
//  XZselectclientTableViewCell.m
//  daodaokefu
//
//  Created by apple on 2017/12/25.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZselectclientTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface XZselectclientTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarimage;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *lasttime;


@end
@implementation XZselectclientTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarimage.layer.cornerRadius = 30;
    self.avatarimage.layer.masksToBounds = YES;
}

- (void)setModel:(XZClientModel *)model{
    
    _model = model;
    
    [self.avatarimage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"用户-3"]];
    
    self.namelabel.text = model.name;
    
    self.lasttime.text = [self updateTimeForRow:model.lastChatTime];
    
}

/** 通过行数, 返回更新时间 */
- (NSString *)updateTimeForRow:(NSString *)str {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSDate *currentDate = [NSDate date];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[str doubleValue] / 1000];
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}




@end
