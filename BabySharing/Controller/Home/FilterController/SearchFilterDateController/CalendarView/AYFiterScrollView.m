//
//  AYCalendarView.m
//  BabySharing
//
//  Created by Alfred Yang on 2/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFiterScrollView.h"
#import "AYCommandDefines.h"
#import "AYCalendarCellView.h"

#import "AYCalendarDate.h"
#import "AYDayCollectionCellView.h"


#define WIDTH               (self.frame.size.width - 30)
#define HEIGHT              self.frame.size.height
#define MARGIN              10.f

@interface AYFiterScrollView ()<UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,assign) int year;
@property(nonatomic,assign) int searchYear;
@property(nonatomic,assign) int month;
@property(nonatomic,assign) int searchMonth;
@property(nonatomic,assign) int day;
@property(nonatomic,assign) int searchDay;
@property(nonatomic,assign) int daysOfMonth;
@property(nonatomic,assign) int searchDaysOfMonth;

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UICollectionView *calendarContentView;
@property (nonatomic, strong) UIView *planDateView;
@property (nonatomic, strong) UIView *chilrenNumbView;
@property (nonatomic, strong) UIButton *moreFilterBtn;

@property(nonatomic,copy) NSMutableArray *registerArr;

/** 公历某个月的天数 */
@property (nonatomic, assign) NSInteger monthNumber;
/** 某天是星期几 */
@property (nonatomic, assign) NSInteger dayOfWeek;

/** 月日，星期几 */
@property (nonatomic, strong) NSMutableArray *monthNumberAndWeek;

/** 处理时间的方法 */
@property (nonatomic, strong) AYCalendarDate *useTime;
@end

@implementation AYFiterScrollView{
    UILabel *didStarPlanTime;
    UILabel *choocePostTime;
    UILabel *chooceGetTime;
    CGFloat optionDateCount;
    UIView *alockOptionView;
    UIPickerView *alockPickerView;
    UILabel *chilrenCountLabel;
    int sumChilrenCount;
    NSString *theDayDate;
    NSString *currentDate;
    int numbOfCurrentDay;
    
    AYCalendarCellView *tmp;
    CGFloat sumHeight;
    
    BOOL isPostClick;
    NSArray *ons;
    NSArray *hours;
    NSArray *minis;
    NSString *on;
    NSString *hour;
    NSString *mini;
    
    BOOL isSetPost;
    BOOL isSetGet;
    UIView *PostTimeView;
    UIView *GetTimeView;
}

@synthesize headerView = _headerView;
@synthesize calendarContentView = _calendarContentView;
@synthesize planDateView = _planDateView;
@synthesize chilrenNumbView = _chilrenNumbView;
@synthesize moreFilterBtn = _moreFilterBtn;

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

-(AYCalendarDate*)useTime{
    if (!_useTime) {
        _useTime = [[AYCalendarDate alloc]init];
    }
    return _useTime;
}

-(NSMutableArray*)registerArr{
    if (!_registerArr) {
        _registerArr=[[NSMutableArray alloc]init];
    }
    return _registerArr;
}

#pragma mark -- life cycle
- (void)postPerform {
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    sumHeight = 140;
    ons = @[@"AM", @"PM"];
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
    for (long i = 0; i< 24*50; ++i) {
        int tmpInt = i % 24;
        [tmpArr addObject:[NSString stringWithFormat:@"%.2d",tmpInt]];
    }
    hours = [tmpArr copy];
    
    NSMutableArray *tmpArr2 = [[NSMutableArray alloc]init];
    for (int i = 0; i< 50; ++i) {
        [tmpArr2 addObject:[NSString stringWithFormat:@"%.2d",00]];
        [tmpArr2 addObject:[NSString stringWithFormat:@"%.2d",15]];
        [tmpArr2 addObject:[NSString stringWithFormat:@"%.2d",30]];
        [tmpArr2 addObject:[NSString stringWithFormat:@"%.2d",45]];
    }
    minis = [tmpArr2 copy];
    self.delegate = self;
    
    [self addCollectionView];
    [self addplanDateView];
    [self addAlockOptionView];
    //    [self addChilrenNumbView];
    
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

-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentSize = CGSizeMake(WIDTH, 560);
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            [alockPickerView selectRow:1200/2 inComponent:i animated:NO];
        } else [alockPickerView selectRow:200/2 inComponent:i animated:NO];
    }
}

