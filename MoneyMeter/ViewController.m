//
//  ViewController.m
//  MoneyMeter
//
//  Created by Fernandes, Ashley on 3/3/14.
//  Copyright (c) 2014 Intuit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *TimeFrameLabel;

@property (strong, nonatomic) IBOutlet UIView *dataView;
@property (strong, nonatomic) IBOutlet UILabel *totalPreviousLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalCurrentLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalNextLabel;

@property (strong, nonatomic) NSDate *currentDate;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.currentDate = [[NSDate alloc] init];
    [self setDateLabel:[[NSDate alloc]init]];
    
    UISwipeGestureRecognizer* swipePreviousGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipePrevious:)];
    swipePreviousGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipePreviousGestureRecognizer];
    
    UISwipeGestureRecognizer* swipeNextGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeNext:)];
    swipeNextGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeNextGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.dataView addGestureRecognizer:pinchGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDateLabel:(NSDate *)newDate {
    NSDate *today, *tomorrow, *yesterday;
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSString *timeFrameLabelText;

    self.currentDate = newDate;
    
    today = [[NSDate alloc] init];
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    NSDateComponents *yesterdayComponents = [calendar components:comps
                                                    fromDate: yesterday];
    NSDateComponents *todayComponents = [calendar components:comps
                                                    fromDate: today];
    NSDateComponents *tomorrowComponents = [calendar components:comps
                                                    fromDate: tomorrow];
    NSDateComponents *newComponents = [calendar components:comps
                                                    fromDate: newDate];
    
    NSDate *dateYesterday = [calendar dateFromComponents:yesterdayComponents];
    NSDate *dateToday = [calendar dateFromComponents:todayComponents];
    NSDate *dateTomorrow = [calendar dateFromComponents:tomorrowComponents];
    NSDate *dateNew = [calendar dateFromComponents:newComponents];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    timeFrameLabelText = [dateFormatter stringFromDate:self.currentDate];
    
    if ([dateNew compare:dateYesterday] == NSOrderedSame) {
        timeFrameLabelText = @"Yesterday";
    }
    if ([dateNew compare:dateToday] == NSOrderedSame) {
        timeFrameLabelText = @"Today";
    }
    if ([dateNew compare:dateTomorrow] == NSOrderedSame) {
        timeFrameLabelText = @"Tomorrow";
    }
    
    /*
    CGFloat offset = .1*(endyPosition - startyPosition);
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame = someView.frame;
        frame.origin.y = endyPosition + offset;
        someView.frame = frame;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:.1 animations:^{
            CGRect frame = someView.frame;
            frame.origin.y = endyPosition;
            someView.frame = frame;
        }];
    }];
    */
    
    [UIView animateWithDuration:.3 animations:^{
        self.TimeFrameLabel.layer.opacity = 0.0f;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:.2 animations:^{
            self.TimeFrameLabel.text = timeFrameLabelText;
            self.TimeFrameLabel.layer.opacity = 1.0f;
        }];
    }];
}

- (void)handleSwipePrevious:(UIGestureRecognizer*)recognizer {
    NSLog(@"swipe Prev");
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    [self setDateLabel:[self.currentDate dateByAddingTimeInterval: -secondsPerDay]];
}

- (void)handleSwipeNext:(UIGestureRecognizer*)recognizer {
    NSLog(@"swipe Next");
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    [self setDateLabel:[self.currentDate dateByAddingTimeInterval: secondsPerDay]];
}



-(void)handlePinch:(UIPinchGestureRecognizer*)sender {
    
    CGAffineTransform currentTransform = CGAffineTransformIdentity;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, [sender scale], [sender scale]);
    self.totalCurrentLabel.transform = newTransform;
    
    self.TimeFrameLabel.text = @"Month";
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSDate *newDate = [[NSDate alloc] init];
        NSLog(@"shake %@", newDate);
        [self setDateLabel:newDate];
    } 
}

@end
