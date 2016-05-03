//
//  AYShareWithWechatCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYShareWithWechatCommand.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "Tools.h"

@implementation AYShareWithWechatCommand

- (void)performWithResult:(NSDictionary *)args andFinishBlack:(asynCommandFinishBlock)block{
    
    //    NSDictionary* user = nil;
    //    CURRENUSER(user)
    //    NSMutableArray* dic = [user mutableCopy];
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[Tools OriginImage:[args objectForKey:@"image"] scaleToSize:CGSizeMake(100, 100)]];
    // 缩略图
    message.title = @"咚哒";
    message.description = [args objectForKey:@"decs"];
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImagePNGRepresentation([args objectForKey:@"image"]);
    message.mediaObject = imageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
    if ([WXApi sendReq:req] == YES) {
        block(YES, nil);
    }else {
        block(NO, nil);
    }
    
//    if (![TencentOAuth iphoneQQInstalled]) {
//        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"当前手机未安装QQ无法分享到QQ空间" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
//        return;
//    }
//    SendMessageToQQReq* req;
//    QQApiObject *qqObj;
//    
//    NSData *thumbnailImg = UIImagePNGRepresentation([Tools OriginImage:[args objectForKey:@"image"] scaleToSize:CGSizeMake(100, 100)]);
//    NSData *previewImg = UIImagePNGRepresentation([args objectForKey:@"image"]);
//    qqObj = [QQApiImageObject objectWithData:previewImg previewImageData:thumbnailImg title:@"咚哒" description:[args objectForKey:@"decs"]];
//    
//    req = [SendMessageToQQReq reqWithContent:qqObj];
//    if ([QQApiInterface sendReq:req] == EQQAPISENDSUCESS) {
//        //        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"分享QQ失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
//        block(YES, nil);
//    }else {
//        block(NO, nil);
    
}
@end
