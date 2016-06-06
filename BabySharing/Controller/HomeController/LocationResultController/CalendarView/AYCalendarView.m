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

@interface AYCalendarView ()
@property(nonatomic,assign) int year;
@property(nonatomic,assign) int searchYear;
@property(nonatomic,assign) int month;
@property(nonatomic,assign) int searchMonth;
@property(nonatomic,assign) int day;
@property(nonatomic,assign) int searchDay;
@property(nonatomic,assign) int daysOfMonth;
@property(nonatomic,assign) int searchDaysOfMonth;

@property(nonatomic,assign) CGFloat cellWidth;
@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) UIView *calendarContentView;
@property(nonatomic,strong) UIView *planTimeView;
@property(nonatomic, strong) UIButton *moreFilterBtn;

@property(nonatomic,copy) NSMutableArray *registerArr;
@end

@implementation AYCalendarView{
    UILabel *choocePostTime;
    UILabel *chooceGetTime;
    CGFloat optionTimeCount;
}

@synthesize headerView = _headerView;
@synthesize calendarContentView = _calendarContentView;
@synthesize planTimeView = _planTimeView;
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
    
    self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
    
    self.year = [self getYear];
    self.searchYear = self.year;
    
    self.month = [self getMonth];
    self.searchMonth = self.month;
    
    self.day = [self getDay];
    self.searchDay = self.day;
    
    [self.registerArr addObject:[NSString stringWithFormat:@"%.4d-%.2d-%.2d",self.year,self.month,self.day]];
    
    self.daysOfMonth = [self getDaysOfMonthWithYear:self.year withMonth:self.month];
    self.searchDaysOfMonth = self.daysOfMonth;
    
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

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.contentSize = CGSizeMake(WIDTH, self.frame.size.height);
//    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!_calendarContentView) {
        
        [self addCollectionCell];
    }
    if (!_planTimeView) {
        
        [self addPlanTimeView];
    }
    if (!_moreFilterBtn) {
        
        [self addMoreFilterBtn];
    }
    
}

#pragma mark -- actions
-(void)didChoocePostTime:(UIGestureRecognizer*)tap{
    _calendarContentView.hidden = NO;
    choocePostTime.userInteractionEnabled = NO;
    choocePostTime.text = @"选择时间";
    chooceGetTime.text = @"——";
    _planTimeView.frame = CGRectMake(_planTimeView.frame.origin.x, _planTimeView.frame.origin.y + _calendarContentView.bounds.size.height, _planTimeView.bounds.size.width, _planTimeView.bounds.size.height);
    _moreFilterBtn.frame = CGRectMake(_moreFilterBtn.frame.origin.x, _moreFilterBtn.frame.origin.y + _calendarContentView.bounds.size.height, _moreFilterBtn.bounds.size.width, _moreFilterBtn.bounds.size.height);
    
    id<AYCommand> hidden = [self.notifies objectForKey:@"hiddenCLResultTable"];
    [hidden performWithResult:nil];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.frame.origin.y);
    
//    self.contentSize = CGSizeMake(WIDTH, self.frame.size.height + _headerView.bounds.size.height + _calendarContentView.bounds.size.height);
//    [self layoutIfNeeded];
}

- (void)didMorefilterbtnClick{
    
}

-(void)getClickDate:(NSString*)date{
    NSLog(@"----%@",date);
    optionTimeCount ++;
    if (optionTimeCount == 1) {
        if (date) {
            choocePostTime.text = date;
        }
        return;
    }
    if (optionTimeCount == 2) {
        if (date) {
            chooceGetTime.text = date;
        }
        optionTimeCount = 0;
        choocePostTime.userInteractionEnabled = YES;
        
        _planTimeView.frame = CGRectMake(_planTimeView.frame.origin.x, _planTimeView.frame.origin.y - _calendarContentView.bounds.size.height, _planTimeView.bounds.size.width, _planTimeView.bounds.size.height);
        _moreFilterBtn.frame = CGRectMake(_moreFilterBtn.frame.origin.x, _moreFilterBtn.frame.origin.y - _calendarContentView.bounds.size.height, _moreFilterBtn.bounds.size.width, _moreFilterBtn.bounds.size.height);
        
        id<AYCommand> hidden = [self.notifies objectForKey:@"hiddenCLResultTable"];
        [hidden performWithResult:nil];
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 140);
        //    self.contentSize = CGSizeMake(WIDTH, self.frame.size.height - _headerView.bounds.size.height - _calendarContentView.bounds.size.height);
        _calendarContentView.hidden = YES;
    }
}

#pragma mark -- layout
- (void)addMoreFilterBtn{
    _moreFilterBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_planTimeView.frame) + 10, WIDTH, 45)];
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
//        make.top.equalTo(_planTimeView.mas_bottom).offset(10);
//        make.centerX.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, 45));
//    }];
}

