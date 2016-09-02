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
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

#import "Tools.h"
#import "AYCommandDefines.h"
#import "AYDayCollectionCellView.h"
#import "AYCalendarDate.h"

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define kCalendarWidth          (SCREEN_WIDTH - 30)
#define COLLECTIONROWNUMB       7

#define STATUS_HEIGHT           20
#define NAV_HEIGHT              45

#define TEXT_COLOR              [Tools blackColor]

#define CONTROLLER_MARGIN       10.f

#define FIELD_HEIGHT                        80

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
    
    UILabel* title = [[UILabel alloc]init];
    title = [Tools setLabelWith:title andText:@"日期" andTextColor:TEXT_COLOR andFontSize:24.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(95);
        make.left.equalTo(self.view).offset(15);
    }];
    
    dateLabel = [[UILabel alloc]init];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日, EEEE"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [format setTimeZone:timeZone];
    NSString *dateStr = [format stringFromDate:[NSDate date]];
    
    dateLabel = [Tools setLabelWith:dateLabel andText:dateStr andTextColor:TEXT_COLOR andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
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
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*labelWidth, 0, labelWidth, 30)];
        label.text = [titleArr objectAtIndex:i];
        label.textAlignment = 1;
        label.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
        label.font = [UIFont systemFontOfSize:14.f];
        [headerView addSubview:label];
    }
    CALayer *line_separator = [CALayer layer];
    line_separator.frame = CGRectMake(0, 29, kCalendarWidth, 1);
    line_separator.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
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
        make.size.mas_equalTo(CGSizeMake(kCalendarWidth, kCalendarWidth/7*COLLECTIONROWNUMB));
    }];
    _calendarContentView.backgroundColor = [UIColor clearColor];
    _calendarContentView.delegate = self;
    _calendarContentView.dataSource = self;
    _calendarContentView.allowsMultipleSelection = NO;
    _calendarContentView.showsVerticalScrollIndicator = NO;
    
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

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, STATUS_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, STATUS_HEIGHT + 10, SCREEN_WIDTH, NAV_HEIGHT);
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
    
    if (dateDataNote != 0) {
        id<AYCommand> cmd = POPSPLIT;
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPopSplitValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic setValue:[NSNumber numberWithDouble:dateDataNote] forKey:kAYControllerChangeArgsKey];
        [dic setValue:dic_split_value forKey:kAYControllerSplitValueKey];
//        id<AYCommand> cmd = POP;
        [cmd performWithResult:&dic];
    }
}

#pragma mark -- commands
- (id)leftBtnSelected {
    id<AYCommand> cmd = POPSPLIT;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopSplitValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:dic_split_value forKey:kAYControllerSplitValueKey];
    [cmd performWithResult:&dic];
    return nil;
}

#pragma mark -- UICollectionViewDataSource
-(void)refreshScrollPositionCurrentDate {
    NSDate *Date = [[NSDate alloc]init];
    NSArray *calendar = [[self.useTime dataToString:Date] componentsSeparatedByString:@"-"];
    [self refreshControlWithYear:calendar[0] month:calendar[1] day:calendar[2]];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (2101-[_useTime getYear]) * 12 - [_useTime getMonth];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //每个月的第一天
    NSString *strYear = [NSString stringWithFormat:@"%ld", section / 12 + [_useTime getYear]];
    NSString *strMonth = [NSString stringWithFormat:@"%ld", section % 12 + 1];
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01", strYear, strMonth];
    
    return [self.useTime timeFewWeekInMonth:dateStr] * 7;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
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
        
        CGFloat wh = kCalendarWidth/7;
        UIView *selectBgView = [[UIView alloc] initWithFrame:CGRectMake(9, 0, wh, wh)];
        selectBgView.backgroundColor = [Tools themeColor];
        selectBgView.layer.cornerRadius = wh / 2;
        selectBgView.clipsToBounds = YES;
        cell.selectedBackgroundView = selectBgView;
    }
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
        
        UILabel *label = [headerView viewWithTag:11];
        if (label == nil) {
            //添加日期
            label = [[UILabel alloc] init];
            label.tag = 11;
            label.textColor = [Tools themeColor];
            [headerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(headerView);
                make.left.equalTo(headerView).offset(13);
            }];
        }
        CALayer *spearter = [CALayer layer];
        spearter.backgroundColor = [Tools garyLineColor].CGColor;
        spearter.frame = CGRectMake(0, 0, kCalendarWidth, 0.5);
        [headerView.layer addSublayer:spearter];
        //设置属性
        label.text = [NSString stringWithFormat:@"%ld月 %ld年", indexPath.section % 12 + 1, indexPath.section/12 + [_useTime getYear]];
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
    if (cell.isGone) {
        return ;
    }
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
    
    [_calendarContentView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
//    [_calendarContentView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
    NSDate *today = [_useTime strToDate:currentDate];
    dateDataNote = today.timeIntervalSince1970;
}

@end
