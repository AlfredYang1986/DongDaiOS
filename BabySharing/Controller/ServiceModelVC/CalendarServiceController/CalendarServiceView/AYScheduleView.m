//
//  AYScheduleView.m
//  BabySharing
//
//  Created by Alfred Yang on 2/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYScheduleView.h"
#import "AYCommandDefines.h"
#import "AYCalendarCellView.h"

#import "AYCalendarDate.h"
#import "AYDayCollectionCellView.h"

#define WIDTH               (self.frame.size.width - 30)
#define HEIGHT              self.frame.size.height
#define MARGIN              10.f
#define COLLECTIONROWNUMB   7

@interface AYScheduleView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic,assign) int year;
@property(nonatomic,assign) int month;
@property(nonatomic,assign) int day;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UICollectionView *calendarContentView;

//@property(nonatomic,copy) NSMutableArray *registerArr;

/** 公历某个月的天数 */
@property (nonatomic, assign) NSInteger monthNumber;
/** 某天是星期几 */
@property (nonatomic, assign) NSInteger dayOfWeek;
/** 月日，星期几 */
@property (nonatomic, strong) NSMutableArray *monthNumberAndWeek;
/** 处理时间的方法 */
@property (nonatomic, strong) AYCalendarDate *useTime;
@end

@implementation AYScheduleView {
    NSMutableArray *selectedItemArray;
    NSMutableArray *timeSpanArray;
    
    NSString *currentDate;
    AYCalendarCellView *tmp;
    
    UILabel *tips;
//    long noteTest;
}

@synthesize headerView = _headerView;
@synthesize calendarContentView = _calendarContentView;

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (AYCalendarDate*)useTime {
    if (!_useTime) {
        _useTime = [[AYCalendarDate alloc]init];
    }
    return _useTime;
}

#pragma mark -- life cycle
- (void)postPerform {
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    
    selectedItemArray = [[NSMutableArray alloc]init];
    timeSpanArray = [[NSMutableArray alloc]init];
    
    [self addCollectionView];
    NSDate *current = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    currentDate = [formatter stringFromDate:current];
}

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

#pragma mark -- Tools
#pragma mark -- layout
-(void)layoutSubviews{
    [super layoutSubviews];
    
}


#pragma mark -- actions
//- (void)didCertainBtnClick {
//    
//    abilityDate.center = CGPointMake(abilityDate.center.x, abilityDate.center.y - 40);
//    abilityTips.center = CGPointMake(abilityTips.center.x, abilityTips.center.y - 40);
//    resetBtn.center = CGPointMake(resetBtn.center.x, resetBtn.center.y - 40);
//    resetBtn.hidden = NO;
//}

//- (void)didResetBtnClick {
////    [_calendarContentView deselectItemAtIndexPath:@[] animated:YES];
//    for (int i = 0; i < selectedItemArray.count; ++i) {
//        [_calendarContentView deselectItemAtIndexPath:[selectedItemArray objectAtIndex:i] animated:NO];
//    }
//    
//    [selectedItemArray removeAllObjects];
//    [timeSpanArray removeAllObjects];
//    abilityDate.text = @"暂未选择日程";
//    tips.hidden = NO;
//    dateOptionView.center = CGPointMake(SCREEN_WIDTH * 1.5, dateOptionView.center.y);
//    
//    abilityDate.center = CGPointMake(abilityDate.center.x, abilityDate.center.y + 40);
//    abilityTips.center = CGPointMake(abilityTips.center.x, abilityTips.center.y + 40);
//    resetBtn.center = CGPointMake(resetBtn.center.x, resetBtn.center.y + 40);
//    resetBtn.hidden = YES;
//}

