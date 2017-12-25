//
//  ICDocumentCell.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/22.
//  Copyright © 2016年 gxz All rights reserved.
//

#import "ICBaseMessageCell.h"

@protocol ICDocumentCellDelegate <NSObject>

- (void)selectBtnClicked:(id)sender;

@end

@interface ICDocumentCell : ICBaseMessageCell


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, weak) id<ICDocumentCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UIButton *selectBtn;



@end
