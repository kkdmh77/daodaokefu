//
//  XZChatViewController.m
//  daodoakefu
//
//  Created by 杨梓垚 on 17/12/20.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import "XZChatViewController.h"
#import "ICChatHearder.h"
#import "XZUserinfoTableViewController.h"
#import "UIImageView+WebCache.h"
#import "XZOneModel.h"
#import "XZAcceptMessageModel.h"
#import "AppDelegate.h"
#import "XZCloseSessioTableViewController.h"
#import "XZTransferSessionTableViewController.h"

typedef enum : NSUInteger {
    TextMessage,
    ImageMessage,
    VideoMessage,
    Mp4Message,
} MessageType;

@interface XZChatViewController ()<ICChatBoxViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,ICRecordManagerDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,BaseCellDelegate>
{
    CGRect _smallRect;
    CGRect _bigRect;
    
    UIMenuItem * _copyMenuItem;
    UIMenuItem * _deleteMenuItem;
    UIMenuItem * _forwardMenuItem;
    UIMenuItem * _recallMenuItem;
    NSIndexPath *_longIndexPath;
    
    BOOL   _isKeyBoardAppear;     // 键盘是否弹出来了
}

@property (nonatomic, strong) ICChatBoxViewController *chatBoxVC;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *textView;
/** 数据源 */
@property (nonatomic, copy) NSMutableArray *dataSource;
/** voice path */
@property (nonatomic, copy) NSString *voicePath;

@property (nonatomic, strong) UIImageView *currentVoiceIcon;
@property (nonatomic, strong) UIImageView *presentImageView;
@property (nonatomic, assign)  BOOL presentFlag;  // 是否model出控制器
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *loadtimer;
@property (nonatomic, strong) ICVoiceHud *voiceHud;


@end

@implementation XZChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.group.gName;
    
    [self addNotification];
    
    [self setupUI];
    
    [self registerCell];
    
    if(!_isCreate){
      [self loadDataSources];
    }
    
 
}


- (void)setupUI
{
    self.view.backgroundColor = IColor(240, 237, 237);
     self.tableView.backgroundColor = IColor(240, 237, 237);
    
    [self addChildViewController:self.chatBoxVC];
    [self.view addSubview:self.chatBoxVC.view];
    [self.view addSubview:self.tableView];
    // self.view的高度有时候是不准确的
    // 注意添加顺序
    if(_isHistory){
        
      self.tableView.frame = CGRectMake(0, HEIGHT_NAVBAR+HEIGHT_STATUSBAR, self.view.width, self.view.height - 70);
        self.chatBoxVC.chatBox.hidden = YES;
        
    }else{
        self.tableView.frame = CGRectMake(0, HEIGHT_NAVBAR+HEIGHT_STATUSBAR, self.view.width, APP_Frame_Height-HEIGHT_TABBAR-HEIGHT_NAVBAR-HEIGHT_STATUSBAR);
        self.chatBoxVC.chatBox.hidden = NO;
        [self setupNavUI];
        
        if(!_isCreate){
             self.loadtimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(loadDataSource) userInfo:nil repeats:YES];
        }
    }
   
   
   
    
}

- (void)setupNavUI{
    
    UIBarButtonItem *rigthButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多"] style:UIBarButtonItemStylePlain target:self action:@selector(NavrigthButtonAction)];
    
    self.navigationController.navigationItem.rightBarButtonItem = rigthButtonItem;[self.navigationItem setRightBarButtonItem:rigthButtonItem];
}

- (void)NavrigthButtonAction{
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotoes = [UIAlertAction actionWithTitle:@"客户资料" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 1.获取当前的StoryBoard面板
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        
        // 2.通过标识符找到对应的页面
        XZUserinfoTableViewController *userinfoVc = [storyBoard instantiateViewControllerWithIdentifier:@"XZUserinfoTableViewController"];
        
        
        [self.navigationController pushViewController:userinfoVc animated:YES];
    }];
    
    UIAlertAction *changeAction = [UIAlertAction actionWithTitle:@"转接会话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        XZTransferSessionTableViewController *vc = [XZTransferSessionTableViewController new];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    UIAlertAction *photoesAlbum = [UIAlertAction actionWithTitle:@"关闭会话" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        
        XZCloseSessioTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"XZCloseSessioTableViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [actionSheet addAction:takePhotoes];
    [actionSheet addAction:changeAction];
    [actionSheet addAction:photoesAlbum];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    
}

