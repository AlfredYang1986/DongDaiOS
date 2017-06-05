//
//  AYServiceImagesCell.m
//  BabySharing
//
//  Created by Alfred Yang on 5/6/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYServiceImagesCell.h"
#import "AYCommandDefines.h"

@implementation AYServiceImagesCell {
	UIImageView *imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (instancetype)init{
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize {
	
	self.backgroundColor = [UIColor clearColor];
	
	imageView = [[UIImageView alloc] init];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.image = IMGRESOURCE(@"default_image");
	[self addSubview:imageView];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
}

- (void)setItemImageWithImageName:(NSString *)imageName {
	
	[imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:IMGRESOURCE(@"default_image")];
}

- (void)setItemImageWithImage:(UIImage *)image {
	imageView.image = image;
}

@end
