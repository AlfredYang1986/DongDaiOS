//
//  AYAlipayPayCommand.m
//  BabySharing
//
//  Created by BM on 21/02/2017.
//  Copyright © 2017 Alfred Yang. All rights reserved.
//

#import "AYAlipayPayCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYNotifyDefines.h"

#import "Order.h"
#import "APAuthV2Info.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

static NSString *appID = @"2017030306024842";
static NSString *rsaPrivateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAON+W+R+oxSLdD9h2eHq3sIkEeTx5sasifPPNTRXaLojejRdCcn883ew2CprAIBlcShlieZUS3a8bGWi3crs+WKAAFa2Jtre5OP3gwKTVrRckgm7f2/suSvHtcaXHThFocef8kuMPt4OWv9O+xDVdiZ24t9e/SHD+Z3dGtRQrYstAgMBAAECgYEA4LaQTsRIkqKt0W32qxI1t8+pXV0VeGo2Wn7zLyCocjVZISBF6x/R3wjwffX0KOALRrwF216orECzUjHuo+Qw8R5NrLxqr/iwUCkU8+cuiOtKWfuGmSbgFwpfh7fgJbfjEFejOR5hzhVXm5NKBcoB/JlMUb8eKbYaFtI1TRmjIAECQQD4GgvA5wOFtw4G1ulODDNsFVmduuTbrf67Xgq2oaJy5D9PSMDE1Ez6h8e7cpvbyPjLjAKoTcl42vOs1N1EQ0btAkEA6rxc4y/5YCNMKLYbkFKJ8tCxW8W6FoMFpsO7RzS6zkbNDMHFvhJxOSIdNj9XaUIYba0/oFmjoktIs1NhqqiNQQJBANWkCA76Xuwb73YwRgKxOu6Ni/fo4f3RXJMXrf4KPYrVxTaOnYBgmFD77yAY1uFxs9wDGp63LRBm6oIfYtHPZRkCQCRVQ4tmwZK/4+npRhrwq6mJ4+nwkP0rCpTldvdukfubueFfnNvuvte5EAx1gXIpaN6REmgfd9SHEpmvLk7cCAECQGqcw5O+nBClySm+vPlHPgBN/MQjKsUl0pjTo7my+/gwULnFcUxzpVVaxlXMDlhLQ8KhvQXYcaHRiluQs5kMl5Q=";
static NSString *rsa2PrivateKey = @"";
//static NSString *rsa2PrivateKey = @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCFJ2q+RNJDsWjK/jhKBQasvv8OjUTLehLejCXLpUHsIg4Elc5FOk6LR3QLqFwVibNCp2Xa6+8Fqs9wAkpDaoNbwW/jzZUlDmOgUhpmoBbgfIXYkncOCyT4jYS9y2UQwLL8xYaK55VK+gFDIyX4sIO4tzyX4GCzu0JN+xVpwaPQBV0PAfVoABYi4t20n9ZOnGyFUSZXnRsMORiYiBfmtXb5X1RPT33j1UB+eeGOnnJn3xClia0pHJsMC7zmy5bA2v5dYBtgW+BABScFvAxxgi6uAp6USDdvzUJ0onLmCTeYf9NeFlZfw4R5t4ljCXDE+0HXNut7y8beGKiJosfuJBtnAgMBAAECggEAJ8cAslpo3eQPxCRxuFsMBWsBUt2M4aRUIruHRvDVYq9BtMjz1+Z1NFJiLmFbMOvz60OKv/2fZ/gBBBsLCFy3ZR/CRzFRDsLfrDMaw/GrI+DPM0V932og30eXkgNC6+BFGBICAVjxVnadDetgGozQrMvAhDZ5bPfR9O2/FdrNDwU6D1toP9R5LVMdKOYkSaWGJkVkfwBtdZoud03VwuWuzC0EplG+ady3M3vUVBq7JLzuzRfk/Y8CNI3Bv8FcC6DN9tqkEtbBmrrkmz5P2bYpi7JZTEqF0G5Xk2NE2qCH3TpnJlUDo0QrvdtCHpgq0ueiqfgpEHfq5FUz5igGgp2IsQKBgQDnGuBwHOZJHTM8ZoAu3zBEL7bDNoWHHh9/zTEBKkAJH3tnSJycDKNYLRX3NcXhJbD+HzVRLJnzIqotocGsdzc6UH7MGVfX5KagEykiJ8CB8Bx9sshnKP1fsJr3MfQ66li3Kc6L9YwAcW4NrfTjolWVO2z5PJs09TEkRvo3NFd9/QKBgQCTf16/SCmOpx4JY6ErHMJUlf6rWvro0YVQs1QyvDRXXMhTLwu8hvJK2vYh8lfbqtanJSPs0nwENQM54/LgyBlFbYDMIga4cZd+k8L3yDn7l2DzUOiGJmG7/HQqvSN3/Tt6PIrRcjIW0nQcaX9w+2MmUv9jFWmW2WUlmWesivyqMwKBgQDSgCqaM9iWFCDNDVgIWYavNP61hP3O+uMaF55hP0ighqpygzMS+Hf4Iuj1CWe6EgjLD0YTMBrx2UtE0SeFnfkSBqvX3+WhYkVbXNiEocy5DioFXEkpna5b8JLWQgwBdd9kxpG57eidprPlheOfTAfELCKwSkHc1ND0CCp1Chn/SQKBgAxz227wy7lkeI+4XpoCMpHrm/Whl79iOQwoJ7qk0xJxHeSP+0Cub/RL6i3RhQNht/+ijhbnalr8ksonaZD6s899wDr7wG9//5dLKFG9ENAh5qiEMy1oPiYd2TzmfQEbWxMl2151cq8kk3L2oTDLuII6zZ7y5tg6gGSdP/h8P3qrAoGBAJd/J/VJ5rx3jN33olkl25X0joRMXXb24Peg8K0xUdiRvZ4mKb8bvPgewBohPFS5RnfnbErAW1mlK/VQwATfu/U/SJqJ97/kxLyvoyCP5RXDrtsdfS/FL+MJJh1fm4jhD9kLjgcDA55X27MAQhLpJawRP+Z6XyJnPyI+cmN0YMZD";

@implementation AYAlipayPayCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = @"12345"; //[self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"dongdaalipay";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }

}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
