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
    
    [self.avatarimage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@""]];
    
    self.namelabel.text = model.name;
    
    self.lasttime.text = [self updateTimeForRow:model.lastChatTime];
    
}

/** 通过行数, 返回更新时间 */
- (NSString *)updateTimeForRow:(NSString *)str {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[str doubleValue] / 1000];
    
    NSTimeInterval createTime = [date timeIntervalSince1970];
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    // 秒转小时
    NSInteger hours = time/3600;
    if(time/36 <= 10){
        
        return @"刚刚";
    }else if (hours < 60){
    
        return [NSString stringWithFormat: @"%ld分钟前",(long)time/36];
        
    }else if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}




@end
