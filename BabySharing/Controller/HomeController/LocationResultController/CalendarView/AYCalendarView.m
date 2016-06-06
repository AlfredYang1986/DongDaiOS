//
//  AYCalendarView.m
//  BabySharing
//
//  Created by Alfred Yang on 2/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCalendarView.h"
#import "AYCommandDefines.h"
#import "AYCalendarCellView.h"
#import "Tools.h"

#define WIDTH  self.frame.size.width
#define MARGIN 10.f

@interface AYCalendarView ()<UIPickerViewDataSource, UIPickerViewDelegate>
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
@property (nonatomic, strong) UIView *filtTimeView;
@property (nonatomic, strong) UIView *chilrenNumbView;
@property (nonatomic, strong) UIButton *moreFilterBtn;

@property(nonatomic,copy) NSMutableArray *registerArr;
@end

@implementation AYCalendarView{
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
@synthesize filtTimeView = _filtTimeView;
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
    
    NSString *firstWeekDayMonth = [[NSString alloc] initWithFormat:@"%d",year];
    firstWeekDayMonth = [firstWeekDayMonth stringByAppendingString:[[NSString alloc]initWithFormat:@"%s","-"]];
    firstWeekDayMonth = [firstWeekDayMonth stringByAppendingString:[[NSString alloc]initWithFormat:@"%d",month]];
    firstWeekDayMonth = [firstWeekDayMonth stringByAppendingString:[[NSString alloc]initWithFormat:@"%s","-"]];
    firstWeekDayMonth = [firstWeekDayMonth stringByAppendingString:[[NSString alloc]initWithFormat:@"%d",1]];
    
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
    self.contentSize = CGSizeMake(WIDTH, 1400);
    
    if (!_calendarContentView) {
        [self addCollectionCell];
    }
    if (!_planDateView) {
        [self addplanDateView];
    }
    if (!alockOptionView) {
        [self addAlockOptionView];
    }
    if (!_moreFilterBtn) {
        [self addMoreFilterBtn];
    }
    if (!_filtTimeView) {
        [self addFiltTimeView];
    }
    if (!_chilrenNumbView) {
        [self addChilrenNumbView];
    }
    
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
    _chilrenNumbView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_planDateView.frame) + 10, WIDTH, 0/*70*/)];
    _chilrenNumbView.backgroundColor = [UIColor whiteColor];
    _chilrenNumbView.layer.cornerRadius =3.f;
    _chilrenNumbView.clipsToBounds = YES;
    [self addSubview:_chilrenNumbView];
    
    chilrenCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 110, 70)];
    chilrenCountLabel.text = [NSString stringWithFormat:@"%d 个小孩",sumChilrenCount];
    [_chilrenNumbView addSubview:chilrenCountLabel];
    
    UIImageView *passCountBtn = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 10 - 110, 13, 110, 45)];
    passCountBtn.image = [UIImage imageNamed:@"lol"];
    [_chilrenNumbView addSubview:passCountBtn];
    passCountBtn.userInteractionEnabled = YES;
    [passCountBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPassbtnClick:)]];
}

