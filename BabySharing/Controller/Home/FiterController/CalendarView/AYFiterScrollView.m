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
#import "Tools.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define WIDTH               (self.frame.size.width - 30)
#define HEIGHT              self.frame.size.height
#define MARGIN              10.f

@interface AYFiterScrollView ()<UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>
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
@property (nonatomic, strong) UIView *calendarContentView;
@property (nonatomic, strong) UIView *planDateView;
@property (nonatomic, strong) UIView *chilrenNumbView;
@property (nonatomic, strong) UIButton *moreFilterBtn;

@property(nonatomic,copy) NSMutableArray *registerArr;
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

-(NSMutableArray*)registerArr{
    if (!_registerArr) {
        _registerArr=[[NSMutableArray alloc]init];
    }
    return _registerArr;
}

#pragma mark -- life cycle
- (void)postPerform {
    
//    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, 140);
    
    self.year = [self getYear];
    self.searchYear = self.year;
    
    self.month = [self getMonth];
    self.searchMonth = self.month;
    
    self.day = [self getDay];
    self.searchDay = self.day;
    
    [self.registerArr addObject:[NSString stringWithFormat:@"%.4d-%.2d-%.2d",self.year,self.month,self.day]];
    
    self.daysOfMonth = [self getDaysOfMonthWithYear:self.year withMonth:self.month];
    self.searchDaysOfMonth = self.daysOfMonth;
    
    sumHeight = 140;
    
    ons = @[@"AM", @"PM"];
    hours = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    minis = @[@"00",@"15",@"30",@"45"];
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
//返回当前年
-(int)getYear{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowDateComps = [[NSDateComponents alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    nowDateComps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowDate];
    
    return (int)[nowDateComps year];
}

//返回当前月
-(int)getMonth{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowDateComps = [[NSDateComponents alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    nowDateComps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowDate];
    
    return (int)[nowDateComps month];
}

//返回当前日
-(int)getDay{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowDateComps = [[NSDateComponents alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    nowDateComps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowDate];
    
    return (int)[nowDateComps day];
}

//获得某个月的第一天是星期几
-(int)getWeekOfFirstDayOfMonthWithYear:(int)year withMonth:(int)month{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSString *firstWeekDayMonth = [NSString stringWithFormat:@"%d-%d-%d",year,month,1];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *weekOfFirstDayOfMonth = [dateFormatter dateFromString:firstWeekDayMonth];
    
    NSDateComponents *newCom = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:weekOfFirstDayOfMonth];
    
    return  (int)[newCom weekday] - 1;
}

//返回一个月有多少天
-(int)getDaysOfMonthWithYear:(int)year withMonth:(int)month{
    NSInteger days = 0;
    //1,3,5,7,8,10,12
    NSArray *bigMoth = [[NSArray alloc] initWithObjects:@"1",@"3",@"5",@"7",@"8",@"10",@"12", nil];
    //4,6,9,11
    NSArray *milMoth = [[NSArray alloc] initWithObjects:@"4",@"6",@"9",@"11", nil];
    
    if ([bigMoth containsObject:[[NSString alloc] initWithFormat:@"%ld",(long)month]]) {
        days = 31;
    }else if([milMoth containsObject:[[NSString alloc] initWithFormat:@"%ld",(long)month]]){
        days = 30;
    }else{
        if ([self isLoopYear:year]) {
            days = 29;
        }else
            days = 28;
    }
    return (int)days;
}

//判断是否是闰年
-(BOOL)isLoopYear:(NSInteger)year{
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return true;
    }else
        return NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.delegate = self;
    self.contentSize = CGSizeMake(WIDTH, 560);
    
    if (!_calendarContentView) {
        [self addCollectionCell];
    }
    if (!_planDateView) {
        [self addplanDateView];
    }
    if (!alockOptionView) {
        [self addAlockOptionView];
    }
//    if (!_chilrenNumbView) {
//        [self addChilrenNumbView];
//    }
    
}

#pragma mark- 设置pickView数据
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return ons.count;
    }
    else if(component == 1){
        return hours.count;
    }else
        return minis.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return ons[row];
    }else if (component == 1){
        return hours[row];
    }else
        return minis[row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 90;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        on = ons[row];
    } else if(component == 1){
        hour = hours[row];
    }else
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
    plusCountBtn.image = [UIImage imageNamed:@"lol"];
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
- (void)addCollectionCell{
//    CGFloat width = self.frame.size.width;
    _calendarContentView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, WIDTH, 280)];
    _calendarContentView.clipsToBounds = YES;
    [self addSubview:self.calendarContentView];
    [self addHeaderView];
    
    int  column = 7;
    for (int i = 0; i < 35; ++i) {
        int  rowIndex = i / column;  // 行索引
        int columnIndex = i % column;  // 列索引
        CGFloat margin = 2.f;
        CGFloat cell_w = (WIDTH - 8 * margin) / 7;
        CGFloat org_x = margin * (columnIndex + 1) + cell_w * columnIndex;
        CGFloat org_y = margin * (rowIndex + 1) + cell_w * rowIndex + CGRectGetHeight(_headerView.frame);
        
        AYCalendarCellView *cell = [[AYCalendarCellView alloc]initWithFrame:CGRectMake(org_x, org_y, cell_w, cell_w)];
        
        cell.numLabel.text = [NSString stringWithFormat:@"%d",i];
        [self.calendarContentView addSubview:cell];
        
        //第一个星期日是 负几号
        //星期几
        int dateNum = i - [self getWeekOfFirstDayOfMonthWithYear:self.searchYear withMonth:self.searchMonth] + 1;
        
        //月内
        if (dateNum >= 1 && (i < self.searchDaysOfMonth + [self getWeekOfFirstDayOfMonthWithYear:self.searchYear withMonth:self.searchMonth])) {
            cell.numLabel.text = [NSString stringWithFormat:@"%d",dateNum];
            cell.numLabel.textColor = [UIColor blackColor];
            cell.dateString = [NSString stringWithFormat:@"%.4d-%.2d-%.2d",self.searchYear,self.searchMonth,dateNum];
        }
        //前一个月
        if (dateNum < 1) {
            cell.numLabel.textColor=[UIColor grayColor];
            int days;
            if (self.searchMonth != 1 ) {
                days = [self getDaysOfMonthWithYear:self.searchYear withMonth:(self.searchMonth - 1)];
            }else if(self.searchMonth == 1) {
                days = [self getDaysOfMonthWithYear:self.searchYear-1 withMonth:12];
            }
//            cell.numLabel.text = [NSString stringWithFormat:@"%d",dateNum+days];
            cell.dateString = [NSString stringWithFormat:@"%.4d-%.2d-%.2d",self.searchYear,self.searchMonth - 1, dateNum+days];
            cell.numLabel.text = @"";
            cell.userInteractionEnabled = NO;
        }
        //后一个月
        if (dateNum > self.searchDaysOfMonth) {
//            cell.numLabel.text = [NSString stringWithFormat:@"%d",dateNum - self.searchDaysOfMonth];
            cell.numLabel.text = @"";
//            cell.numLabel.textColor = [UIColor grayColor];
            cell.dateString = [NSString stringWithFormat:@"%.4d-%.2d-%.2d",self.searchYear,self.searchMonth+1,dateNum- self.searchDaysOfMonth];
            cell.userInteractionEnabled = NO;
        }
        //数组内包含当前日期则说明此日期时 今天，设置颜色为主题色；
        if([self.registerArr.lastObject isEqualToString: [NSString stringWithFormat:@"%.4d-%.2d-%.2d",self.searchYear,self.searchMonth,dateNum]]){
            numbOfCurrentDay = i;
            cell.numLabel.textColor=[Tools themeColor];
            cell.numLabel.layer.masksToBounds=YES;
            cell.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
            cell.numLabel.layer.borderWidth=0;
        }
        cell.CellDateBlock = ^(AYCalendarCellView *dateString){
            if (i >= numbOfCurrentDay) {
                [self getClickDate:dateString];
            } else [[[UIAlertView alloc]initWithTitle:@"提示" message:@"昨日之日不可留" delegate:nil cancelButtonTitle:@"今日之前不可选" otherButtonTitles:nil, nil] show];
        };
    }
}