- (void)addPlanTimeView {
    _planTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 60)];
    _planTimeView.backgroundColor = [UIColor whiteColor];
    _planTimeView.layer.cornerRadius =3.f;
    _planTimeView.clipsToBounds = YES;
    _planTimeView.layer.shadowColor = [UIColor blackColor].CGColor;
    _planTimeView.layer.shadowOffset = CGSizeMake(0, 0);
    _planTimeView.layer.shadowOpacity = 0.25;
    _planTimeView.layer.shadowRadius = 2;
    _planTimeView.layer.shouldRasterize = YES;
    _planTimeView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:_planTimeView];
    
    CALayer *line_separator = [CALayer layer];
    line_separator.borderColor = [UIColor colorWithWhite:0.5922 alpha:1.f].CGColor;
    line_separator.borderWidth = 1.f;
    line_separator.frame = CGRectMake(WIDTH *0.5, 10, 1, 40);
    [_planTimeView.layer addSublayer:line_separator];
    
    UIView *PostTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH *0.5, 60)];
    [_planTimeView addSubview:PostTimeView];
    
    CATextLayer *postTitle = [CATextLayer layer];
    postTitle.frame = CGRectMake(0, 10, WIDTH * 0.5, 20);
    postTitle.string = @"预计送娃时间";
    postTitle.fontSize = 14.f;
    postTitle.foregroundColor = [UIColor blackColor].CGColor;
    postTitle.alignmentMode = @"center";
    postTitle.contentsScale = 2.f;
    [PostTimeView.layer addSublayer:postTitle];
    
    choocePostTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, WIDTH * 0.5, 16)];
    choocePostTime.text = @"选择时间";
    choocePostTime.font = [UIFont systemFontOfSize:14.f];
    choocePostTime.textColor = [Tools themeColor];
    choocePostTime.textAlignment = NSTextAlignmentCenter;
    [PostTimeView addSubview:choocePostTime];
    
    choocePostTime.userInteractionEnabled = YES;
    [choocePostTime addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didChoocePostTime:)]];
    
    /* get */
    UIView *GetTimeView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH *0.5, 0, WIDTH *0.5, 100)];
    [_planTimeView addSubview:GetTimeView];
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

-(void)addHeaderView{
    NSArray *a = [NSArray arrayWithObjects:@"日", @"一",@"二",@"三",@"四",@"五",@"六",nil];
    [_headerView removeFromSuperview];
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

-(void)addCollectionCell{
    CGFloat width = self.frame.size.width;
    _calendarContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 300)];
    [self addSubview:self.calendarContentView];
    _calendarContentView.hidden = YES;
    
    [self addHeaderView];
    
    int  column = 7;
    for (int i = 0; i < 35; ++i) {
        // 行索引
        int  rowIndex = i / column;
        // 列索引
        int columnIndex = i % column;
        
        CGFloat margin = 2.f;
        CGFloat cell_w = (self.bounds.size.width - 8*margin)/7;
        CGFloat org_x = margin * (columnIndex + 1) + cell_w * columnIndex;
        CGFloat org_y = margin * (rowIndex + 1) + cell_w * rowIndex + 60;
        
        AYCalendarCellView *cell = [[AYCalendarCellView alloc]initWithFrame:CGRectMake(org_x, org_y, cell_w, cell_w)];
        //        cell.controller = self.controller;
        cell.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        cell.numLabel.text = [NSString stringWithFormat:@"%d",i];
        [self.calendarContentView addSubview:cell];
        NSLog(@"%@",cell);
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
        cell.numLabel.backgroundColor = [UIColor whiteColor];
#pragma arguments-数组内包含当前日期则说明此日期时 今天，设置颜色为蓝色；
        if([self.registerArr.lastObject isEqualToString: [NSString stringWithFormat:@"%.4d-%.2d-%.2d",self.searchYear,self.searchMonth,dateNum]]){
//            cell.numLabel.backgroundColor= [Tools themeColor];
            cell.numLabel.textColor=[Tools themeColor];
            cell.numLabel.layer.masksToBounds=YES;
            cell.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
            cell.numLabel.layer.borderWidth=0;
        }
        cell.CellDateBlock = ^(NSString *dateString){
            [self getClickDate:dateString];
        };
    }
    
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

#pragma mark -- commands
- (id)hiddenBeShowing{
    if (_calendarContentView.hidden == NO) {
        optionTimeCount = 0;
        choocePostTime.userInteractionEnabled = YES;
        _planTimeView.frame = CGRectMake(_planTimeView.frame.origin.x, _planTimeView.frame.origin.y - _calendarContentView.bounds.size.height, _planTimeView.bounds.size.width, _planTimeView.bounds.size.height);
        _moreFilterBtn.frame = CGRectMake(_moreFilterBtn.frame.origin.x, _moreFilterBtn.frame.origin.y - _calendarContentView.bounds.size.height, _moreFilterBtn.bounds.size.width, _moreFilterBtn.bounds.size.height);
        
        id<AYCommand> hidden = [self.notifies objectForKey:@"hiddenCLResultTable"];
        [hidden performWithResult:nil];
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 140);
        //    self.contentSize = CGSizeMake(WIDTH, self.frame.size.height - _headerView.bounds.size.height - _calendarContentView.bounds.size.height);
        _calendarContentView.hidden = YES;
    }
    return nil;
}
@end
