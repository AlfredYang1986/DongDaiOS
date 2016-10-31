//
//  AYLocationResultController.m
//  BabySharing
//
//  Created by Alfred Yang on 2/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSearchFilterDateController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"

#import "AYCommandDefines.h"
#import "AYDayCollectionCellView.h"
#import "AYCalendarDate.h"

#define kCalendarWidth          (SCREEN_WIDTH - 30)
#define COLLECTIONROWNUMB       7
#define operableWeeksLimit        1

#define STATUS_HEIGHT           20
#define NAV_HEIGHT              45
#define TEXT_COLOR              [Tools blackColor]
#define CONTROLLER_MARGIN       10.f
#define FIELD_HEIGHT                        80

static NSString* const initDateStr =                @"暂未选择日期";

@interface AYSearchFilterDateController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *calendarContentView;
/** 公历某个月的天数 */
@property (nonatomic, assign) NSInteger monthNumber;
/** 某天是星期几 */
@property (nonatomic, assign) NSInteger dayOfWeek;
/** 月日，星期几 */
@property (nonatomic, strong) NSMutableArray *monthNumberAndWeek;
/** 处理时间的方法 */
@property (nonatomic, strong) AYCalendarDate *useTime;
@end

@implementation AYSearchFilterDateController {
    UILabel *dateLabel;
    NSString *currentDate;
    NSTimeInterval dateDataNote;
    
    id dic_split_value;
    NSArray *service_offer_date;
    
    NSMutableArray *unavilableItemArr;
}

- (AYCalendarDate*)useTime {
    if (!_useTime) {
        _useTime = [[AYCalendarDate alloc]init];
    }
    return _useTime;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        dic_split_value = [dic objectForKey:kAYControllerSplitValueKey];
        service_offer_date = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!unavilableItemArr) {
        unavilableItemArr = [NSMutableArray array];
    }
    dateDataNote = 0;
    
    UILabel* title = [[UILabel alloc]init];
    title = [Tools setLabelWith:title andText:@"日期" andTextColor:TEXT_COLOR andFontSize:24.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(95);
        make.left.equalTo(self.view).offset(15);
    }];
    
    dateLabel = [[UILabel alloc]init];
    
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy年MM月dd日, EEEE"];
//    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
//    [format setTimeZone:timeZone];
//    NSString *dateStr = [format stringFromDate:[NSDate date]];
    
    dateLabel = [Tools setLabelWith:dateLabel andText:initDateStr andTextColor:TEXT_COLOR andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(15);
        make.left.equalTo(title);
    }];
    
    /**
     * 日程
     */
    NSArray *titleArr = [NSArray arrayWithObjects:@"日", @"一",@"二",@"三",@"四",@"五",@"六",nil];
    UIView *headerView = [[UIView alloc]init];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(25);
        make.left.equalTo(self.view).offset(15);
        make.size.mas_equalTo(CGSizeMake(kCalendarWidth, 30));
    }];
    
    CGFloat labelWidth = kCalendarWidth/7;
    for (int i = 0; i<7; i++) {
        UILabel *label = [Tools creatUILabelWithText:[titleArr objectAtIndex:i] andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:1];
        label.frame = CGRectMake(i*labelWidth, 0, labelWidth, 30);
        [headerView addSubview:label];
    }
    CALayer *line_separator = [CALayer layer];
    line_separator.frame = CGRectMake(0, 29.5, kCalendarWidth, 0.5);
    line_separator.backgroundColor = [Tools garyLineColor].CGColor;
    [headerView.layer addSublayer:line_separator];
    
    NSDate *current = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    currentDate = [formatter stringFromDate:current];
    
    /******************/
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat wh = kCalendarWidth / 7;
    layout.itemSize = CGSizeMake(wh, wh);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _calendarContentView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(headerView.frame), kCalendarWidth, kCalendarWidth/7*COLLECTIONROWNUMB) collectionViewLayout:layout];
    [self.view addSubview:_calendarContentView];
    [_calendarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(0);
        make.left.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(kCalendarWidth, kCalendarWidth / 7 * COLLECTIONROWNUMB));
    }];
    _calendarContentView.backgroundColor = [UIColor clearColor];
    _calendarContentView.delegate = self;
    _calendarContentView.dataSource = self;
    _calendarContentView.allowsMultipleSelection = NO;
    _calendarContentView.showsVerticalScrollIndicator = NO;
//    _calendarContentView.allowsMultipleSelection = YES;
    
    [_calendarContentView registerClass:[AYDayCollectionCellView class] forCellWithReuseIdentifier:@"AYDayCollectionCellView"];
    //注册头部
    [_calendarContentView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AYDayCollectionHeader"];
    [self refreshScrollPositionCurrentDate];
    
    /**
     * 保存按钮
     */
    UIButton* btn = [[UIButton alloc]init];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(10, SCREEN_HEIGHT - 10 - 45, SCREEN_WIDTH - 2 * 10, 45);
    btn.backgroundColor = [Tools themeColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.layer setCornerRadius:4.f];
    [btn addTarget:self action:@selector(saveBtnSelected) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, STATUS_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, STATUS_HEIGHT, SCREEN_WIDTH, NAV_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    
    {
        UIImage* img = IMGRESOURCE(@"content_close");
        id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"setLeftBtnImg:"];
        [cmd performWithResult:&img];
    }
    
    return nil;
}