#pragma mark- 设置pickView数据
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    if (component == 0) {
//        return ons.count;
//    }
//    else
    if(component == 0){
        return hours.count;
    } else
        return minis.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if (component == 0) {
//        return ons[row];
//    }else
    if (component == 0){
        return hours[row];
    } else
        return minis[row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SCREEN_WIDTH * 0.5;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component == 0){
        hour = hours[row];
    } else
        mini = minis[row];
}

#pragma mark -- layout
-(void)addChilrenNumbView{
    _chilrenNumbView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_planDateView.frame) + 10, WIDTH, 70/*70*/)];
    _chilrenNumbView.backgroundColor = [UIColor whiteColor];
    _chilrenNumbView.layer.cornerRadius =3.f;
    _chilrenNumbView.clipsToBounds = YES;
    [self addSubview:_chilrenNumbView];
    sumChilrenCount = 1;
    chilrenCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 110, 70)];
    chilrenCountLabel.text = [NSString stringWithFormat:@"%d 个小孩",sumChilrenCount];
    [_chilrenNumbView addSubview:chilrenCountLabel];
    
    UIImageView *plusCountBtn = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 15 - 110, 13, 110, 45)];
    plusCountBtn.image = [UIImage imageNamed:@"icon_pick_selected"];
    [_chilrenNumbView addSubview:plusCountBtn];
    plusCountBtn.userInteractionEnabled = YES;
    [plusCountBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPlusbtnClick:)]];
}

- (void)addAlockOptionView{
    
    alockOptionView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_planDateView.frame), WIDTH, 0)];
    UIButton *save = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 50 - 10, 8, 50, 14)];
    [save setBackgroundColor:[UIColor clearColor]];
    [save setTitle:@"完成" forState:UIControlStateNormal];
    save.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [save setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(didSaveTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [alockOptionView addSubview:save];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(10, 8, 50, 14)];
    [cancel setBackgroundColor:[UIColor clearColor]];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancel setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(didCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [alockOptionView addSubview:cancel];
    
    CALayer *line_separator = [CALayer layer];
    line_separator.borderColor = [UIColor colorWithWhite:0.7922 alpha:1.f].CGColor;
    line_separator.borderWidth = 0.5f;
    line_separator.frame = CGRectMake(0, 29, WIDTH, 1);
    [alockOptionView.layer addSublayer:line_separator];
    
    alockPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, WIDTH, 162)];
    alockOptionView.clipsToBounds = YES;
    [self addSubview:alockOptionView];
    [alockOptionView addSubview:alockPickerView];
    alockPickerView.delegate = self;
    alockPickerView.dataSource = self;
}

- (void)addplanDateView {
    _planDateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_calendarContentView.frame) + 10, SCREEN_WIDTH, 80)];
    _planDateView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_planDateView];
    
    CALayer *line_top = [CALayer layer];
    line_top.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    line_top.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [_planDateView.layer addSublayer:line_top];
    CALayer *line_bottom = [CALayer layer];
    line_bottom.frame = CGRectMake(0, 79, SCREEN_WIDTH, 1);
    line_bottom.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [_planDateView.layer addSublayer:line_bottom];
    
    CALayer *line_separator = [CALayer layer];
    line_separator.borderColor = [UIColor colorWithWhite:0.5922 alpha:1.f].CGColor;
    line_separator.borderWidth = 1.f;
    line_separator.frame = CGRectMake(SCREEN_WIDTH * 0.5, 10, 1, 60);
    [_planDateView.layer addSublayer:line_separator];
    
    PostTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH *0.5, 80)];
    [_planDateView addSubview:PostTimeView];
    
    CATextLayer *postTitle = [CATextLayer layer];
    postTitle.frame = CGRectMake(0, 10, SCREEN_WIDTH * 0.5, 20);
    postTitle.string = @"预计开始时间";
    postTitle.fontSize = 14.f;
    postTitle.foregroundColor = [UIColor blackColor].CGColor;
    postTitle.alignmentMode = @"center";
    postTitle.contentsScale = 2.f;
    [PostTimeView.layer addSublayer:postTitle];
    
    choocePostTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH * 0.5, 25)];
    choocePostTime.text = @"00:00";
    choocePostTime.font = [UIFont systemFontOfSize:25.f];
    choocePostTime.textColor = [Tools themeColor];
    choocePostTime.textAlignment = NSTextAlignmentCenter;
    [PostTimeView addSubview:choocePostTime];
    [PostTimeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didChoocePostTime:)]];
    
    /* get */
    GetTimeView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *0.5, 5, SCREEN_WIDTH *0.5, 80)];
    [_planDateView addSubview:GetTimeView];
    CATextLayer *getTitle = [CATextLayer layer];
    getTitle.frame = CGRectMake(0, 10, SCREEN_WIDTH * 0.5, 20);
    getTitle.string = @"预计结束时间";
    getTitle.fontSize = 14.f;
    getTitle.foregroundColor = [UIColor blackColor].CGColor;
    getTitle.alignmentMode = @"center";
    getTitle.contentsScale = 2.f;
    [GetTimeView.layer addSublayer:getTitle];
    
    chooceGetTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH * 0.5, 25)];
    chooceGetTime = [Tools setLabelWith:chooceGetTime andText:@"00:00" andTextColor:[Tools themeColor] andFontSize:25.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [GetTimeView addSubview:chooceGetTime];
    [GetTimeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didChooceGetTime:)]];
}

