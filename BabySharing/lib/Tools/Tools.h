//
//  Tools.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject

+ (UIImage *)imageWithView:(UIView *)view;
+ (NSString *)subStringWithByte:(NSInteger)byte str:(NSString *)str;
+ (NSInteger)bityWithStr:(NSString *)str;
+ (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
+ (NSArray *)sortWithArr:(NSArray *)arr headStr:(NSString *)headStr;
+ (UIColor *)colorWithRED:(CGFloat)RED GREEN:(CGFloat)GREEN BLUE:(CGFloat)BLUE ALPHA:(CGFloat)ALPHA;
+ (UIImage *)addPortraitToImage:(UIImage *)image userHead:(UIImage *)userhead userName:(NSString *)userName;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)compareCurrentTime:(NSDate*) compareDate;
+ (NSString*)getDeviceUUID;
+ (UIViewController *)activityViewController;
+ (UIViewController *)activityViewController2;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (CGSize)sizeWithString:(NSString*)str withFont:(UIFont*)font andMaxSize:(CGSize)sz;
+ (UIColor*)themeColor;
+ (UIColor*)blackColor;
+ (UIColor*)whiteColor;
+ (UIColor*)garyColor;
+ (UIColor*)garyLineColor;
+ (UIColor*)garyBackgroundColor;

+ (UILabel*)setLabelWith:(UILabel*)label andText:(NSString*)text andTextColor:(UIColor*)color andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor andTextAlignment:(NSTextAlignment)align;
+ (UIButton*)setButton:(UIButton*)btn withTitle:(NSString*)title andTitleColor:(UIColor*)TitleColor andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor;


+ (UIImage*)SourceImageWithRect:(CGRect)rc fromView:(UIView*)view;
+ (UIImage*)splitImage:(UIImage *)image from:(CGFloat)height left:(UIImage**)pImg;
@end
