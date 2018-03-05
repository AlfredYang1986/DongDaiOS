//
//  RemoteInstance.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 29/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "RemoteInstance.h"

@implementation RemoteInstance

+ (NSData*)remoteDownloadFileWithName:(NSString*)name andHost:(NSString*)host {
    NSURL* url = [NSURL URLWithString:[host stringByAppendingPathComponent:name]];
    return [RemoteInstance remoteDownDataFromUrl:url];
}

+ (NSData*)remoteDownDataFromUrl:(NSURL*)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData   *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    return data;
}

+ (id)searchDataFromData:(NSData*)data {
    
    if (data == nil) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"访问超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//        });
        return nil;
    }
    
    NSError * error = nil;
    NSDictionary * apperals = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:&error];
    if (apperals == nil) {
        NSLog(@"%@", error);
    }
    
    if ([apperals isKindOfClass:[NSDictionary class]]){
        NSDictionary *dictionary = (NSDictionary *)apperals;
        NSLog(@"Dersialized JSON Dictionary = %@", dictionary);
        return dictionary;
        
    }else if ([apperals isKindOfClass:[NSArray class]]){
        NSArray *nsArray = (NSArray *)apperals;
        NSLog(@"Dersialized JSON Array = %@", nsArray);
        return nsArray;
    } else {
        NSLog(@"An error happened while deserializing the JSON data.");
        return nil;
    }
}

+ (id)remoteSeverRequestData:(NSData*)data toUrl:(NSURL*)url {
    
    // 1> 数据体
    NSMutableData *dataM = [NSMutableData data];
    [dataM appendData:data];
    
    // 1. Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2000.0f];
    
    // dataM出了作用域就会被释放,因此不用copy
    request.HTTPBody = dataM;
    
    // 2> 设置Request的头属性
    request.HTTPMethod = @"POST";
    
    // 3> 设置Content-Length
    NSString *strLength = [NSString stringWithFormat:@"%ld", (long)dataM.length];
    [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
    
    // 4> 设置Content-Type
    NSString *strContentType = [NSString stringWithFormat:@"application/json"];
    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    
    // 5> 设置data type
    NSString *strDatatype = [NSString stringWithFormat:@"application/json"];
    [request setValue:strDatatype forHTTPHeaderField:@"Accept"];
    
    
    // 3> 连接服务器发送请求
    //    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    //
    //        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        NSLog(@"%@", result);
    //    }];
    
    NSError * error = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    return [RemoteInstance searchDataFromData:response];
}

//+ (id)uploadPicture:(NSDictionary*)params toUrl:(NSURL*)url {
//+ (id)uploadPicture:(UIImage*)image withName:(NSString*)filename toUrl:(NSURL*)url {
+ (void)uploadFileUrl:(NSURL*)path withName:(NSString*)filename toUrl:(NSURL*)url callBack:(blockUploadCallback)callback {
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    //    UIImage *image=[params objectForKey:@"pic"];
    //得到图片的data
    //    NSData* data = UIImagePNGRepresentation(image);
//    NSData* data = [NSData dataWithContentsOfFile:path];
    NSData* data = [NSData dataWithContentsOfURL:path];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    //    NSArray *keys= [params allKeys];
    
    //遍历keys
    //    for(int i=0; i<[keys count]; ++i) {
    //        //得到当前key
    //        NSString *key=[keys objectAtIndex:i];
    //        //如果key不是pic，说明value是字符类型，比如name：Boris
    //        if(![key isEqualToString:@"pic"]) {
    //            //添加分界线，换行
    //            [body appendFormat:@"%@\r\n",MPboundary];
    //            //添加字段名称，换2行
    //            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
    //            //添加字段的值
    //            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
    //        }
    //    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    //    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@\"\r\n", filename];
    [body appendFormat:@"Content-Disposition: form-data; name=\"upload\"; filename=\"%@\"\r\n", filename];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    //设置接受response的data
    NSError* error = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    NSDictionary* result = [RemoteInstance searchDataFromData:response];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        callback(YES, @"success");
        
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        callback(NO, msg);
    }
}

+ (void)uploadFile:(NSString*)path withName:(NSString*)filename toUrl:(NSURL*)url callBack:(blockUploadCallback)callback {
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    //    UIImage *image=[params objectForKey:@"pic"];
    //得到图片的data
    //    NSData* data = UIImagePNGRepresentation(image);
    NSData* data = [NSData dataWithContentsOfFile:path];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    //    NSArray *keys= [params allKeys];
    
    //遍历keys
    //    for(int i=0; i<[keys count]; ++i) {
    //        //得到当前key
    //        NSString *key=[keys objectAtIndex:i];
    //        //如果key不是pic，说明value是字符类型，比如name：Boris
    //        if(![key isEqualToString:@"pic"]) {
    //            //添加分界线，换行
    //            [body appendFormat:@"%@\r\n",MPboundary];
    //            //添加字段名称，换2行
    //            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
    //            //添加字段的值
    //            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
    //        }
    //    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    //    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@\"\r\n", filename];
    [body appendFormat:@"Content-Disposition: form-data; name=\"upload\"; filename=\"%@\"\r\n", filename];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    //设置接受response的data
    NSError* error = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    NSDictionary* result = [RemoteInstance searchDataFromData:response];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        callback(YES, @"success");
        
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        callback(NO, msg);
    }
}