- (void)addHeaderView{
    NSArray *titleArr = [NSArray arrayWithObjects:@"日", @"一",@"二",@"三",@"四",@"五",@"六",nil];
//    [_headerView removeFromSuperview];
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    [_calendarContentView addSubview:self.headerView];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    [_headerView addSubview:titleView];
    CGFloat labelWidth = (WIDTH)/7;
    for (int i = 0; i<7; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*labelWidth+3, 0, labelWidth, 30)];
        label.text = [titleArr objectAtIndex:i];
        label.textAlignment = 1;
        label.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
        label.font = [UIFont systemFontOfSize:14.f];
        [titleView addSubview:label];
    }
    CALayer *line_separator = [CALayer layer];
    line_separator.frame = CGRectMake(0, 29, WIDTH, 1);
    line_separator.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [_headerView.layer addSublayer:line_separator];
}

#pragma mark -- actions
- (void)didSaveTimeBtnClick{
//    if (!on || [on isEqualToString:@""]) {
//        on = ons[0];
//    }
    if (!hour || [hour isEqualToString:@""]) {
        hour = hours[0];
    }
    if (!mini || [mini isEqualToString:@""]) {
        mini = minis[0];
    }
    
    if (isPostClick) {
        choocePostTime.text = [NSString stringWithFormat:@"%@:%@",hour,mini];
        isSetPost = YES;
    } else {
        chooceGetTime.text = [NSString stringWithFormat:@"%@:%@",hour,mini];
        isSetGet = YES;
    }
    [self hiddenAlockOptionView];
}
- (void)didCancelBtnClick{
    [self hiddenAlockOptionView];
}
-(void)hiddenAlockOptionView {
    PostTimeView.userInteractionEnabled = YES;
    GetTimeView.userInteractionEnabled = YES;
    
//    self.contentOffset = CGPointMake(0, 0);
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        alockOptionView.frame = CGRectMake(alockOptionView.frame.origin.x, alockOptionView.frame.origin.y, WIDTH, 0);
    }];
}
-(void)showAlockOptionView{
    GetTimeView.userInteractionEnabled = NO;
    PostTimeView.userInteractionEnabled = NO;
    hour = hours[0];
    mini = minis[0];
    [UIView animateWithDuration:0.25 animations:^{
        alockOptionView.frame = CGRectMake(alockOptionView.frame.origin.x, alockOptionView.frame.origin.y, WIDTH, 192);
    }];
    [self setContentOffset:CGPointMake(0, self.contentSize.height - self.frame.size.height) animated:YES];
    sumHeight = CGRectGetHeight(_planDateView.frame) + CGRectGetHeight(_calendarContentView.frame) + 3 * MARGIN + 70 + 192;
}
//送
- (void)didChoocePostTime:(UIGestureRecognizer*)tap {
    isPostClick = YES;
    [self showAlockOptionView];
}
//接
-(void)didChooceGetTime:(UIGestureRecognizer*)tap{
    isPostClick = NO;
    [self showAlockOptionView];
}