#pragma mark -- actions
- (void)saveBtnSelected {
    
    if (service_offer_date) {
        
        if (dateDataNote == 0) {
            NSString *title = @"您还没有选择日期";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            return;
        }
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
        [dic_args setValue:[NSNumber numberWithDouble:dateDataNote] forKey:@"order_date"];
        [dic setValue:dic_args forKey:kAYControllerChangeArgsKey];
        id<AYCommand> cmd = POP;
        [cmd performWithResult:&dic];
    } else {
        
        id<AYCommand> cmd = POPSPLIT;
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPopSplitValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
        [dic_args setValue:[NSNumber numberWithDouble:dateDataNote] forKey:@"filter_date"];
        [dic setValue:dic_args forKey:kAYControllerChangeArgsKey];
        [dic setValue:dic_split_value forKey:kAYControllerSplitValueKey];
        
        [cmd performWithResult:&dic];
    }
}

#pragma mark -- commands
- (id)leftBtnSelected {
    
    if (service_offer_date) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        
        id<AYCommand> cmd = POP;
        [cmd performWithResult:&dic];
    } else {
        id<AYCommand> cmd = POPSPLIT;
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPopSplitValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic setValue:dic_split_value forKey:kAYControllerSplitValueKey];
        [cmd performWithResult:&dic];
    }
    
    return nil;
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
    }
    else {
        cell.hidden = NO;
        cell.isGone = NO;
        
        NSInteger gregoiain = indexPath.item - firstCorner+1;
        NSString *cellDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", indexPath.section/12 + [_useTime getYear], indexPath.section%12 + 1, (long)gregoiain];
        NSDate *cellDate = [_useTime strToDate:cellDateStr];
        NSTimeInterval cellData = cellDate.timeIntervalSince1970;
        
        UIView *selectBgView = [[UIView alloc] init];
        selectBgView.layer.contents = (id)IMGRESOURCE(@"date_seted_sign").CGImage;
        cell.selectedBackgroundView = selectBgView;
        
        NSDate *today = [_useTime strToDate:currentDate];
        NSTimeInterval todayData = today.timeIntervalSince1970;
        NSTimeInterval twoWeeksLater = todayData + operableWeeksLimit * 7 * 86400;
        
        cell.backgroundView = nil;
        if (todayData == cellData) {
            UIView *todayBgView = [[UIView alloc] init];
            todayBgView.layer.contents = (id)IMGRESOURCE(@"date_today_sign").CGImage;
            cell.backgroundView = todayBgView;
        }
        
        if (cellData < todayData || cellData >= twoWeeksLater) {
            cell.isGone = YES;
        }
        else {
            
            if (service_offer_date) {
                NSMutableArray *compare = [NSMutableArray arrayWithObjects:@0, @1, @2, @3, @4, @5, @6, nil];
                for (NSDictionary *day_times in service_offer_date) {
                    NSArray *occurance = [day_times objectForKey:@"occurance"];
                    if (occurance) {
                        [compare removeObject:[day_times objectForKey:@"day"]];
                    }
                }
                
                int weekd = indexPath.row % 7;
                if ([[compare copy] containsObject:[NSNumber numberWithInt:weekd]]) {
                    [unavilableItemArr addObject:indexPath];
                    UIView *unavilabelBgView = [[UIView alloc] init];
                    unavilabelBgView.layer.contents = (id)IMGRESOURCE(@"unavilable_bg").CGImage;
                    cell.backgroundView = unavilabelBgView;
                }
                
            }
        }//
        
        //阳历
        cell.gregoiainDay = [NSString stringWithFormat:@"%ld", gregoiain];
        //日期属性
        cell.timeSpan = cellData;
        cell.gregoiainCalendar = dateStr;
        cell.chineseCalendar = [self.useTime timeChineseCalendarWithString:dateStr];
    }// end if : hidden = no
    return cell;
}
//获得据section／cell的完整日期
-(NSString *)getDateStrForSection:(NSInteger)section day:(NSInteger)day{
    return [NSString stringWithFormat:@"%ld-%ld-%ld", section/12 + [_useTime getYear], section%12 + 1, day];
}

//header
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AYDayCollectionHeader" forIndexPath:indexPath];
        
        UILabel *label = [headerView viewWithTag:119];
        if (label == nil) {
            //添加日期
            label = [Tools creatUILabelWithText:nil andTextColor:[Tools themeColor] andFontSize:20.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
            label.tag = 119;
            [headerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView);
                make.left.equalTo(headerView).offset(13);
            }];
        }
        
        //设置属性
        label.text = [NSString stringWithFormat:@"%ld年 %ld月", indexPath.section/12 + [_useTime getYear], indexPath.section % 12 + 1];
        return headerView;
    }
    return nil;
}

//设置header的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return (CGSize){kCalendarWidth, kCalendarWidth / COLLECTIONROWNUMB};
}

//cell点击
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AYDayCollectionCellView * cell = (AYDayCollectionCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    dateDataNote = cell.timeSpan;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日, EEEE"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [format setTimeZone:timeZone];
    
    NSDate *today = [NSDate dateWithTimeIntervalSince1970:dateDataNote];
    NSString *dateStr = [format stringFromDate:today];
    dateLabel.text = dateStr;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AYDayCollectionCellView * cell = (AYDayCollectionCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isGone || [unavilableItemArr containsObject:indexPath]) {
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
    
//    NSDate *today = [_useTime strToDate:currentDate];
//    dateDataNote = today.timeIntervalSince1970;
}

@end