- (void)getClickDate:(AYCalendarCellView*)view {
    if (tmp) {
        tmp.backgroundColor = [UIColor clearColor];
        if ([tmp.numLabel.text isEqualToString:[NSString stringWithFormat:@"%d",self.day]]) {
            tmp.numLabel.textColor = [Tools themeColor];
        }
        else {
            tmp.numLabel.textColor = [UIColor blackColor];
        }
    }
    view.numLabel.textColor = [UIColor whiteColor];
    view.backgroundColor = [Tools themeColor];
    tmp = view;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [format dateFromString:view.dateString];
    
    NSDateFormatter *unformat = [[NSDateFormatter alloc] init];
    [unformat setDateFormat:@"MM月dd日 EEEE"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [unformat setTimeZone:timeZone];
    NSString *undate = [unformat stringFromDate:startDate];
    id<AYCommand> cmd = [self.notifies objectForKey:@"changeNavTitle:"];
    if (view == nil) {
        NSDate *todayDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM月dd日 EEEE"];
        NSString* title = [formatter stringFromDate:todayDate];
        [cmd performWithResult:&title];
    } else [cmd performWithResult:&undate];
    
}

#pragma mark -- commands
-(id)queryFiterArgs:(NSDictionary*)args{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
//    
//    NSString *plan_time_post = [NSString stringWithFormat:@"%@ %@",theDayDate,choocePostTime.text];
//    NSDate *startDate = [format dateFromString:plan_time_post];
//    NSTimeInterval start = startDate.timeIntervalSince1970;
//    
//    NSString *plan_time_get = [NSString stringWithFormat:@"%@ %@", theDayDate,chooceGetTime.text];//2016-06-18 3:45.AM
//    NSDate *endDate = [format dateFromString:plan_time_get];
//    NSTimeInterval end = endDate.timeIntervalSince1970; //s
//    
//    [dic setValue:theDayDate forKey:@"plan_date"];
//    [dic setValue:[NSNumber numberWithDouble:start] forKey:@"plan_time_post"];
//    [dic setValue:[NSNumber numberWithDouble:end] forKey:@"plan_time_get"];
//    
    return nil;
}

- (id)queryUnavluableDate:(NSArray*)args {
    
    return [timeSpanArray copy];
}

- (id)changeQueryData:(id)args {
    
    return nil;
}

#pragma mark -- scrollView delegate

- (void)addCollectionView{
    NSArray *titleArr = [NSArray arrayWithObjects:@"日", @"一",@"二",@"三",@"四",@"五",@"六",nil];
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, WIDTH, 30)];
    [self addSubview:_headerView];
    
    CGFloat labelWidth = (WIDTH - 30)/7;
    for (int i = 0; i<7; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*labelWidth + 15, 0, labelWidth, 30)];
        label = [Tools setLabelWith:label andText:[titleArr objectAtIndex:i] andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [_headerView addSubview:label];
    }
    
    /******************/
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat wh = (WIDTH - 30) / 7;
    layout.itemSize = CGSizeMake(wh, wh);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _calendarContentView = [[UICollectionView alloc]initWithFrame:CGRectMake(30, 30, WIDTH - 30, (WIDTH - 30)/7*COLLECTIONROWNUMB) collectionViewLayout:layout];
    _calendarContentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_calendarContentView];
    _calendarContentView.delegate = self;
    _calendarContentView.dataSource = self;
    _calendarContentView.allowsMultipleSelection = YES;
    _calendarContentView.showsVerticalScrollIndicator = NO;
    
    CALayer *line_separator = [CALayer layer];
    line_separator.frame = CGRectMake(0, 29.5, SCREEN_WIDTH, 0.5);
    line_separator.backgroundColor = [Tools garyLineColor].CGColor;
    [self.layer addSublayer:line_separator];
    
    [_calendarContentView registerClass:[AYDayCollectionCellView class] forCellWithReuseIdentifier:@"AYDayCollectionCellView"];
    //注册头部
    [_calendarContentView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AYDayCollectionHeader"];
    
    [self refreshScrollPositionCurrentDate];
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, (WIDTH - 30)/7*COLLECTIONROWNUMB + 30, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools garyLineColor].CGColor;
    [self.layer addSublayer:line];
    
    tips = [[UILabel alloc]init];
    [self addSubview:tips];
    tips = [Tools setLabelWith:tips andText:@"点击日期\n选择您不可以提供服务的时间" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:1];
    tips.numberOfLines = 0;
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_calendarContentView.mas_bottom).offset(80);
        make.centerX.equalTo(self);
    }];
    
}