-(void)getClickDate:(AYCalendarCellView*)view{
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
    theDayDate = view.dateString;
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

-(void)didPlusbtnClick:(UIGestureRecognizer*)tap{
    CGPoint tapPoint = [tap locationInView:tap.view];
    if (tapPoint.x < CGRectGetWidth(tap.view.frame) * 0.5) {
        sumChilrenCount = sumChilrenCount == 0 ? 0 : sumChilrenCount - 1;
        chilrenCountLabel.text = [NSString stringWithFormat:@"%d 个小孩",sumChilrenCount];
    }else{
        sumChilrenCount ++;
        chilrenCountLabel.text = [NSString stringWithFormat:@"%d 个小孩",sumChilrenCount];
    }
}

#pragma mark -- commands
-(id)queryFiterArgs:(NSDictionary*)args{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (!isSetPost || !isSetGet) {
        return nil;
    }
    if (!theDayDate || [theDayDate isEqualToString:@""]) {
        theDayDate = currentDate;
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *plan_time_post = [NSString stringWithFormat:@"%@ %@",theDayDate,choocePostTime.text];
    NSDate *startDate = [format dateFromString:plan_time_post];
    NSTimeInterval start = startDate.timeIntervalSince1970;
    
    NSString *plan_time_get = [NSString stringWithFormat:@"%@ %@", theDayDate,chooceGetTime.text];//2016-06-18 3:45.AM
    NSDate *endDate = [format dateFromString:plan_time_get];
    NSTimeInterval end = endDate.timeIntervalSince1970; //s
    
    if (end <= start) {
        return nil;
    }
    
    [dic setValue:theDayDate forKey:@"plan_date"];
    [dic setValue:[NSNumber numberWithDouble:start] forKey:@"plan_time_post"];
    [dic setValue:[NSNumber numberWithDouble:end] forKey:@"plan_time_get"];
    [dic setValue:[NSNumber numberWithInt:sumChilrenCount] forKey:@"chilren_numb"];
    
    return dic;
}

-(id)resetFiterArgs{
    [self getClickDate:nil];
    
    choocePostTime.text = @"00:00";
    chooceGetTime.text = @"00:00";
    isSetPost = isSetGet = NO;
    [self refreshScrollPositionCurrentDate];
//    sumChilrenCount = 1;
//    chilrenCountLabel.text = [NSString stringWithFormat:@"%d 个小孩",sumChilrenCount];
    return nil;
}

#pragma mark -- scrollView delegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (self.contentOffset.y > sumHeight - ([UIScreen mainScreen].bounds.size.height - self.frame.origin.y - 45 - 20 - 10)) {
//        self.contentOffset = CGPointMake(0, sumHeight - ([UIScreen mainScreen].bounds.size.height - self.frame.origin.y - 45 - 20 - 10));
//        
//    }
//}

- (void)addCollectionView{
    NSArray *titleArr = [NSArray arrayWithObjects:@"日", @"一",@"二",@"三",@"四",@"五",@"六",nil];
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, WIDTH, 30)];
    [self addSubview:_headerView];
    
    CGFloat labelWidth = (WIDTH - 30)/7;
    for (int i = 0; i<7; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*labelWidth + 15, 0, labelWidth, 30)];
        label.text = [titleArr objectAtIndex:i];
        label.textAlignment = 1;
        label.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
        label.font = [UIFont systemFontOfSize:14.f];
        [_headerView addSubview:label];
    }
    CALayer *line_separator = [CALayer layer];
    line_separator.frame = CGRectMake(0, 29, WIDTH, 1);
    line_separator.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [_headerView.layer addSublayer:line_separator];
    
    /******************/
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat wh = (WIDTH - 30) / 7;
    layout.itemSize = CGSizeMake(wh, wh);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _calendarContentView = [[UICollectionView alloc]initWithFrame:CGRectMake(30, 40, WIDTH - 30, (WIDTH - 30)/7*5) collectionViewLayout:layout];
    _calendarContentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_calendarContentView];
    _calendarContentView.delegate = self;
    _calendarContentView.dataSource = self;
    _calendarContentView.showsVerticalScrollIndicator = NO;
    
    [_calendarContentView registerClass:[AYDayCollectionCellView class] forCellWithReuseIdentifier:@"AYDayCollectionCellView"];
    //注册头部
    [_calendarContentView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AYDayCollectionHeader"];
    
    [self refreshScrollPositionCurrentDate];
}

#pragma mark <UICollectionViewDataSource>
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
        cell.gregoiainCalendar = dateStr;
        cell.chineseCalendar = [self.useTime timeChineseCalendarWithString:dateStr];
        
        CGFloat wh = (WIDTH - 30)/7;
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
        spearter.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.f].CGColor;
        spearter.frame = CGRectMake(0, 8, WIDTH - 30, 1);
        [headerView.layer addSublayer:spearter];
        //设置属性
        label.text = [NSString stringWithFormat:@"%ld月 %ld年", indexPath.section % 12 + 1, indexPath.section/12 + [_useTime getYear]];
        return headerView;
    }
    return nil;
}

//设置header的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return (CGSize){WIDTH, (WIDTH - 30)/7};
}

//cell点击
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AYDayCollectionCellView * cell = (AYDayCollectionCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isGone) {
        return ;
    }
    theDayDate = [NSString stringWithFormat:@"%ld-%ld-%@", indexPath.section/12 + [_useTime getYear], indexPath.section%12 + 1, cell.dayDay];
    
    NSDate *startDate = [_useTime strToDate:theDayDate];
    
    NSDateFormatter *unformat = [[NSDateFormatter alloc] init];
    [unformat setDateFormat:@"MM月dd日 EEEE"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [unformat setTimeZone:timeZone];
    NSString *undate = [unformat stringFromDate:startDate];
    id<AYCommand> cmd = [self.notifies objectForKey:@"changeNavTitle:"];
    [cmd performWithResult:&undate];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AYDayCollectionCellView * cell = (AYDayCollectionCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isGone) {
        return NO;
    }else return YES;
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
}

-(id)dateScrollToCenter:(NSString*)str{
    str = [str substringToIndex:10];
    NSArray *calendar = [str componentsSeparatedByString:@"年"];
    NSArray *calendar2 = [calendar[1] componentsSeparatedByString:@"月"];
    [self refreshControlWithYear:calendar[0] month:calendar2[0] day:calendar2[1]];
    return nil;
}
@end