- (void)addplanDateView {
    _planDateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_calendarContentView.frame) + 10, SCREEN_WIDTH, 80)];
    _planDateView.backgroundColor = [UIColor whiteColor];
//    _planDateView.layer.cornerRadius = 3.f;
//    _planDateView.clipsToBounds = YES;
//    _planDateView.layer.shadowColor = [UIColor blackColor].CGColor;
//    _planDateView.layer.shadowOffset = CGSizeMake(0, 0);
//    _planDateView.layer.shadowOpacity = 0.25;
//    _planDateView.layer.shadowRadius = 2;
//    _planDateView.layer.shouldRasterize = YES;
//    _planDateView.layer.rasterizationScale = [UIScreen mainScreen].scale;
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
    line_separator.frame = CGRectMake(SCREEN_WIDTH *0.5, 10, 1, 60);
    [_planDateView.layer addSublayer:line_separator];
    
    UIView *PostTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH *0.5, 80)];
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
    choocePostTime.text = @"——";
    choocePostTime.font = [UIFont systemFontOfSize:25.f];
    choocePostTime.textColor = [Tools themeColor];
    choocePostTime.textAlignment = NSTextAlignmentCenter;
    [PostTimeView addSubview:choocePostTime];
    choocePostTime.userInteractionEnabled = YES;
    [PostTimeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didChoocePostTime:)]];
    
    /* get */
    UIView *GetTimeView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *0.5, 5, SCREEN_WIDTH *0.5, 80)];
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
    chooceGetTime.text = @"——";
    chooceGetTime.font = [UIFont systemFontOfSize:25.f];
    chooceGetTime.textColor = [Tools themeColor];
    chooceGetTime.textAlignment = NSTextAlignmentCenter;
    [GetTimeView addSubview:chooceGetTime];
    chooceGetTime.userInteractionEnabled = YES;
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
    if (!on || [on isEqualToString:@""]) {
        on = ons[0];
    }
    if (!hour || [hour isEqualToString:@""]) {
        hour = hours[0];
    }
    if (!mini || [mini isEqualToString:@""]) {
        mini = minis[0];
    }
    
    if (isPostClick) {
        choocePostTime.text = [NSString stringWithFormat:@"%@:%@.%@",hour,mini, on];
    } else {
        chooceGetTime.text = [NSString stringWithFormat:@"%@:%@.%@",hour,mini, on];
    }
    [self hiddenAlockOptionView];
}
- (void)didCancelBtnClick{
    [self hiddenAlockOptionView];
}
-(void)hiddenAlockOptionView{
    choocePostTime.userInteractionEnabled = YES;
    chooceGetTime.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.25 animations:^{
        alockOptionView.frame = CGRectMake(alockOptionView.frame.origin.x, alockOptionView.frame.origin.y, WIDTH, 0);
        _chilrenNumbView.frame = CGRectMake(_chilrenNumbView.frame.origin.x, CGRectGetMaxY(_planDateView.frame) + 10, WIDTH, CGRectGetHeight(_chilrenNumbView.frame));
    }];
}
-(void)showAlockOptionView{
    choocePostTime.userInteractionEnabled = NO;
    chooceGetTime.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        alockOptionView.frame = CGRectMake(alockOptionView.frame.origin.x, CGRectGetHeight(_planDateView.frame) + CGRectGetHeight(_calendarContentView.frame) + MARGIN, WIDTH, 192);
        _chilrenNumbView.frame = CGRectMake(_chilrenNumbView.frame.origin.x, CGRectGetMaxY(alockOptionView.frame) + 10, WIDTH, CGRectGetHeight(_chilrenNumbView.frame));
        
    }];
    sumHeight = CGRectGetHeight(_planDateView.frame) + CGRectGetHeight(_calendarContentView.frame) + 3 * MARGIN + 70 + 192;
}
//送
- (void)didChoocePostTime:(UIGestureRecognizer*)tap{
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
//    NSTimeInterval date = startDate.timeIntervalSince1970;
    
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
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm.aa"];
    [format setAMSymbol:(@"AM")];
    [format setPMSymbol:@"PM"];
    
    NSString *plan_time_post = [NSString stringWithFormat:@"%@ %@",theDayDate,choocePostTime.text];
    NSDate *startDate = [format dateFromString:plan_time_post];
    NSTimeInterval start = startDate.timeIntervalSince1970 * 1000;
    
    NSString *plan_time_get = [NSString stringWithFormat:@"%@ %@", theDayDate,chooceGetTime.text];//2016-06-18 3:45.AM
    NSDate *endDate = [format dateFromString:plan_time_get];
    NSTimeInterval end = endDate.timeIntervalSince1970 * 1000; //s
    
    [dic setValue:theDayDate forKey:@"plan_date"];
    [dic setValue:[NSNumber numberWithDouble:start] forKey:@"plan_time_post"];
    [dic setValue:[NSNumber numberWithDouble:end] forKey:@"plan_time_get"];
    [dic setValue:[NSNumber numberWithInt:sumChilrenCount] forKey:@"chilren_numb"];
    
    return dic;
}

-(id)resetFiterArgs{
    
    [self getClickDate:nil];
    
    choocePostTime.text = @"——";
    chooceGetTime.text = @"——";
    sumChilrenCount = 1;
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
@end