- (void)addNotification {
    
    
    __weak typeof(self) weakself = self;
    [kNotificationCenter addObserverForName:@"clickavatarImageView" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
       
        // 1.获取当前的StoryBoard面板
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        
        // 2.通过标识符找到对应的页面
        XZUserinfoTableViewController *userinfoVc = [storyBoard instantiateViewControllerWithIdentifier:@"XZUserinfoTableViewController"];
        
        
        [weakself.navigationController pushViewController:userinfoVc animated:YES];
        
    }];
}


- (void)registerCell
{
    [self.tableView registerClass:[ICChatMessageTextCell class] forCellReuseIdentifier:TypeText];
    [self.tableView registerClass:[ICChatMessageImageCell class] forCellReuseIdentifier:TypePic];
    [self.tableView registerClass:[ICChatMessageVideoCell class] forCellReuseIdentifier:TypeVideo];
    [self.tableView registerClass:[ICChatMessageVoiceCell class] forCellReuseIdentifier:TypeVoice];
    [self.tableView registerClass:[ICChatMessageFileCell class] forCellReuseIdentifier:TypeFile];
}

#pragma mark -  点击头像触发的代理方法
- (void)headImageClicked:(NSString *)eId{
    
    // 1.获取当前的StoryBoard面板
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    
    // 2.通过标识符找到对应的页面
    XZUserinfoTableViewController *userinfoVc = [storyBoard instantiateViewControllerWithIdentifier:@"XZUserinfoTableViewController"];
    
    
    [self.navigationController pushViewController:userinfoVc animated:YES];
}

- (void)loadDataSources{
    
    __weak typeof(self) weakself = self;
    
    if(_isHistory){
        
        [[XZNetWorkingManager sharderinstance] SessionChatLogandsessionId:_group.sessionId andSucceed:^(NSArray *model){
            
            
            for (XZAcceptMessageModel *md in model) {
                
                
                if(md.chatType == 0){ // 文字消息
                    
                    if(md.isReply){
                        
                        [weakself sendTextMessage:md.content andisSender:YES isAnimation:NO];
                    }else{
                        
                        [weakself sendTextMessage:md.content andisSender:NO isAnimation:NO];
                    }
                    
                }else if(md.chatType == 1){ // 图片消息
                    
                    if(md.isReply){
                        
                        [weakself sendImageMessage:md.content andisSender:YES isAnimation:YES];
                    }else{
                        
                        [weakself sendImageMessage:md.content andisSender:NO isAnimation:NO];
                    }
                    
                }else{  //语音消息
                    
                    NSDictionary *dict = [self dictionaryWithJsonString:md.content];
                    
                    [weakself sendVoiceMessage:dict[@"mediaId"] isAnimation:NO];
                }
                
                
            }
            
        } andError:^(NSString *err) {
            
        }];
    }else{
        
        
        [[XZNetWorkingManager sharderinstance] Chatmsganddelta:NO Succeed:^(XZOneModel *model){
            
            NSArray<XZAcceptMessageModel *> *modelArray = model.chatLog;
            for (XZAcceptMessageModel *md in modelArray) {
                
                
                if(md.chatType == 0){ // 文字消息
                    
                    if(md.isReply){
                        
                        [weakself sendTextMessage:md.content andisSender:YES isAnimation:NO];
                    }else{
                        
                        [weakself sendTextMessage:md.content andisSender:NO isAnimation:NO];
                    }
                    
                }else if(md.chatType == 1){ // 图片消息
                    
                    if(md.isReply){
                        
                        [weakself sendImageMessage:md.content andisSender:YES isAnimation:NO];
                    }else{
                        
                        [weakself sendImageMessage:md.content andisSender:NO isAnimation:NO];
                    }
                    
                }else{  //语音消息
                    
                    NSDictionary *dict = [self dictionaryWithJsonString:md.content];
                    
                    [weakself sendVoiceMessage:dict[@"mediaId"] isAnimation:NO];
                }
                
                
            }
            
        } andError:^(NSString *err) {
            
        }];
        
    }
    
 
}

// 加载数据
- (void)loadDataSource
{
//    [weadSelf.dataSource addObjectsFromArray:array];
//    [weadSelf scrollToBottom];
    
    __weak typeof(self) weakself = self;
    [[XZNetWorkingManager sharderinstance] Chatmsganddelta:YES Succeed:^(XZOneModel *model){
        
        NSArray<XZAcceptMessageModel *> *modelArray = model.chatLog;
        for (XZAcceptMessageModel *md in modelArray) {
            if(md.chatType == 0 && !md.isReply){ // 文字消息
                
             [weakself sendTextMessage:md.content andisSender:NO isAnimation:YES];
            }else if(md.chatType == 1 && !md.isReply){ // 图片消息
                
                [weakself sendImageMessage:md.content andisSender:NO isAnimation:YES];
            }else if(md.chatType == 2 && !md.isReply){ //语音消息
                
                NSDictionary *dict = [self dictionaryWithJsonString:md.content];
                
                [weakself sendVoiceMessage:dict[@"mediaId"] isAnimation:YES];
            }
            
        }
        
    } andError:^(NSString *err) {
        
    }];
}