- (void)addFiltTimeView{
    _filtTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_planDateView.frame), WIDTH, 0/*70*/)];
    _filtTimeView.clipsToBounds = YES;
    [self addSubview:_filtTimeView];
}
- (void)addAlockOptionView{
    alockOptionView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_planDateView.frame), WIDTH, 0)];
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
    CGFloat width = self.frame.size.width;
    _calendarContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    _calendarContentView.clipsToBounds = YES;
    [self addSubview:self.calendarContentView];
    //    _calendarContentView.hidden = YES;
    
    [self addHeaderView];
    
    int  column = 7;
    for (int i = 0; i < 35; ++i) {
        int  rowIndex = i / column;  // 行索引
        int columnIndex = i % column;  // 列索引
        CGFloat margin = 2.f;
        CGFloat cell_w = (self.bounds.size.width - 8*margin)/7;
        CGFloat org_x = margin * (columnIndex + 1) + cell_w * columnIndex;
        CGFloat org_y = margin * (rowIndex + 1) + cell_w * rowIndex + 60;
        
        AYCalendarCellView *cell = [[AYCalendarCellView alloc]initWithFrame:CGRectMake(org_x, org_y, cell_w, cell_w)];
        
        cell.numLabel.text = [NSString stringWithFormat:@"%d",i];
        [self.calendarContentView addSubview:cell];
        
        //星期几
        int dateNum = i - [self getWeekOfFirstDayOfMonthWithYear:self.searchYear withMonth:self.searchMonth]+1;
        
        //月内
        if (dateNum >= 1 && (i<self.searchDaysOfMonth+[self getWeekOfFirstDayOfMonthWithYear:self.searchYear withMonth:self.searchMonth])) {
            cell.numLabel.text=[NSString stringWithFormat:@"%d",dateNum];
            cell.numLabel.textColor=[UIColor blackColor];
            cell.dateString = [NSString stringWithFormat:@"%.4d-%.2d-%.2d",self.searchYear,self.searchMonth,dateNum];
        }
        //前一个月
        if (dateNum < 1) {
            cell.numLabel.textColor=[UIColor grayColor];
            int days;
            if (self.searchMonth != 1 ) {
                days = [self getDaysOfMonthWithYear:self.searchYear withMonth:self.searchMonth-1];
            }else if(self.searchMonth == 1){
                days = [self getDaysOfMonthWithYear:self.searchYear-1 withMonth:12];
            }
            cell.numLabel.text = [NSString stringWithFormat:@"%d",dateNum+days];
            cell.dateString = [NSString stringWithFormat:@"%.4d-%.2d-%.2d",self.searchYear,self.searchMonth-1,dateNum+days];
        }
        //后一个月
        if (dateNum > self.searchDaysOfMonth) {
            cell.numLabel.text = [NSString stringWithFormat:@"%d",dateNum - self.searchDaysOfMonth];
            cell.numLabel.textColor = [UIColor grayColor];
            cell.dateString = [NSString stringWithFormat:@"%.4d-%.2d-%.2d",self.searchYear,self.searchMonth+1,dateNum- self.searchDaysOfMonth];
        }
        
        //数组内包含当前日期则说明此日期时 今天，设置颜色为蓝色；
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
            }
        };
    }
    
}

