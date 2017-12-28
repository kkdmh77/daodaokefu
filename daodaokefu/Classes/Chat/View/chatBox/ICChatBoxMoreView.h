//
//  ICChatBoxMoreView.h
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/11.
//  Copyright © 2016年 gxz All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICChatBoxMoreViewItem.h"

typedef NS_ENUM(NSInteger, ICChatBoxItem){
    ICChatBoxItemAlbum = 0,   // Album
    ICChatBoxItemCamera,      // Camera
    ICChatBoxItemoftenlanguage,//常用语
    ICChatBoxItemDoc,         // pdf
    ICChatBoxItemVideo       // Video
};

@class ICChatBoxMoreView;
@protocol ICChatBoxMoreViewDelegate <NSObject>
/**
 *  点击更多的类型
 *
 *  @param chatBoxMoreView ICChatBoxMoreView
 *  @param itemType        类型
 */
- (void)chatBoxMoreView:(ICChatBoxMoreView *)chatBoxMoreView didSelectItem:(ICChatBoxItem)itemType;

@end

@interface ICChatBoxMoreView : UIView

@property (nonatomic, weak) id<ICChatBoxMoreViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *items;


@end