// 发送一条服务端的文字消息
- (void)sendTextMessage:(NSString *)String andisSender:(BOOL)isSender isAnimation:(BOOL)isAnimation{
    
    ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypeText content:String path:nil from:@"gxz" to:self.group.gId fileKey:nil isSender:isSender receivedSenderByYourself:NO];
    messageF.model.message.deliveryState = isSender ? ICMessageDeliveryState_Delivered : ICMessageDeliveryState_Delivering;
    
    [self addObject:messageF isSender:YES isAnimation:isAnimation];
}
// 发送一条图片消息
- (void)sendImageMessage:(NSString *)iamgeUrl andisSender:(BOOL)isSender isAnimation:(BOOL)isAnimation{
    
    
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *imageFilePath = @"";
    
    
    

    if ([iamgeUrl containsString:@"http"]) {
       
        imageFilePath =[path stringByAppendingPathComponent:[NSString stringWithFormat:@"Chat/MyPic/myImage-%@.png",[iamgeUrl substringWithRange:NSMakeRange(32, 38)]]];//截取范围类的字符串]];

    }else{
        
        iamgeUrl = [NSString stringWithFormat:@"%@%@",APIBaseUrl,iamgeUrl];
        
        imageFilePath =[path stringByAppendingPathComponent:[NSString stringWithFormat:@"Chat/MyPic/myImage-%@.png",[iamgeUrl substringWithRange:NSMakeRange(46, 31)]]];//截取范围类的字符串]];
    }
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *pathstr = [NSString stringWithFormat:@"%@/Chat/MyPic",cachePath];
    
    if(![self isFileExist: pathstr]){
        
        [[NSFileManager defaultManager] createDirectoryAtPath:pathstr withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    if([self isFileExist:imageFilePath]){
        
        ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypePic content:@"[图片]" path:imageFilePath from:@"gxz" to:self.group.gId fileKey:nil isSender:isSender receivedSenderByYourself:NO];
        // 设置成发送成功
        messageF.model.message.deliveryState = ICMessageDeliveryState_Delivered;
        
        
        UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
        CGFloat fixelW = CGImageGetWidth(image.CGImage);
        
        CGFloat fixelH = CGImageGetHeight(image.CGImage);
        if(fixelW == fixelH){
            
            messageF.iamgesize = CGSizeMake(SCREEN_WIDTH *0.38 ,SCREEN_WIDTH *0.38);
            messageF.cellHight = SCREEN_WIDTH *0.38 + 20;
        }else{
            messageF.iamgesize = CGSizeMake(fixelW / 7, fixelH / 7);
            messageF.cellHight = fixelH / 7 + 40;
        }
        
        [self addObject:messageF isSender:YES isAnimation:isAnimation];
    }else{

        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iamgeUrl]];
        
        UIImage *image = [UIImage imageWithData:data]; // 取得图片
//        if(fixelW == fixelH){
//
//            messageF.iamgesize = CGSizeMake(SCREEN_WIDTH *0.38 ,SCREEN_WIDTH *0.38);
//            messageF.cellHight = SCREEN_WIDTH *0.38 + 20;
//        }else{
//            messageF.iamgesize = CGSizeMake(fixelW / 7, fixelH / 7);
//            messageF.cellHight = fixelH / 7 + 20;
//        }
        
        // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
        BOOL success = [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath  atomically:YES];
        if (success){
            NSLog(@"写入本地成功");
            
            ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypePic content:@"[图片]" path:imageFilePath from:@"gxz" to:self.group.gId fileKey:nil isSender:isSender receivedSenderByYourself:NO];
            // 设置成发送成功
            messageF.model.message.deliveryState = ICMessageDeliveryState_Delivered;
            
            messageF.model.mediaPath = imageFilePath;
            
            [self addObject:messageF isSender:YES isAnimation:isAnimation];
        }else{
            NSLog(@"写入本地失败");
            
        }
        
    }
    

}

