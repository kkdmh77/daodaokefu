//
//  ICChatMessageImageCell.m
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/13.
//  Copyright © 2016年 gxz All rights reserved.
//

#import "ICChatMessageImageCell.h"
#import "ICMediaManager.h"
#import "ICMessageModel.h"
#import "ICMessage.h"
#import "ICFileTool.h"
#import "ICMessageHelper.h"
#import "UIImageView+WebCache.h"

@interface ICChatMessageImageCell ()

@property (nonatomic, strong) UIButton *imageBtn;

@end

@implementation ICChatMessageImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.imageBtn];
    }
    return self;
}



#pragma mark - Private Method

- (void)setModelFrame:(ICMessageFrame *)modelFrame
{
    [super setModelFrame:modelFrame];


    ICMediaManager *manager = [ICMediaManager sharedManager];
    UIImage *image = [manager imageWithLocalPath:[manager imagePathWithName:modelFrame.model.mediaPath.lastPathComponent]];
    self.imageBtn.frame = modelFrame.picViewF;
    self.bubbleView.userInteractionEnabled = _imageBtn.imageView.image != nil;
    self.bubbleView.image = nil;
    if (modelFrame.model.isSender) {    // 发送者
        UIImage *arrowImage = [manager arrowMeImage:image size:modelFrame.picViewF.size mediaPath:modelFrame.model.mediaPath isSender:modelFrame.model.isSender];
//        [self.imageBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
        [self.imageBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
    } else {
        NSString *orgImgPath = [manager originImgPath:modelFrame];
        if ([ICFileTool fileExistsAtPath:orgImgPath]) {
            UIImage *orgImg = [manager imageWithLocalPath:orgImgPath];
            UIImage *arrowImage = [manager arrowMeImage:orgImg size:modelFrame.picViewF.size mediaPath:orgImgPath isSender:modelFrame.model.isSender];
            [self.imageBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
        } else {
            UIImage *arrowImage = [manager arrowMeImage:image size:modelFrame.picViewF.size mediaPath:modelFrame.model.mediaPath isSender:modelFrame.model.isSender];
//            CGFloat x = modelFrame.picViewF.origin.x;
//            CGFloat y = modelFrame.picViewF.origin.y;
//            CGFloat width = modelFrame.iamgesize.width;
//            CGFloat height = modelFrame.iamgesize.height;
//            self.imageBtn.frame = CGRectMake(x, y, width, height);
            [self.imageBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
        }
        
    }
}

- (void)imageBtnClick:(UIButton *)btn
{
    if (btn.currentBackgroundImage == nil) {
        return;
    }
    CGRect smallRect = [ICMessageHelper photoFramInWindow:btn];
    CGRect bigRect   = [ICMessageHelper photoLargerInWindow:btn];
    NSValue *smallValue = [NSValue valueWithCGRect:smallRect];
    NSValue *bigValue   = [NSValue valueWithCGRect:bigRect];
    [self routerEventWithName:GXRouterEventImageTapEventName
                     userInfo:@{MessageKey   : self.modelFrame,
                                @"smallRect" : smallValue,
                                @"bigRect"   : bigValue
                                }];
}



#pragma mark - Getter

- (UIButton *)imageBtn
{
    if (nil == _imageBtn) {
        _imageBtn = [[UIButton alloc] init];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imageBtn.layer.masksToBounds = YES;
        _imageBtn.layer.cornerRadius = 5;
        _imageBtn.clipsToBounds = YES;
    }
    return _imageBtn;
}





@end
