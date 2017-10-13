//
//  AYScheduleWeekDaysView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYScheduleWeekDaysView.h"
#import "AYShadowRadiusView.h"
#import "AYSpecialDayCellView.h"



#define btnSpaceW				(SCREEN_WIDTH - 40) / 7
#define btnWH					30
#define btnMarginTop			15
#define kItemCellWH				btnSpaceW

#define kUnableHeight					60
#define kEnableHeight					80
#define kExpendHeight					290

@implementation AYScheduleWeekDaysView {
    AYWeekDayBtn *noteBtn;
	UIView *sepLineView;
    UIView *currentSign;
	NSMutableArray *dayBtnArr;
	NSMutableArray *weekdayNodeArr;
	
	UIView *animatView;
	
	UICollectionView *scheduleView;
	NSString *currentDate;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	
	CGFloat margin  = 20;
	self.frame = CGRectMake(margin, 0, SCREEN_WIDTH - margin*2, kUnableHeight);
	
	AYShadowRadiusView *BGView = [[AYShadowRadiusView alloc] initWithRadius:4.f];
	[self addSubview:BGView];
	[self sendSubviewToBack:BGView];
	[BGView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	animatView = [[UIView alloc] init];
	[BGView.radiusBGView addSubview:animatView];
	[animatView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(BGView);
		make.bottom.equalTo(BGView);
		make.width.equalTo(BGView);
		make.height.equalTo(@20);
	}];
	
	sepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 31, self.frame.size.width, 1)];
	[self addSubview:sepLineView];
	sepLineView.backgroundColor = [Tools garyLineColor];
	sepLineView.hidden = YES;
	
	animatView.userInteractionEnabled = YES;
	UISwipeGestureRecognizer *swipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
	//如果想支持上下左右清扫  那么一个手势不能实现  需要创建两个手势
	swipe.direction = UISwipeGestureRecognizerDirectionDown;
	[animatView addGestureRecognizer:swipe];
	
	UISwipeGestureRecognizer *swipe_up =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
	swipe_up.direction = UISwipeGestureRecognizerDirectionUp;
	[animatView addGestureRecognizer:swipe_up];
	
	UIView *swipeSignView = [[UIView alloc] init];
	[animatView addSubview:swipeSignView];
	[swipeSignView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(animatView);
		make.size.mas_equalTo(CGSizeMake(35, 5));
	}];
	[Tools setViewBorder:swipeSignView withRadius:2.5 andBorderWidth:0 andBorderColor:nil andBackground:[Tools garyColor]];
	animatView.hidden = YES;
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.itemSize = CGSizeMake(kItemCellWH, kItemCellWH);
	layout.minimumLineSpacing = 0;
	layout.minimumInteritemSpacing = 0;
	
	NSDate *current = [[NSDate alloc]init];
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	currentDate = [formatter stringFromDate:current];
	
	scheduleView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width, kItemCellWH*5 ) collectionViewLayout:layout];
	scheduleView.backgroundColor = [UIColor clearColor];
	[BGView.radiusBGView addSubview:scheduleView];
	scheduleView.delegate = self;
	scheduleView.dataSource = self;
	//	_calendarContentView.allowsMultipleSelection = YES;
	scheduleView.showsVerticalScrollIndicator = NO;
	scheduleView.alpha = 0;
	
	[scheduleView registerClass:[AYSpecialDayCellView class] forCellWithReuseIdentifier:@"AYSpecialDayCellView"];
	[scheduleView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AYSpecialDayHeader"];
	
    currentSign = [[UIView alloc] init];
	currentSign.backgroundColor = [Tools themeColor];
    [sepLineView addSubview:currentSign];
    [currentSign mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sepLineView);
        make.centerX.equalTo(self.mas_left).offset(btnSpaceW - btnSpaceW * 0.5);
        make.size.mas_equalTo(CGSizeMake(btnSpaceW, 2));
    }];
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

