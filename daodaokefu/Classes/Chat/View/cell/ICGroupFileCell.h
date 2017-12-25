//
//  ICGroupFileCell.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/16.
//  Copyright © 2016年 gxz All rights reserved.
//

#import "ICBaseMessageCell.h"

@class ICGroupFileCell;

@protocol GroupFileDelegate <NSObject>

- (void)isFileExisted:(ICGroupFileCell *)cell
            isExisted:(BOOL)isExisted
              fileKey:(NSString *)fileKey
             fileName:(NSString *)fileName;

@end

@interface ICGroupFileCell : ICBaseMessageCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) ICMessage *message;

@property (nonatomic, weak) id <GroupFileDelegate>delegate;

@property (nonatomic, weak) UIProgressView *progressView;
@property (nonatomic, weak) UIButton *seeBtn;


@end
