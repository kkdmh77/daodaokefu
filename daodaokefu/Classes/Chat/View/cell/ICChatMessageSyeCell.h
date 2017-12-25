//
//  ICChatMessageSyeCell.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/29.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICMessageFrame;

@interface ICChatMessageSyeCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

@property (nonatomic, strong) ICMessageFrame *messageF;

@end