- (void)swipeAction:(UISwipeGestureRecognizer *)swipe {
	
	if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
		NSLog(@"UP");
		if(self.frame.size.height == kEnableHeight) return;
		
		sepLineView.hidden = YES;
		[UIView animateWithDuration:0.75 animations:^{
			
			for (AYWeekDayBtn *btn in dayBtnArr) {
				btn.states = WeekDayBtnStateNormalAnimat;
				[btn mas_updateConstraints:^(MASConstraintMaker *make) {
					make.top.equalTo(self).offset(btnMarginTop);
				}];
			}
		} completion:^(BOOL finished) {
			
			[self resetWeekdayBtnState];
		}];
		
		[UIView animateWithDuration:0.75 animations:^{
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kEnableHeight);
			scheduleView.alpha = 0;
			[self layoutIfNeeded];
		}];
		
	} else if(swipe.direction == UISwipeGestureRecognizerDirectionDown) {
		NSLog(@"DOWN");
		if(self.frame.size.height == kExpendHeight) return;
		
		[UIView animateWithDuration:0.75 animations:^{
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kExpendHeight);
			scheduleView.alpha = 1;
			for (AYWeekDayBtn *btn in dayBtnArr) {
				btn.states = WeekDayBtnStateSmall;
				[btn mas_updateConstraints:^(MASConstraintMaker *make) {
					make.top.equalTo(self);
				}];
			}
			[self layoutIfNeeded];
		} completion:^(BOOL finished) {
			sepLineView.hidden = NO;
			animatView.backgroundColor = [Tools themeLightColor];
			[animatView.layer addAnimation:[self opacityForever_Animation:0.5 andRepeat:3] forKey:nil];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				animatView.backgroundColor = [Tools whiteColor];
			});
		}];
		
	}
}
#pragma mark === 闪烁动画
- (CABasicAnimation *)opacityForever_Animation:(float)time andRepeat:(int)count {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
	animation.fromValue = [NSNumber numberWithFloat:0.2f];
	animation.toValue = [NSNumber numberWithFloat:1.f];//这是透明度。
	animation.autoreverses = YES;
	animation.duration = time;
	animation.repeatCount = count;
	animation.removedOnCompletion = YES;
	animation.fillMode = kCAFillModeForwards;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
	return animation;
}

#pragma mark -- notifies
- (id)setViewInfo:(NSArray*)args {
    
    weekdayNodeArr = [NSMutableArray array];
    [args enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weekdayNodeArr addObject:[obj objectForKey:@"day"]];
    }];
    
    NSArray *weekdays = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六" ];
	dayBtnArr = [NSMutableArray array];
    for (int i = 0; i < weekdays.count; ++i) {
        AYWeekDayBtn *dayBtn = [[AYWeekDayBtn alloc] initWithTitle:weekdays[i]];
        dayBtn.tag = i;
        dayBtn.states = WeekDayBtnStateNormal;
        [dayBtn addTarget:self action:@selector(didDayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dayBtn];
		[dayBtnArr addObject:dayBtn];
        [dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_left).offset(btnSpaceW * (i+1) - btnSpaceW * 0.5);
            make.top.equalTo(self).offset(btnMarginTop);
            make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
        }];
        
        if([weekdayNodeArr containsObject:[NSNumber numberWithInt:i]]) {
            dayBtn.states = WeekDayBtnStateSeted;
        }
    }
    return nil;
}

- (id)havenAddTM:(id)args {
	if (self.frame.size.height > kUnableHeight) {
		return nil;
	}
	[UIView animateWithDuration:0.25 animations:^{
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kEnableHeight);
		[self layoutIfNeeded];
	} completion:^(BOOL finished) {
		animatView.hidden = NO;
		animatView.backgroundColor = [Tools themeLightColor];
		[animatView.layer addAnimation:[self opacityForever_Animation:0.5 andRepeat:3] forKey:nil];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			animatView.backgroundColor = [Tools whiteColor];
		});
	}];
	return nil;
}

#pragma mark -- actions
- (void)resetWeekdayBtnState {
	for (int i = 0 ; i < dayBtnArr.count; ++i) {
		if([weekdayNodeArr containsObject:[NSNumber numberWithInt:i]]) {
			AYWeekDayBtn *btn = [dayBtnArr objectAtIndex:i];
			btn.states = WeekDayBtnStateSeted;
		}
	}
}

