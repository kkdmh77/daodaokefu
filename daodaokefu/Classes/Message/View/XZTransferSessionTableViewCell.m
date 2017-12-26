//
//  XZTransferSessionTableViewCell.m
//  daodaokefu
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import "XZTransferSessionTableViewCell.h"
@interface XZTransferSessionTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end
@implementation XZTransferSessionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(XZTransferSessionModel *)model{
    
    _model = model;
    
    XZTransferSessionthreeModel *md = model.user;
    
    self.name.text = md.name;
}

- (void)setIsShow:(BOOL)isShow{
    _isShow = isShow;
    
    self.imageview.hidden = isShow;
}



@end