#pragma mark -- UICollectionViewDataSource
- (void)refreshScrollPositionCurrentDate {
    NSDate *Date = [[NSDate alloc]init];
    NSArray *calendar = [[self.useTime dataToString:Date] componentsSeparatedByString:@"-"];
    [self refreshControlWithYear:calendar[0] month:calendar[1] day:calendar[2]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (2101-[_useTime getYear]) * 12 - [_useTime getMonth];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //每个月的第一天
    NSString *strYear = [NSString stringWithFormat:@"%ld", section / 12 + [_useTime getYear]];
    NSString *strMonth = [NSString stringWithFormat:@"%ld", section % 12 + 1];
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01", strYear, strMonth];
    
    return [self.useTime timeFewWeekInMonth:dateStr] * 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AYDayCollectionCellView *cell = (AYDayCollectionCellView *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AYDayCollectionCellView" forIndexPath:indexPath];
    
    //每个月的第一天
    NSString *dateStr = [self getDateStrForSection:indexPath.section day:1];
    //获得这个月的天数
    self.monthNumber = [self.useTime timeNumberOfDaysInString:dateStr];
    //获得这个月第一天是星期几
    self.dayOfWeek = [self.useTime timeMonthWeekDayOfFirstDay:dateStr];
    
    NSInteger firstCorner = self.dayOfWeek;
    NSInteger lastConter = self.dayOfWeek + self.monthNumber - 1;
    if (indexPath.item < firstCorner || indexPath.item > lastConter) {
        cell.hidden = YES;
    }else {
        cell.hidden = NO;
        cell.isGone = NO;
        
        NSInteger gregoiain = indexPath.item - firstCorner+1;
        NSString *cellDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", indexPath.section/12 + [_useTime getYear], indexPath.section%12 + 1, (long)gregoiain];
        NSDate *cellDate = [_useTime strToDate:cellDateStr];
        NSTimeInterval cellData = cellDate.timeIntervalSince1970;
        NSDate *today = [_useTime strToDate:currentDate];
        NSTimeInterval todayData = today.timeIntervalSince1970;
        
        if (cellData < todayData) {
            cell.isGone = YES;
        }
        //阳历
        cell.gregoiainDay = [NSString stringWithFormat:@"%ld", gregoiain];
        //日期属性
        cell.timeSpan = cellData;
        cell.gregoiainCalendar = dateStr;
        cell.chineseCalendar = [self.useTime timeChineseCalendarWithString:dateStr];
        
//        CGFloat wh = (WIDTH - 30)/7 - 10;
        UIView *selectBgView = [[UIView alloc] init];
//        selectBgView.backgroundColor = [UIColor colorWithPatternImage:IMGRESOURCE(@"unavilable_bg")];
        selectBgView.layer.contents = (id)IMGRESOURCE(@"unavilable_bg").CGImage;
//        selectBgView.layer.cornerRadius = wh / 2;
//        selectBgView.clipsToBounds = YES;
//        selectBgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        cell.selectedBackgroundView = selectBgView;
    }
    return cell;
}

//获得据section／cell的完整日期
- (NSString *)getDateStrForSection:(NSInteger)section day:(NSInteger)day {
    return [NSString stringWithFormat:@"%ld-%ld-%ld", section/12 + [_useTime getYear], section%12 + 1, day];
}

//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AYDayCollectionHeader" forIndexPath:indexPath];
        
        UILabel *label = [headerView viewWithTag:119];
        if (label == nil) {
            //添加日期
            label = [Tools creatUILabelWithText:nil andTextColor:[Tools blackColor] andFontSize:20.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
            label.tag = 119;
            [headerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(headerView);
                make.centerY.equalTo(headerView);
                make.left.equalTo(headerView).offset(13);
            }];
        }
//        CALayer *spearter = [CALayer layer];
//        spearter.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.f].CGColor;
//        spearter.frame = CGRectMake(0, 8.5, WIDTH - 30, 0.5);
//        [headerView.layer addSublayer:spearter];
        //设置属性
        label.text = [NSString stringWithFormat:@"%ld年 %.2ld月", indexPath.section/12 + [_useTime getYear], indexPath.section % 12 + 1];
        return headerView;
    }
    return nil;
}

//设置header的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return (CGSize){WIDTH, (WIDTH - 30) / COLLECTIONROWNUMB};
}

//cell点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AYDayCollectionCellView * cell = (AYDayCollectionCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isGone) {
        return ;
    }
    
//    NSIndexPath *pre_indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
//    AYDayCollectionCellView * pre_cell = (AYDayCollectionCellView *)[collectionView cellForItemAtIndexPath:pre_indexPath];
//    if (pre_cell.isSelected) {
//        
//        CGFloat wh = (WIDTH - 30)/7;
//        UIView *selectBgView = [[UIView alloc] init];
//        selectBgView.backgroundColor = [Tools garyLineColor];
//        selectBgView.layer.cornerRadius = wh / 2;
//        selectBgView.clipsToBounds = YES;
//        cell.selectedBackgroundView = selectBgView;
//        
////        pre_cell.selectedBackgroundView = selectBgView;
//    }
    
    long time_p = cell.timeSpan;
    [selectedItemArray addObject:indexPath];
    [timeSpanArray addObject:[NSNumber numberWithDouble:time_p]];
    
    [self setAbilityDateTextWith:nil];
    
}

