//
//  ICTitleView.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/12.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICSearchBar;

@protocol ICTitleViewDelegate <NSObject>

- (void)cancelBtnClicked;

- (void)searchText:(NSString *)text;

@end

@interface ICTitleView : UIView

@property (nonatomic, weak) id<ICTitleViewDelegate>delegate;

@end