#pragma mark - Tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj                            = self.dataSource[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return nil;
    } else {
        ICMessageFrame *modelFrame     = (ICMessageFrame *)obj;
        NSString *ID                   = modelFrame.model.message.type;
        if ([ID isEqualToString:TypeSystem]) {
            ICChatSystemCell *cell = [ICChatSystemCell cellWithTableView:tableView reusableId:ID];
            cell.messageF              = modelFrame;
            return cell;
        }
        ICChatMessageBaseCell *cell    = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.longPressDelegate         = self;
        [[ICMediaManager sharedManager] clearReuseImageMessage:cell.modelFrame.model];
        modelFrame.model.Senderimageurl=self.group.imageurl;
        cell.modelFrame                = modelFrame;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICMessageFrame *messageF = [self.dataSource objectAtIndex:indexPath.row];
    return messageF.cellHight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.chatBoxVC resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.chatBoxVC resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([cell isKindOfClass:[ICChatMessageVideoCell class]] && self) {
        ICChatMessageVideoCell *videoCell = (ICChatMessageVideoCell *)cell;
        [videoCell stopVideo];
    }
}

#pragma mark - ICChatBoxViewControllerDelegate

- (void) chatBoxViewController:(ICChatBoxViewController *)chatboxViewController
        didChangeChatBoxHeight:(CGFloat)height
{
    self.chatBoxVC.view.top = self.view.bottom-height;
    self.tableView.height = HEIGHT_SCREEN - height - HEIGHT_NAVBAR-HEIGHT_STATUSBAR;
    if (height == HEIGHT_TABBAR) {
        [self.tableView reloadData];
        _isKeyBoardAppear  = NO;
    } else {
        [self scrollToBottomisAnimation:YES];
        _isKeyBoardAppear  = YES;
    }
    if (self.textView == nil) {
        self.textView = chatboxViewController.chatBox.textView;
    }
}

- (void)chatBoxViewController:(ICChatBoxViewController *)chatboxViewController didVideoViewAppeared:(ICVideoView *)videoView
{
    [_chatBoxVC.view setFrame:CGRectMake(0, HEIGHT_SCREEN-HEIGHT_TABBAR, App_Frame_Width, APP_Frame_Height)];
    videoView.hidden = NO;
    __weak typeof(self) weakself = self;
    
    [UIView animateWithDuration:0.25 animations:^{
        weakself.tableView.height = HEIGHT_SCREEN - videwViewH - HEIGHT_NAVBAR-HEIGHT_STATUSBAR;
        weakself.chatBoxVC.view.frame = CGRectMake(0, videwViewX+HEIGHT_NAVBAR+HEIGHT_STATUSBAR, App_Frame_Width, videwViewH);
        [weakself scrollToBottomisAnimation:YES];
    } completion:^(BOOL finished) { // 状态改变
        weakself.chatBoxVC.chatBox.status = ICChatBoxStatusShowVideo;
        // 在这里创建视频设配
        UIView *videoLayerView = [videoView viewWithTag:1000];
        UIView *placeholderView = [videoView viewWithTag:1001];
        [[ICVideoManager shareManager] setVideoPreviewLayer:videoLayerView];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(videoPreviewLayerWillAppear:) userInfo:placeholderView repeats:NO];
        
    }];
}

- (void)chatBoxViewController:(ICChatBoxViewController *)chatboxViewController sendVideoMessage:(NSString *)videoPath
{
    ICMessageFrame *messageFrame = [ICMessageHelper createMessageFrame:TypeVideo content:@"[视频]" path:videoPath from:@"gxz" to:self.group.gId fileKey:nil isSender:YES receivedSenderByYourself:NO]; // 创建本地消息
    [self addObject:messageFrame isSender:YES isAnimation:YES];
    [self messageSendSucced:messageFrame andType:TextMessage];
}

- (void) chatBoxViewController:(ICChatBoxViewController *)chatboxViewController sendFileMessage:(NSString *)fileName
{
    NSString *lastName = [fileName originName];
    NSString*fileKey   = [fileName firstStringSeparatedByString:@"_"];
    NSString *content = [NSString stringWithFormat:@"[文件]%@",lastName];
    ICMessageFrame *messageFrame = [ICMessageHelper createMessageFrame:TypeFile content:content path:fileName from:@"gxz" to:self.group.gId fileKey:nil isSender:YES receivedSenderByYourself:NO];
    NSString *path = [[ICFileTool fileMainPath] stringByAppendingPathComponent:fileName];
    double s = [ICFileTool fileSizeWithPath:path];
    NSNumber *x = [ICMessageHelper fileType:[fileName pathExtension]];
    if (!x) {
        x = @0;
    }
    NSDictionary *lnk = @{@"s":@((long)s),@"x":x,@"n":lastName};
    messageFrame.model.message.lnk = [lnk jsonString];
    messageFrame.model.message.fileKey = fileKey;
    [self addObject:messageFrame isSender:YES isAnimation:YES];
    [self messageSendSucced:messageFrame andType:TextMessage];
}