- (void)didDayBtnClick:(AYWeekDayBtn*)btn {
    if (noteBtn == btn || btn.states == WeekDayBtnStateSmall) {
        return;
    }
	
	if (!noteBtn) {
		//第一次触发weekday btn -> 发送消息：激活添加时间sign
		
	}
    
    //notifies
    NSNumber *index = [NSNumber numberWithInteger:btn.tag];
    kAYViewSendNotify(self, @"changeCurrentIndex:", &index)
    //此处index返回值是有意义的：是否有值（是否切换）／NSNumber封装int(0/2)（是否已设置标志）
    
    if(!index) {
        return;
    }
    
    btn.states = WeekDayBtnStateSelected;
    noteBtn.states = index.intValue;
    noteBtn = btn;
	
	[UIView animateWithDuration:0.25 animations:^{
		[currentSign mas_updateConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(btnSpaceW * (btn.tag + 1) - btnSpaceW * 0.5);
		}];
		[self layoutIfNeeded];
	}];
}

#pragma mark -- ollectionViewDelegate
- (AYCalendarDate*)useTime {
	if (!_useTime) {
		_useTime = [[AYCalendarDate alloc]init];
	}
	return _useTime;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 12;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSString *strYear = [NSString stringWithFormat:@"%ld", (section+[self.useTime getMonth]-1) / 12 + [_useTime getYear]];
	NSString *strMonth = [NSString stringWithFormat:@"%02ld", (section+[self.useTime getMonth]-1) % 12 +1];
	//每个月的第一天
	NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01", strYear, strMonth];
	
	return [self.useTime timeFewWeekInMonth:dateStr] * 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYSpecialDayCellView *cell = (AYSpecialDayCellView *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AYSpecialDayCellView" forIndexPath:indexPath];
	
	//每个月的第一天
	NSString *dateStr = [self getDateStrForSection:indexPath.section day:1];
	//获得这个月的天数
	NSInteger monthNumber = [self.useTime timeNumberOfDaysInString:dateStr];
	//获得这个月第一天是星期几
	NSInteger dayOfWeek = [self.useTime timeMonthWeekDayOfFirstDay:dateStr];
	
	NSInteger firstCorner = dayOfWeek;
	NSInteger lastConter = dayOfWeek + monthNumber - 1;
	if (indexPath.item < firstCorner || indexPath.item > lastConter) {
		cell.hidden = YES;
	} else {
		NSInteger day = indexPath.item - firstCorner+1;
		NSString *cellDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", indexPath.section/12 + [_useTime getYear], indexPath.section%12 + 1, (long)day];
		NSDate *cellDate = [_useTime strToDate:cellDateStr];
		NSTimeInterval cellTimeSpan = cellDate.timeIntervalSince1970;
		
		NSDate *today = [_useTime strToDate:currentDate];
		NSTimeInterval todayTimeSpan = today.timeIntervalSince1970;
		
		cell.day = day;
		cell.timeSpan = cellTimeSpan;
		
		if (todayTimeSpan > cellTimeSpan) {
			
		}
	}
	return cell;
}

//获得据section／cell的完整日期
- (NSString *)getDateStrForSection:(NSInteger)section day:(NSInteger)day {
	return [NSString stringWithFormat:@"%ld-%ld-%ld", (section+[self.useTime getMonth]-1)/12 + [_useTime getYear], (section+[self.useTime getMonth]-1)%12+1, day];
}

//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AYSpecialDayHeader" forIndexPath:indexPath];
		
		UILabel *label = [headerView viewWithTag:119];
		if (label == nil) {
			//添加日期
			label = [Tools creatUILabelWithText:nil andTextColor:[Tools blackColor] andFontSize:620.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
			label.tag = 119;
			[headerView addSubview:label];
			[label mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerY.equalTo(headerView);
				make.left.equalTo(headerView).offset(13);
			}];
		}
		
		//设置属性
		label.text = [NSString stringWithFormat:@"%ld年 %02ld月", (indexPath.section+([self.useTime getMonth]))/12 + [_useTime getYear], (indexPath.section+[self.useTime getMonth]-1) % 12 +1];
		return headerView;
	}
	return nil;
}

//设置header的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	
	CGFloat width = SCREEN_WIDTH - 40;
	return (CGSize){width, width / 7};
}

#pragma mark -- cell点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//	AYSpecialDayCellView * cell = (AYSpecialDayCellView *)[collectionView cellForItemAtIndexPath:indexPath];
//	if (cell.isGone) {
//		return ;
//	}
//	//	cell.isLightColor = YES;
//	NSTimeInterval time_p = cell.timeSpan;
//	NSNumber *tmp = [NSNumber numberWithDouble:time_p];
//	kAYViewSendNotify(self, @"didSelectItemAtIndexPath:", &tmp)
	
}
@end
