//
//  UILabel+Factory.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "UILabel+Factory.h"

@implementation UILabel (Factory)

#pragma mark -- UI
/**
 *  PS: fontSize.正常数值为细体/300+为正常/600+为粗体
 */
+ (UILabel*)creatLabelWithText:(NSString*)text textColor:(UIColor*)color fontSize:(CGFloat)font backgroundColor:(UIColor*)backgroundColor textAlignment:(NSTextAlignment)align {
	
	UILabel *label = [UILabel new];
	if (text){
		label.text = text;
	}
	label.textColor = color;
	label.textAlignment = align;
	label.numberOfLines = 0;
	
	if (font > 600.f) {
		label.font = kAYFontMedium(font - 600);
	} else if (font < 600.f && font > 300.f) {
		label.font = [UIFont systemFontOfSize:(font - 300)];
	} else {
		label.font = kAYFontLight(font);
	}
	
	if (backgroundColor) {
		label.backgroundColor = backgroundColor;
	}
	
//	label.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	
	return label;
}

+ (UILabel *)creatLabelWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor textAlignment:(NSTextAlignment)align {
    
    UILabel *label = [UILabel new];
    if (text){
        label.text = text;
    }
    label.textColor = color;
    label.textAlignment = align;
    label.numberOfLines = 0;
    
    if (font) {
        
        label.font = font;
        
    }
    
    if (backgroundColor) {
        label.backgroundColor = backgroundColor;
    }
    
    return label;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    return (action == @selector(copyText:));
    
}

- (void)attachTapHandler {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *g = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:g];
}

//  处理手势相应事件
- (void)handleTap:(UIGestureRecognizer *)g {
    
    
    if (g.state != UIGestureRecognizerStateBegan)
        return ;
    
    [self becomeFirstResponder];
    
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:item]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
}

//  复制时执行的方法
- (void)copyText:(id)sender {
    //  通用的粘贴板
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
    
    //  有些时候只想取UILabel的text中的一部分
    if (objc_getAssociatedObject(self, @"expectedText")) {
        pBoard.string = objc_getAssociatedObject(self, @"expectedText");
    } else {
        
        //  因为有时候 label 中设置的是attributedText
        //  而 UIPasteboard 的string只能接受 NSString 类型
        //  所以要做相应的判断
        if (self.text) {
            pBoard.string = self.text;
        } else {
            pBoard.string = self.attributedText.string;
        }
    }
}

- (BOOL)canBecomeFirstResponder {
    return [objc_getAssociatedObject(self, @selector(isCopyable)) boolValue];
}

- (void)setIsCopyable:(BOOL)number {
    objc_setAssociatedObject(self, @selector(isCopyable), [NSNumber numberWithBool:number], OBJC_ASSOCIATION_ASSIGN);
    [self attachTapHandler];
}

- (BOOL)isCopyable {
    return [objc_getAssociatedObject(self, @selector(isCopyable)) boolValue];
}


@end
