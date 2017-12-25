//
//  ICChatSystemCell.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/7.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICChatSystemCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

@property (nonatomic, strong) ICMessageFrame *messageF;

@end
