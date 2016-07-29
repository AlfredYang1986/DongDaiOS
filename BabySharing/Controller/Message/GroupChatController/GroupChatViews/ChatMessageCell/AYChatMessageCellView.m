//
//  ChatViewCell.m
//  BabySharing
//
//  Created by Alfred Yang on 12/10/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "AYChatMessageCellView.h"
//#import "GotyeOCMessage.h"
//#import "LoginModel.h"
#import "AppDelegate.h"
#import "RemoteInstance.h"
#import "TmpFileStorageModel.h"
#import "OBShapedButton.h"
#import "Tools.h"

#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYChatMessageCellDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYControllerActionDefines.h"

#import "EMSDK.h"
#import "EMError.h"
#import "EMMessage.h"

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define IMG_WIDTH               32

#define MARGIN                  8
#define MARGIN_BIG              14

#define TIME_LABEL_MARGIN       10.5
#define TIME_LABEL_HEIGHT       26

#define TIME_FONT_SIZE          10.f
#define NAME_FONT_SIZE          10.f
#define CONTENT_FONT_SIZE       14.f

#define MARGIN_BOTTOM       8
#define NAME_MARGIN_TOP     10

@implementation AYChatMessageCellView {
//    OBShapedButton* time_label;
//    UITextView* content;
    UILabel* time_label;
    UILabel* name_label;
    UILabel* content;
    UIImageView* imgView;
    UIImageView *bgView;
   
    CALayer* layer;
    BOOL isSenderByOwner;
    
    NSString* sender_user_id;
}

@synthesize message = _message;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
        [self setupSubviews];
    }

    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor clearColor];
    
    if (time_label == nil) {
        time_label = [[UILabel alloc]init];
        time_label.font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
        time_label.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
        [self addSubview:time_label];
    }
    
    if (content == nil) {

        content = [[UILabel alloc]init];
        [self addSubview:content];
        content.text = @"asdfjlkasjlkajsflasjfl";
        content.textColor = [Tools blackColor];
        content.font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
        content.numberOfLines = 0;
        
//        [content addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    }
    
    if (imgView == nil) {
        imgView = [[UIImageView alloc]init];
        imgView.bounds = CGRectMake(0, 0, IMG_WIDTH, IMG_WIDTH);
        imgView.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.3].CGColor;
        imgView.layer.borderWidth = 1.5f;
        imgView.layer.cornerRadius = IMG_WIDTH / 2;
        imgView.clipsToBounds = YES;
        [self addSubview:imgView];
        
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer* gusture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenPhotoTaped:)];
        [imgView addGestureRecognizer:gusture];
    }
    
    if (bgView == nil) {
        bgView = [[UIImageView alloc]init];
        UIImage *bg = [UIImage imageNamed:@"group_chat_input_bg"];
        bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 10, 15) resizingMode:UIImageResizingModeStretch];
        bgView.image = bg;
        [self addSubview:bgView];
        [self sendSubviewToBack:bgView];
    }
}

#pragma mark - KVO
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    UITextView *tv = object;
//    
//    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
//    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
//    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
//}
//
//- (void)dealloc {
//    [content removeObserver:self forKeyPath:@"contentSize"];
//}

- (void)screenPhotoTaped:(UITapGestureRecognizer*)gusture {
    
    UIViewController* des = DEFAULTCONTROLLER(@"Profile");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:sender_user_id forKey:kAYControllerChangeArgsKey];
    
    [_controller performWithResult:&dic_push];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (isSenderByOwner) {
        
        [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(20);
            make.size.mas_equalTo(CGSizeMake(IMG_WIDTH, IMG_WIDTH));
        }];
        
        [content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imgView.mas_left).offset(-30);
            make.top.equalTo(imgView).offset(20);
            make.width.mas_equalTo(SCREEN_WIDTH * 0.7);
            make.bottom.equalTo(self).offset(-40);
        }];
        
        [time_label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content);
            make.top.equalTo(content.mas_bottom).offset(10);
        }];
        
        [bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(content).insets(UIEdgeInsetsMake(-20, -20, -35, -30));
        }];
        
    } else {
        [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(20);
            make.size.mas_equalTo(CGSizeMake(IMG_WIDTH, IMG_WIDTH));
        }];
        
        [content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(30);
            make.top.equalTo(imgView).offset(20);
            make.width.mas_equalTo(SCREEN_WIDTH * 0.7);
            make.bottom.equalTo(self).offset(-40);
        }];
        
        [time_label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(content);
            make.top.equalTo(content.mas_bottom).offset(10);
        }];
        
        [bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(content).insets(UIEdgeInsetsMake(-20, -30, -35, -20));
        }];
    }
}

- (void)setEMMessage:(EMMessage*)msg {
//- (void)setGotyeOCMessage:(GotyeOCMessage*)msg {
    _message = msg;
   
    NSDictionary* user = nil;
    CURRENUSER(user);
    
    isSenderByOwner = [[user objectForKey:@"user_id"] isEqualToString:_message.from];
    [self setContent:((EMTextMessageBody*)_message.body).text];
    [self setContentDate:nil];
    
    sender_user_id = _message.from;
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"ScreenNameAndPhotoCache");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"QueryScreenNameAndPhoto"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:sender_user_id forKey:@"user_id"];
    
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        [self setSenderImage:[result objectForKey:@"screen_photo"]];
    }];
}

- (void)setSenderImage:(NSString*)photo_name {

    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:photo_name forKey:@"image"];
    [dic setValue:@"img_icon" forKey:@"expect_size"];
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            [imgView setImage:img];
        }else [imgView setImage:PNGRESOURCE(@"default_user")];
    }];
}

- (void)setContent:(NSString*)content_text {
    if (content_text) {
//        content.text = content_text;
    }
}

- (void)setContentDate:(NSDate*)date2 {
    time_label.text = [Tools compareCurrentTime:date2];
}

+ (CGFloat)preferredHeightWithInputText:(NSString*)content andSenderID:(NSString*)sender_user_id {
    /**
     * 1. get screen width
     */
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
  
    /**
     * 4. width left for content
     */
    CGFloat img_container = (MARGIN_BIG + IMG_WIDTH + 2 * MARGIN);
    CGFloat content_width = width - 2 * img_container;
    UIFont* content_font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
    CGSize content_size = [Tools sizeWithString:content withFont:content_font andMaxSize:CGSizeMake(content_width, FLT_MAX)];
  
    return (MAX(IMG_WIDTH, content_size.height + 2 * MARGIN) + MARGIN_BIG + MARGIN_BOTTOM) + NAME_MARGIN_TOP;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYChatMessageCellName, kAYChatMessageCellName);
   
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
}

#pragma mark -- commands
- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

#pragma mark -- messages
- (id)queryCellHeight:(id)args {
    return [NSNumber numberWithFloat:44.f];
}

- (id)setCellInfo:(id)args {
    
    NSDictionary* dic = (NSDictionary*)args;
    AYChatMessageCellView* cell = [dic objectForKey:kAYChatMessageCellCellKey];
//    GotyeOCMessage* m = [dic objectForKey:kAYChatMessageCellContentKey];
    EMMessage* m = [dic objectForKey:kAYChatMessageCellContentKey];
    cell.message = m;
    return nil;
}
@end