- (void)addMoreFilterBtn{
    _moreFilterBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_planDateView.frame) + 10, WIDTH, 45)];
    [self addSubview:_moreFilterBtn];
    [_moreFilterBtn setTitle:@"更多筛选条件" forState:UIControlStateNormal];
    [_moreFilterBtn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    [_moreFilterBtn setBackgroundColor:[UIColor clearColor]];
    _moreFilterBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _moreFilterBtn.layer.cornerRadius = 4.f;
    _moreFilterBtn.layer.borderColor = [Tools themeColor].CGColor;
    _moreFilterBtn.layer.borderWidth = 1.5f;
    [_moreFilterBtn addTarget:self action:@selector(didMorefilterbtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    [_moreFilterBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_planDateView.mas_bottom).offset(10);
//        make.centerX.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, 45));
//    }];
}

- (void)addplanDateView {
    _planDateView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 60)];
    _planDateView.backgroundColor = [UIColor whiteColor];
    _planDateView.layer.cornerRadius =3.f;
    _planDateView.clipsToBounds = YES;
    _planDateView.layer.shadowColor = [UIColor blackColor].CGColor;
    _planDateView.layer.shadowOffset = CGSizeMake(0, 0);
    _planDateView.layer.shadowOpacity = 0.25;
    _planDateView.layer.shadowRadius = 2;
    _planDateView.layer.shouldRasterize = YES;
    _planDateView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:_planDateView];
    
    CALayer *line_separator = [CALayer layer];
    line_separator.borderColor = [UIColor colorWithWhite:0.5922 alpha:1.f].CGColor;
    line_separator.borderWidth = 1.f;
    line_separator.frame = CGRectMake(WIDTH *0.5, 10, 1, 40);
    [_planDateView.layer addSublayer:line_separator];
    
    UIView *PostTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH *0.5, 60)];
    [_planDateView addSubview:PostTimeView];
    
    CATextLayer *postTitle = [CATextLayer layer];
    postTitle.frame = CGRectMake(0, 10, WIDTH * 0.5, 20);
    postTitle.string = @"预计送娃时间";
    postTitle.fontSize = 14.f;
    postTitle.foregroundColor = [UIColor blackColor].CGColor;
    postTitle.alignmentMode = @"center";
    postTitle.contentsScale = 2.f;
    [PostTimeView.layer addSublayer:postTitle];
    
    didStarPlanTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, WIDTH * 0.5, 16)];
    didStarPlanTime.text = @"选择时间";
    didStarPlanTime.hidden = NO;
    didStarPlanTime.font = [UIFont systemFontOfSize:14.f];
    didStarPlanTime.textColor = [Tools themeColor];
    didStarPlanTime.textAlignment = NSTextAlignmentCenter;
    [PostTimeView addSubview:didStarPlanTime];
    didStarPlanTime.userInteractionEnabled = YES;
    [didStarPlanTime addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didStarPlanTime:)]];
    
    choocePostTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, WIDTH * 0.5, 16)];
    choocePostTime.text = @"选择时间";
    choocePostTime.hidden = YES;
    choocePostTime.font = [UIFont systemFontOfSize:14.f];
    choocePostTime.textColor = [Tools themeColor];
    choocePostTime.textAlignment = NSTextAlignmentCenter;
    [PostTimeView addSubview:choocePostTime];
    choocePostTime.userInteractionEnabled = YES;
    [choocePostTime addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didChoocePostTime:)]];
    
    /* get */
    UIView *GetTimeView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH *0.5, 0, WIDTH *0.5, 100)];
    [_planDateView addSubview:GetTimeView];
    CATextLayer *getTitle = [CATextLayer layer];
    getTitle.frame = CGRectMake(0, 10, WIDTH * 0.5, 20);
    getTitle.string = @"预计接娃时间";
    getTitle.fontSize = 14.f;
    getTitle.foregroundColor = [UIColor blackColor].CGColor;
    getTitle.alignmentMode = @"center";
    getTitle.contentsScale = 2.f;
    [GetTimeView.layer addSublayer:getTitle];
    
    chooceGetTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, WIDTH * 0.5, 16)];
    chooceGetTime.text = @"——";
    chooceGetTime.font = [UIFont systemFontOfSize:14.f];
    chooceGetTime.textColor = [UIColor blackColor];
    chooceGetTime.textAlignment = NSTextAlignmentCenter;
    [GetTimeView addSubview:chooceGetTime];
}