// 反选
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    AYDayCollectionCellView * cell = (AYDayCollectionCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isGone) {
        return ;
    }
    
    long time_p = cell.timeSpan;
    [selectedItemArray removeObject:indexPath];
    [timeSpanArray removeObject:[NSNumber numberWithDouble:time_p]];
    if (timeSpanArray.count == 0) {
        tips.text = @"点击日期\n选择您不可以提供服务的时间";
        return;
    }
    
    [self setAbilityDateTextWith:nil];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AYDayCollectionCellView * cell = (AYDayCollectionCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isGone) {
        return NO;
    } else
        return YES;
}

- (void)refreshControlWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day {
    // 每个月的第一天
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@", year, month, @1];
    // 获得这个月第一天是星期几
    NSInteger dayOfFirstWeek = [_useTime timeMonthWeekDayOfFirstDay:dateStr];
    NSInteger section = (year.integerValue - [_useTime getYear])*12 + (month.integerValue - 1);
    NSInteger item = day.integerValue + dayOfFirstWeek - 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
//    [_calendarContentView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    [_calendarContentView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

- (id)dateScrollToCenter:(NSString*)str {
    str = [str substringToIndex:10];
    NSArray *calendar = [str componentsSeparatedByString:@"年"];
    NSArray *calendar2 = [calendar[1] componentsSeparatedByString:@"月"];
    [self refreshControlWithYear:calendar[0] month:calendar2[0] day:calendar2[1]];
    return nil;
}

- (NSString*)transformTimespanToMouthAndDayWithDate:(NSTimeInterval)timespan {
    
    NSDate *itemDate = [NSDate dateWithTimeIntervalSince1970:timespan];
    NSDateFormatter *unformat = [[NSDateFormatter alloc] init];
    [unformat setDateFormat:@"MM月dd日"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [unformat setTimeZone:timeZone];
    NSString *date_string = [unformat stringFromDate:itemDate];
    
    return date_string;
}

- (void)setAbilityDateTextWith:(NSArray*)array {
    NSArray *tmpTimeArray = [timeSpanArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSTimeInterval first = ((NSNumber*)obj1).longValue;
        NSTimeInterval second = ((NSNumber*)obj2).longValue;
        if (first < second) return  NSOrderedAscending;
        else if (first > second) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    NSString *ability_dateString;
    if (tmpTimeArray.count == 1) {
        long first = ((NSNumber*)[tmpTimeArray firstObject]).longValue;
        NSString *first_string = [self transformTimespanToMouthAndDayWithDate:first];
        
        ability_dateString = [NSString stringWithFormat:@"%@",first_string];
        
    } else if ([self isMilitaryWithArray:tmpTimeArray]) {
        long first = ((NSNumber*)[tmpTimeArray firstObject]).longValue;
        NSString *first_string = [self transformTimespanToMouthAndDayWithDate:first];
        
        long last = ((NSNumber*)[tmpTimeArray lastObject]).longValue;
        NSString *last_string = [self transformTimespanToMouthAndDayWithDate:last];
        
        ability_dateString = [NSString stringWithFormat:@"%@ - %@",first_string, last_string];
        
    } else if (tmpTimeArray.count <= 4) {
        
        ability_dateString = [self transformTimespanToMouthAndDayWithDate:((NSNumber*)[tmpTimeArray objectAtIndex:0]).longValue];
        for (int i = 1; i < (tmpTimeArray.count > 4 ? 4 : tmpTimeArray.count) ; ++i) {
            long timeDate = ((NSNumber*)[tmpTimeArray objectAtIndex:i]).longValue;
            NSString *date_string = [self transformTimespanToMouthAndDayWithDate:timeDate];
            ability_dateString = [ability_dateString stringByAppendingString:[NSString stringWithFormat:@", %@",date_string]];
        }
    } else ability_dateString = @"多个日期";
    
    tips.text = [ability_dateString stringByAppendingString:@"\n暂无法提供服务"];
}

- (BOOL)isMilitaryWithArray:(NSArray*)array {
    
    NSTimeInterval conpare = ((NSNumber*)array.firstObject).longValue;
    for (int i = 1; i < array.count; ++i) {
        NSTimeInterval conpareB = ((NSNumber*)[array objectAtIndex:i]).longValue;
        if ((conpareB - conpare) != 86400) {
            return NO;
        }
        conpare = conpareB;
    }
    return YES;
}

@end