// send text message
- (void) chatBoxViewController:(ICChatBoxViewController *)chatboxViewController
               sendTextMessage:(NSString *)messageStr
{
    if (messageStr && messageStr.length > 0) {
        [self sendTextMessageWithContent:messageStr];
//        [self otherSendTextMessageWithContent:messageStr];
    }
}

- (void)sendTextMessageWithContent:(NSString *)messageStr
{
    ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypeText content:messageStr path:nil from:@"gxz" to:self.group.gId fileKey:nil isSender:YES receivedSenderByYourself:NO];
    [self addObject:messageF isSender:YES isAnimation:YES];
    
    [self messageSendSucced:messageF andType:TextMessage];
}

- (void)otherSendTextMessageWithContent:(NSString *)messageStr
{
    ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypeText content:messageStr path:nil from:@"gxz" to:self.group.gId fileKey:nil isSender:NO receivedSenderByYourself:NO];
    [self addObject:messageF isSender:YES isAnimation:YES];
    
    [self messageSendSucced:messageF andType:TextMessage];
}

// 增加数据源并刷新
- (void)addObject:(ICMessageFrame *)messageF
         isSender:(BOOL)isSender isAnimation:(BOOL)isAnimation
{
    
    [self.dataSource addObject:messageF];
    [self.tableView reloadData];
    if (isSender || _isKeyBoardAppear) {
        [self scrollToBottomisAnimation:isAnimation];
    }
}

- (void)messageSendSucced:(ICMessageFrame *)messageF andType:(MessageType)messagetype
{
    
    if(_isCreate){
        
        [[XZNetWorkingManager sharderinstance] ceateSessionanduid:_group.sessionId andSucceed:^{
            _isCreate = NO;
            [self sendMessage:messageF andType:messagetype];
        } andError:^(NSString *err) {
            
        }];
    }else{
        [self sendMessage:messageF andType:messagetype];

    }
    
}

- (void)sendMessage:(ICMessageFrame *)messageF andType:(MessageType)messagetype{
    
    // 判断类型上传
    if(!messageF.model.isSender)return;
    
    __weak typeof(self) weakself = self;
    
    if(messagetype == TextMessage){
        
        [[XZNetWorkingManager sharderinstance] sendMessage:messageF.model.message.content andSucceed:^{
            messageF.model.message.deliveryState = ICMessageDeliveryState_Delivered;
            [weakself.tableView reloadData];
        } andError:^(NSString *err) {
            messageF.model.message.deliveryState = ICMessageDeliveryState_Failure;
            [weakself.tableView reloadData];
        }];
        
    }else if(messagetype == ImageMessage){
        
        [[XZNetWorkingManager sharderinstance] SendPictureMessage:messageF.model.mediaPath andSucceed:^{
            messageF.model.message.deliveryState = ICMessageDeliveryState_Delivered;
            [weakself.tableView reloadData];
        } andError:^(NSString *err) {
            messageF.model.message.deliveryState = ICMessageDeliveryState_Failure;
            [weakself.tableView reloadData];
        }];
    }
}


// send image message
- (void) chatBoxViewController:(ICChatBoxViewController *)chatboxViewController
              sendImageMessage:(UIImage *)image
                     imagePath:(NSString *)imgPath
{
    if (image && imgPath) {
        [self sendImageMessageWithImgPath:imgPath];
    }
}

// 接受服务器的图片
- (void)sendImageMessageWithImgPath1:(NSString *)imgPath
{
    ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypePic content:@"[图片]" path:imgPath from:@"gxz" to:self.group.gId fileKey:nil isSender:NO receivedSenderByYourself:NO];
    [self addObject:messageF isSender:YES isAnimation:YES];
    
    [self messageSendSucced:messageF andType:ImageMessage];
    
}

// 发送图片
- (void)sendImageMessageWithImgPath:(NSString *)imgPath
{
    ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypePic content:@"[图片]" path:imgPath from:@"gxz" to:self.group.gId fileKey:nil isSender:YES receivedSenderByYourself:NO];
    [self addObject:messageF isSender:YES isAnimation:YES];
    
    [self messageSendSucced:messageF andType:ImageMessage];
    
}