- (void)addHeaderView{
    NSArray *a = [NSArray arrayWithObjects:@"日", @"一",@"二",@"三",@"四",@"五",@"六",nil];
//    [_headerView removeFromSuperview];
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    [_calendarContentView addSubview:self.headerView];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.font = [UIFont systemFontOfSize:14.f];
    //    dateLabel.center = CGPointMake(width/2, 20);
    //    dateLabel.text = [NSString stringWithFormat:@"%d-%.2d",self.searchYear,self.searchMonth];
    dateLabel.text = @"选择日期";
    dateLabel.textColor = [Tools themeColor];
    [_headerView addSubview:dateLabel];
    
    UIView *blueView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, WIDTH, 30)];
    //    blueView.backgroundColor = Blue_textColor;
    [_headerView addSubview:blueView];
    CGFloat labelWidth = (WIDTH)/7;
    for (int i = 0; i<7; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*labelWidth+3, 0, labelWidth, 30)];
        label.text = [a objectAtIndex:i];
        label.textAlignment = 1;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.f];
        [blueView addSubview:label];
    }
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
    choocePostTime.text = [NSString stringWithFormat:@"%@:%@ .%@",hour,mini, on];
    alockOptionView.frame = CGRectMake(alockOptionView.frame.origin.x, alockOptionView.frame.origin.y, WIDTH, 0);
    _chilrenNumbView.frame = CGRectMake(_chilrenNumbView.frame.origin.x, CGRectGetMaxY(_planDateView.frame) + 10, WIDTH, CGRectGetHeight(_chilrenNumbView.frame));
}
- (void)didCancelBtnClick{
    alockOptionView.frame = CGRectMake(alockOptionView.frame.origin.x, alockOptionView.frame.origin.y, WIDTH, 0);
    _chilrenNumbView.frame = CGRectMake(_chilrenNumbView.frame.origin.x, CGRectGetMaxY(_planDateView.frame) + 10, WIDTH, CGRectGetHeight(_chilrenNumbView.frame));
}
- (void)didChoocePostTime:(UIGestureRecognizer*)tap{
    
    alockOptionView.frame = CGRectMake(alockOptionView.frame.origin.x, CGRectGetHeight(_planDateView.frame) + CGRectGetHeight(_calendarContentView.frame) + MARGIN, WIDTH, 192);
    _chilrenNumbView.frame = CGRectMake(_chilrenNumbView.frame.origin.x, CGRectGetMaxY(alockOptionView.frame) + 10, WIDTH, CGRectGetHeight(_chilrenNumbView.frame));
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.frame.origin.y - 45 - 20 - 10);
    self.contentSize = CGSizeMake(WIDTH, CGRectGetHeight(_planDateView.frame) + CGRectGetHeight(_calendarContentView.frame) + 3 * MARGIN + 70 + 162);
    
//    CGFloat height = CGRectGetHeight(_planDateView.frame) + CGRectGetHeight(_calendarContentView.frame) + 3 * MARGIN + 70 + 192;
//    NSNumber *height_numb = [NSNumber numberWithFloat:height];
//    id<AYCommand> reset_cmd = [self.notifies objectForKey:@"resetContentSize:"];
//    [reset_cmd performWithResult:&height_numb];
}
- (void)didStarPlanTime:(UIGestureRecognizer*)tap{
    didStarPlanTime.hidden = YES;
    choocePostTime.hidden = NO;
    choocePostTime.text = @"选择时间";
    chooceGetTime.text = @"——";
    
    _calendarContentView.frame = CGRectMake(_calendarContentView.frame.origin.x, _calendarContentView.frame.origin.y, _calendarContentView.frame.size.width, 300);
    _planDateView.frame = CGRectMake(_planDateView.frame.origin.x, CGRectGetMaxY(_calendarContentView.frame)+ 10, _planDateView.bounds.size.width, _planDateView.bounds.size.height);
    _chilrenNumbView.frame = CGRectMake(_chilrenNumbView.frame.origin.x, CGRectGetMaxY(_planDateView.frame)+ 10, _chilrenNumbView.frame.size.width, 70);
    _moreFilterBtn.hidden = YES;
    
    id<AYCommand> hidden = [self.notifies objectForKey:@"hiddenCLResultTable"];
    [hidden performWithResult:nil];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.frame.origin.y - 45 - 20 - 10);
//    self.contentSize = CGSizeMake(WIDTH, CGRectGetHeight(_planDateView.frame) + CGRectGetHeight(_calendarContentView.frame) + 3 * MARGIN + 70);
    self.contentSize = CGSizeMake(WIDTH, CGRectGetHeight(_planDateView.frame) + CGRectGetHeight(_calendarContentView.frame) + 3 * MARGIN + 70);
    
//    CGFloat height = CGRectGetHeight(_planDateView.frame) + CGRectGetHeight(_calendarContentView.frame) + 3 * MARGIN + 70;
//    NSNumber *height_numb = [NSNumber numberWithFloat:height];
//    id<AYCommand> reset_cmd = [self.notifies objectForKey:@"resetContentSize:"];
//    [reset_cmd performWithResult:&height_numb];
}

