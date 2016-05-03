//
//  AYShareWithQQCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYShareWithQQCommand.h"
#import "TencentOAuth.h"
#import "QQApiInterfaceObject.h"
#import "QQApiInterface.h"
#import "AYNotifyDefines.h"
#import "AYFacade.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "Tools.h"

@implementation AYShareWithQQCommand

- (void)performWithResult:(NSDictionary *)args andFinishBlack:(asynCommandFinishBlock)block{
    
//    if (![TencentOAuth iphoneQQInstalled]) {
//        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"当前手机未安装QQ无法分享到QQ空间" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
//        return;
//    }
    SendMessageToQQReq* req;
    QQApiObject *qqObj;
    
    NSData *thumbnailImg = UIImagePNGRepresentation([Tools OriginImage:[args objectForKey:@"image"] scaleToSize:CGSizeMake(100, 100)]);
    NSData *previewImg = UIImagePNGRepresentation([args objectForKey:@"image"]);
    qqObj = [QQApiImageObject objectWithData:previewImg previewImageData:thumbnailImg title:@"咚哒" description:[args objectForKey:@"decs"]];
    
    req = [SendMessageToQQReq reqWithContent:qqObj];
    if ([QQApiInterface sendReq:req] == EQQAPISENDSUCESS) {
        block(YES, nil);
    }else {
        block(NO, nil);
    }

}
@end