-(BOOL) isFileExist:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:fileName];
    NSLog(@"这个文件已经存在：%@",result?[NSString stringWithFormat:@"是的%@",fileName]:@"不存在");
    return result;
}

// 发送一条语音消息
- (void)sendVoiceMessage:(NSString *)voiceUrl isAnimation:(BOOL)isAnimation{
    
    AppDelegate *sd = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *path = [NSString stringWithFormat:@"%@/Chat/Recoder/%@.amr",kPathCache,voiceUrl];
    
    if([self isFileExist:path]){
        
        [self timerInvalue]; // 销毁定时器
        self.voiceHud.hidden = YES;
        if (voiceUrl) {
            ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypeVoice content:@"[语音]" path:path from:@"gxz" to:self.group.gId fileKey:nil isSender:NO receivedSenderByYourself:NO];
            
            
            [self addObject:messageF isSender:YES isAnimation:isAnimation];
        }
        
    }else{
    
    NSURL *url = [NSURL fileURLWithPath:path];

    
    [[XZNetWorkingManager sharderinstance] downloadVoicemediaId:voiceUrl andcompanyId:sd.uesrmodel.companyId andFilePath:url andSucceed:^{
        
        [self timerInvalue]; // 销毁定时器
        self.voiceHud.hidden = YES;
        if (voiceUrl) {
            ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypeVoice content:@"[语音]" path:path from:@"gxz" to:self.group.gId fileKey:nil isSender:NO receivedSenderByYourself:NO];
            
            
            [self addObject:messageF isSender:YES isAnimation:isAnimation];
        }
        
        
    } andError:^(NSString *err) {
        
    }];
    
    }
   
}

// send voice message
- (void) chatBoxViewController:(ICChatBoxViewController *)chatboxViewController sendVoiceMessage:(NSString *)voicePath
{
    [self timerInvalue]; // 销毁定时器
    self.voiceHud.hidden = YES;
    if (voicePath) {
        ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:TypeVoice content:@"[语音]" path:voicePath from:@"gxz" to:self.group.gId fileKey:nil isSender:YES receivedSenderByYourself:NO];
        messageF.model.message.deliveryState =ICMessageDeliveryState_Failure;
        [self addObject:messageF isSender:YES isAnimation:YES];
        [self messageSendSucced:messageF andType:Mp4Message];
    }
}


#pragma mark - baseCell delegate

- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer
{
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location       = [longRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        _longIndexPath         = indexPath;
        id object              = [self.dataSource objectAtIndex:indexPath.row];
        if (![object isKindOfClass:[ICMessageFrame class]]) return;
        ICChatMessageBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath message:cell.modelFrame.model];
    }
}

#pragma mark - public method

