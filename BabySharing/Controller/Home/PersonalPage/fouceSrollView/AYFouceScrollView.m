//
//  AYFouceScrollView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFouceScrollView.h"
#import "AYCommandDefines.h"
#import "AYShowBoardCellView.h"
#import "Tools.h"
#import "AYControllerActionDefines.h"
#import "AYFactoryManager.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width

//@interface AYFouceCell : UICollectionViewCell
//
//@property (nonatomic, strong) UILabel *label;
//@property (nonatomic, strong) UIImageView *imageView;
//
//@end
//
//@implementation AYFouceCell
//
//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _imageView = [[UIImageView alloc]init];
//        [self addSubview:_imageView];
//        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
//    }
//    return self;
//}
//@end

@implementation AYFouceScrollView{
    NSArray *imageNameArr;
    SDCycleScrollView *cycleScrollView;
}
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
//    self.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
//    self.pagingEnabled = YES;
//    self.showsVerticalScrollIndicator = NO;
//    self.delegate = self;
    
    imageNameArr = @[@"lol",@"lol",@"lol"];
    
    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225) shouldInfiniteLoop:YES imageNamesGroup:imageNameArr];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.currentPageDotColor = [Tools themeColor];
    cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    [self addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    cycleScrollView.autoScrollTimeInterval = 4.0;
    
}

//-(instancetype)initWithFrame:(CGRect)frame /*collectionViewLayout:(nonnull UICollectionViewLayout *)layout */{
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//    layout.minimumInteritemSpacing = 0;
//    self = [super initWithFrame:frame collectionViewLayout:layout];
//    
//    if (self) {
//        [self registerClass:[AYFouceCell class] forCellWithReuseIdentifier:@"AYFouceCell"];
//    }
//    return self;
//}

- (void)layoutSubviews{
    [super layoutSubviews];
//    for (int i = 0; i < 3; ++i) {
//        CGFloat offset_x = SCREEN_WIDTH * i;
//        UIImageView *fouceImage = [[UIImageView alloc]initWithFrame:CGRectMake(offset_x, 0, SCREEN_WIDTH, 210)];
//        fouceImage.image = [UIImage imageNamed:imageNameArr[i]];
//        [self addSubview:fouceImage];
//    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return imageNameArr.count;
}
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    AYFouceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYFouceCell" forIndexPath:indexPath];
//    return cell;
//}

#pragma mark -- commands
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

#pragma mark -- actions
- (void)didCellClick:(UIGestureRecognizer*)tap{
    NSLog(@" cell did clik");
    id<AYCommand> des = DEFAULTCONTROLLER(@"PersonalPage");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    //    [dic_show_module setValue:[args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
}

#pragma mark -- scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"--- ccccc ---");
    //    if (self.contentOffset.x / CellWidth) {
    //
    //    }
    
}
@end