+ (void)uploadPicture:(UIImage*)image withName:(NSString*)filename toUrl:(NSURL*)url callBack:(blockUploadCallback)callback {
    
    //重绘图片
    UIImage *newImage;
    if (image.size.width > 750 || image.size.height > 500 /*|| image.size.width/image.size.height != 750/500*/) {
        CGSize expectSize = CGSizeMake(750, 500);
        
        float imageWidth = image.size.width;
        float imageHeight = image.size.height;
        float widthScale = imageWidth / expectSize.width;
        float heightScale = imageHeight / expectSize.height;
        
        // 创建一个bitmap的context
        CGFloat scaling;
        CGSize adjustSize;
        
        if (widthScale > heightScale) {
            
            scaling = heightScale;
            adjustSize = CGSizeMake(imageWidth / scaling,  expectSize.height);
        } else {
            
            scaling = widthScale;
            adjustSize = CGSizeMake(expectSize.width, imageHeight / scaling);
        }
        
        UIGraphicsBeginImageContextWithOptions(adjustSize, YES , 0);
        [image drawInRect:CGRectMake(0, 0, adjustSize.width, adjustSize.height)];
        //从上下文中获取图片
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使用了beginImgacontext需要关闭上下文 并从上下文栈中移除
        UIGraphicsEndImageContext();
    } else {
        newImage = image;
    }
    
    NSData * imageData = UIImageJPEGRepresentation(newImage,1);
    CGFloat length = [imageData length] / 1024;
    NSLog(@"%lf" , length);
    NSData* data;
    if (length > 200) {
       data = UIImageJPEGRepresentation(newImage, 200.0 / length);
    } else {
//        CGFloat kCompressQuality = 0.3;
        data = UIImageJPEGRepresentation(newImage, 1.0);
    }
	
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	[dic setValue:filename forKey:@"img_name"];
	[dic setValue:data forKey:@"img"];
	
	id tmp = [dic copy];
	id<AYFacadeBase> oss_f = DEFAULTFACADE(@"AliyunOSS");
	id<AYCommand> cmd_oss_get = [oss_f.commands objectForKey:@"OSSPut"];
	[cmd_oss_get performWithResult:&tmp];
	
	NSDictionary *back_args = tmp;
	callback([[back_args objectForKey:@"success"] boolValue], [back_args objectForKey:@"msg"]);
	
//	//分界线的标识符
//	NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
//	//根据url初始化request
//	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url
//														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//													   timeoutInterval:10];
//	//分界线 --AaB03x
//	NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
//	//结束符 AaB03x--
//	NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
//	//要上传的图片
//	//    UIImage *image=[params objectForKey:@"pic"];
//	//得到图片的data
//	//    NSData* data = UIImagePNGRepresentation(image);
//
//    //http body的字符串
//    NSMutableString *body=[[NSMutableString alloc]init];
//    //参数的集合的所有key的集合
////    NSArray *keys= [params allKeys];
//
//    //遍历keys
////    for(int i=0; i<[keys count]; ++i) {
////        //得到当前key
////        NSString *key=[keys objectAtIndex:i];
////        //如果key不是pic，说明value是字符类型，比如name：Boris
////        if(![key isEqualToString:@"pic"]) {
////            //添加分界线，换行
////            [body appendFormat:@"%@\r\n",MPboundary];
////            //添加字段名称，换2行
////            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
////            //添加字段的值
////            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
////        }
////    }
//
//    ////添加分界线，换行
//    [body appendFormat:@"%@\r\n",MPboundary];
//    //声明pic字段，文件名为boris.png
////    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@\"\r\n", filename];
//    [body appendFormat:@"Content-Disposition: form-data; name=\"upload\"; filename=\"%@\"\r\n", filename];
//    //声明上传文件的格式
//    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
//
//    //声明结束符：--AaB03x--
//    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
//    //声明myRequestData，用来放入http body
//    NSMutableData *myRequestData=[NSMutableData data];
//    //将body字符串转化为UTF8格式的二进制
//    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    //将image的data加入
//    [myRequestData appendData:data];
//    //加入结束符--AaB03x--
//    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//
//    //设置HTTPHeader中Content-Type的值
//    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
//    //设置HTTPHeader
//    [request setValue:content forHTTPHeaderField:@"Content-Type"];
//    //设置Content-Length
//    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
//    //设置http body
//    [request setHTTPBody:myRequestData];
//    //http method
//    [request setHTTPMethod:@"POST"];
//
//    //建立连接，设置代理
//    //设置接受response的data
//    NSError* error = nil;
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//
//    NSDictionary* result = [RemoteInstance searchDataFromData:response];
//
//    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
//        callback(YES, @"success");
//
//    } else {
//        NSDictionary* reError = [result objectForKey:@"error"];
//        NSString* msg = [reError objectForKey:@"message"];
//        callback(NO, msg);
//    }
}
@end