// 路由响应
- (void)routerEventWithName:(NSString *)eventName
                   userInfo:(NSDictionary *)userInfo
{
    ICMessageFrame *modelFrame = [userInfo objectForKey:MessageKey];
    if ([eventName isEqualToString:GXRouterEventTextUrlTapEventName]) {
    } else if ([eventName isEqualToString:GXRouterEventImageTapEventName]) {
        _smallRect             = [[userInfo objectForKey:@"smallRect"] CGRectValue];
        _bigRect               =  [[userInfo objectForKey:@"bigRect"] CGRectValue];
        NSString *imgPath      = modelFrame.model.mediaPath;
        NSString *orgImgPath = [[ICMediaManager sharedManager] originImgPath:modelFrame];
        if ([ICFileTool fileExistsAtPath:orgImgPath]) {
            modelFrame.model.mediaPath = orgImgPath;
            imgPath                    = orgImgPath;
        }
        [self showLargeImageWithPath:imgPath withMessageF:modelFrame];
    } else if ([eventName isEqualToString:GXRouterEventVoiceTapEventName]) {
        
        UIImageView *imageView = (UIImageView *)userInfo[VoiceIcon];
        UIView *redView        = (UIView *)userInfo[RedView];
        [self chatVoiceTaped:modelFrame voiceIcon:imageView redView:redView];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - voice & video

- (void)voiceDidCancelRecording
{
    [self timerInvalue];
    self.voiceHud.hidden = YES;
}
- (void)voiceDidStartRecording
{
    [self timerInvalue];
    self.voiceHud.hidden = NO;
    [self timer];
}

// 向外或向里移动
- (void)voiceWillDragout:(BOOL)inside
{
    if (inside) {
        [_timer setFireDate:[NSDate distantPast]];
        _voiceHud.image  = [UIImage imageNamed:@"voice_1"];
    } else {
        [_timer setFireDate:[NSDate distantFuture]];
        self.voiceHud.animationImages  = nil;
        self.voiceHud.image = [UIImage imageNamed:@"cancelVoice"];
    }
}
- (void)progressChange
{
    AVAudioRecorder *recorder = [[ICRecordManager shareManager] recorder] ;
    [recorder updateMeters];
    float power= [recorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0,声音越大power绝对值越小
    CGFloat progress = (1.0/160)*(power + 160);
    self.voiceHud.progress = progress;
}

- (void)voiceRecordSoShort
{
    [self timerInvalue];
    self.voiceHud.animationImages = nil;
    self.voiceHud.image = [UIImage imageNamed:@"voiceShort"];
    
    // 此处发送消息给服务端
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.voiceHud.hidden = YES;
//    });
}

// play voice
- (void)chatVoiceTaped:(ICMessageFrame *)messageFrame
             voiceIcon:(UIImageView *)voiceIcon
               redView:(UIView *)redView
{
    ICRecordManager *recordManager = [ICRecordManager shareManager];
    recordManager.playDelegate = self;
    // 文件路径
    NSString *voicePath = [self mediaPath:messageFrame.model.mediaPath];
    NSString *amrPath   = [[voicePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"amr"];
    [VoiceConverter ConvertAmrToWav:amrPath wavSavePath:voicePath];
    if (messageFrame.model.message.status == 0){
        messageFrame.model.message.status = 1;
        redView.hidden = YES;
    }
    if (self.voicePath) {
        if ([self.voicePath isEqualToString:voicePath]) { // the same recoder
            self.voicePath = nil;
            [[ICRecordManager shareManager] stopPlayRecorder:voicePath];
            [voiceIcon stopAnimating];
            self.currentVoiceIcon = nil;
            return;
        } else {
            [self.currentVoiceIcon stopAnimating];
            self.currentVoiceIcon = nil;
        }
    }
    [[ICRecordManager shareManager] startPlayRecorder:voicePath];
    [voiceIcon startAnimating];
    self.voicePath = voicePath;
    self.currentVoiceIcon = voiceIcon;
}

// 移除录视频时的占位图片
- (void)videoPreviewLayerWillAppear:(NSTimer *)timer
{
    UIView *placeholderView = (UIView *)[timer userInfo];
    [placeholderView removeFromSuperview];
}


#pragma mark - ICRecordManagerDelegate

- (void)voiceDidPlayFinished
{
    self.voicePath = nil;
    ICRecordManager *manager = [ICRecordManager shareManager];
    manager.playDelegate = nil;
    [self.currentVoiceIcon stopAnimating];
    self.currentVoiceIcon = nil;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.presentFlag = YES;
    return self;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presentFlag = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    __weak typeof(self) weakself = self;
    
    if (self.presentFlag) {
        UIView *toView              = [transitionContext viewForKey:UITransitionContextToViewKey];
        self.presentImageView.frame = _smallRect;
        [[transitionContext containerView] addSubview:self.presentImageView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            weakself.presentImageView.frame = _bigRect;
        } completion:^(BOOL finished) {
            if (finished) {
                [weakself.presentImageView removeFromSuperview];
                [[transitionContext containerView] addSubview:toView];
                [transitionContext completeTransition:YES];
            }
        }];
    } else {
        ICPhotoBrowserController *photoVC = (ICPhotoBrowserController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIImageView *iv     = photoVC.imageView;
        UIView *fromView    = [transitionContext viewForKey:UITransitionContextFromViewKey];
        iv.center = fromView.center;
        [fromView removeFromSuperview];
        [[transitionContext containerView] addSubview:iv];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            iv.frame = _smallRect;
        } completion:^(BOOL finished) {
            if (finished) {
                [iv removeFromSuperview];
                [transitionContext completeTransition:YES];
            }
        }];
    }
}




#pragma mark - private

- (void) scrollToBottomisAnimation:(BOOL)isAnimation
{
    if (self.dataSource.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:isAnimation];
    }
}

// tap image
- (void)showLargeImageWithPath:(NSString *)imgPath
                  withMessageF:(ICMessageFrame *)messageF
{
    
    if(messageF.model.isSender){
        
        UIImage *image = [[ICMediaManager sharedManager] imageWithLocalPath:imgPath];
        if (image == nil) {
            ICLog(@"image is not existed");
            return;
        }
        
        
        
        ICPhotoBrowserController *photoVC = [[ICPhotoBrowserController alloc] initWithImage:image];
        
        self.presentImageView.image       = image;
        photoVC.transitioningDelegate     = self;
        photoVC.modalPresentationStyle    = UIModalPresentationCustom;
        [self presentViewController:photoVC animated:YES completion:nil];
    }else{
        
        UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
        if (image == nil) {
            ICLog(@"image is not existed");
            return;
        }
        
        
        
        ICPhotoBrowserController *photoVC = [[ICPhotoBrowserController alloc] initWithImage:image];
        
        self.presentImageView.image       = image;
        photoVC.transitioningDelegate     = self;
        photoVC.modalPresentationStyle    = UIModalPresentationCustom;
        [self presentViewController:photoVC animated:YES completion:nil];
        
    }
    
    
}

- (void)timerInvalue
{
    [_timer invalidate];
    _timer  = nil;
}

// 文件路径
- (NSString *)mediaPath:(NSString *)originPath
{
    // 这里文件路径重新给，根据文件名字来拼接
    NSString *name = [[originPath lastPathComponent] stringByDeletingPathExtension];
    return [[ICRecordManager shareManager] receiveVoicePathWithFileKey:name];
}

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath message:(ICMessageModel *)messageModel
{
    if (_copyMenuItem   == nil) {
        _copyMenuItem   = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    }
    if (_forwardMenuItem == nil) {
        _forwardMenuItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardMessage:)];
    }
    NSInteger currentTime = [ICMessageHelper currentMessageTime];
    NSInteger interval    = currentTime - messageModel.message.date;
    if (messageModel.isSender) {
        if ((interval/1000) < 5*60 && !(messageModel.message.deliveryState == ICMessageDeliveryState_Failure)) {
            if (_recallMenuItem == nil) {
                _recallMenuItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(recallMessage:)];
            }
            [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_recallMenuItem,_forwardMenuItem]];
        } else {
            [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_forwardMenuItem]];
        }
    } else {
        [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_forwardMenuItem]];
    }
    [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview ];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)copyMessage:(UIMenuItem *)copyMenuItem
{
    UIPasteboard *pasteboard  = [UIPasteboard generalPasteboard];
    ICMessageFrame * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
    pasteboard.string         = messageF.model.message.content;
}

