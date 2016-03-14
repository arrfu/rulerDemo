//
//  ViewController.m
//  JFRulerView
//
//  Created by hao123 on 16/3/14.
//  Copyright © 2016年 JF. All rights reserved.
//

#import "ViewController.h"
#import "JFRulerView.h"

@interface ViewController ()<JFRulerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JFRulerView *ruler = [[JFRulerView alloc] init];
    [ruler rulerWithCGRect:CGRectMake(0, 100, self.view.frame.size.width, 100) image:[UIImage imageNamed:@"btn_fm_controller"]];
    [ruler changeRulerMark:93000.0];// 设置刻度尺初始值
    ruler.delagete = self;
    [self.view addSubview:ruler];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ruler delegate

-(void)frequencyRulerValueStateChangeMove:(CGFloat)frequencyValue{
    NSLog(@"value = %f",frequencyValue);
}

-(void)frequencyRulerValueStateChangeEnd:(CGFloat)frequencyValue{
    NSLog(@"value = %f",frequencyValue);
}


@end