-(void)getClickDate:(AYCalendarCellView*)view{
    NSLog(@"----%@",view);
    if (tmp) {
        tmp.numLabel.textColor = [UIColor blackColor];
        tmp.backgroundColor = [UIColor whiteColor];
    }
    tmp = view;
    tmp.numLabel.textColor = [UIColor whiteColor];
    tmp.backgroundColor = [Tools themeColor];
    theDayDate = view.dateString;
    
//    optionDateCount ++;
//    if (optionDateCount == 1) {
//        if (date) {
//            choocePostTime.text = date;
//        }
//        return;
//    }
//    if (optionDateCount == 2) {
//        if (date) {
//            chooceGetTime.text = date;
//        }
//        optionDateCount = 0;
//        choocePostTime.userInteractionEnabled = YES;
//        
//        _calendarContentView.frame = CGRectMake(_calendarContentView.frame.origin.x, _calendarContentView.frame.origin.y, _calendarContentView.frame.size.width, 0);
//        _planDateView.frame = CGRectMake(_planDateView.frame.origin.x, CGRectGetMaxY(_calendarContentView.frame)+ 10, _planDateView.bounds.size.width, _planDateView.bounds.size.height);
//        _moreFilterBtn.frame = CGRectMake(_moreFilterBtn.frame.origin.x, CGRectGetMaxY(_planDateView.frame) + 10, CGRectGetWidth(_moreFilterBtn.frame), CGRectGetHeight(_moreFilterBtn.frame));
//        
//        id<AYCommand> hidden = [self.notifies objectForKey:@"hiddenCLResultTable"];
//        [hidden performWithResult:nil];
//        
//        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 140);
//        //    self.contentSize = CGSizeMake(WIDTH, self.frame.size.height - _headerView.bounds.size.height - _calendarContentView.bounds.size.height);
//        //        _calendarContentView.hidden = YES;
//    }
}

- (void)didMorefilterbtnClick{
    alockOptionView.frame = CGRectMake(CGRectGetMinX(alockOptionView.frame), CGRectGetMaxY(_planDateView.frame), WIDTH, 70);
    [self moreFilterBtnFrameUpdate];
}

-(void)moreFilterBtnFrameUpdate{
    _moreFilterBtn.frame = CGRectMake(_moreFilterBtn.frame.origin.x, CGRectGetMaxY(_planDateView.frame) + 10, CGRectGetWidth(_moreFilterBtn.frame), CGRectGetHeight(_moreFilterBtn.frame));
    
}

-(void)didPassbtnClick:(UIGestureRecognizer*)tap{
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
- (id)hiddenBeShowing{
    if (_calendarContentView.hidden == NO) {
        optionDateCount = 0;
        choocePostTime.userInteractionEnabled = YES;
        
        _calendarContentView.frame = CGRectMake(_calendarContentView.frame.origin.x, _calendarContentView.frame.origin.y, _calendarContentView.frame.size.width, 0);
        _planDateView.frame = CGRectMake(_planDateView.frame.origin.x, CGRectGetMaxY(_calendarContentView.frame)+ 10, _planDateView.bounds.size.width, _planDateView.bounds.size.height);
        _moreFilterBtn.frame = CGRectMake(_moreFilterBtn.frame.origin.x, CGRectGetMaxY(_planDateView.frame) + 10, CGRectGetWidth(_moreFilterBtn.frame), CGRectGetHeight(_moreFilterBtn.frame));
        
        id<AYCommand> hidden = [self.notifies objectForKey:@"hiddenCLResultTable"];
        [hidden performWithResult:nil];
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 140);
        //    self.contentSize = CGSizeMake(WIDTH, self.frame.size.height - _headerView.bounds.size.height - _calendarContentView.bounds.size.height);
//        _calendarContentView.hidden = YES;
    }
    return nil;
}


@end