- (void)deleteMessage:(UIMenuItem *)deleteMenuItem
{
    // 这里还应该把本地的消息附件删除
    ICMessageFrame * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
    [self statusChanged:messageF];
}

- (void)recallMessage:(UIMenuItem *)recallMenuItem
{
    // 这里应该发送消息撤回的网络请求
    ICMessageFrame * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
    [self.dataSource removeObject:messageF];
    
    ICMessageFrame *msgF = [ICMessageHelper createMessageFrame:TypeSystem content:@"你撤回了一条消息" path:nil from:@"gxz" to:self.group.gId fileKey:nil isSender:YES receivedSenderByYourself:NO];
    [self.dataSource insertObject:msgF atIndex:_longIndexPath.row];
    [self.tableView reloadData];
}


- (void)statusChanged:(ICMessageFrame *)messageF
{
    [self.dataSource removeObject:messageF];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[_longIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)forwardMessage:(UIMenuItem *)forwardItem
{
    ICLog(@"需要用到的数据库，等添加了数据库再做转发...");
}

#pragma mark - Getter and Setter

- (ICChatBoxViewController *) chatBoxVC
{
    if (_chatBoxVC == nil) {
        _chatBoxVC = [[ICChatBoxViewController alloc] init];
        [_chatBoxVC.view setFrame:CGRectMake(0,APP_Frame_Height-HEIGHT_TABBAR, App_Frame_Width, APP_Frame_Height)];
        _chatBoxVC.delegate = self;
    }
    return _chatBoxVC;
}

-(UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
//        _tableView.contentInset = UIEdgeInsetsMake(-(HEIGHT_STATUSBAR+HEIGHT_NAVBAR), 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIImageView *)presentImageView
{
    if (!_presentImageView) {
        _presentImageView = [[UIImageView alloc] init];
    }
    return _presentImageView;
}

- (ICVoiceHud *)voiceHud
{
    if (!_voiceHud) {
        _voiceHud = [[ICVoiceHud alloc] initWithFrame:CGRectMake(0, 0, 155, 155)];
        _voiceHud.hidden = YES;
        [self.view addSubview:_voiceHud];
        _voiceHud.center = CGPointMake(App_Frame_Width/2, APP_Frame_Height/2);
    }
    return _voiceHud;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer =[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
    return _timer;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [kNotificationCenter removeObserver:self];
    [self timerInvalue];
    [self.loadtimer invalidate];
    [super viewDidDisappear:animated];
}

- (void)dealloc{
    
    NSLog(@"销毁了");
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
