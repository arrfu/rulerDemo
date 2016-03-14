//
//  JFRulerView.m
//  尺子
//
//  Created by arrfu on 16/1/5.
//  Copyright © 2016年
//

#import "JFRulerView.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height


#define margin 6 // 刻度间距

#define CBColor(r,g,b) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])

#define rulerStartEdge  25

@interface JFRulerView ()<UIGestureRecognizerDelegate>
{
    CGFloat movingFreValue;
}
@property (weak, nonatomic) UIView *contentView;

@end


@implementation JFRulerView

/**
 * 绘制不同国家的刻度尺
 */
-(void)rulerWithCGRect:(CGRect)frame image:(UIImage*)image{
    // 容器视图
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = frame;
//    contentView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.4];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    // 短复制层
    CAReplicatorLayer *shortRepLayer = [CAReplicatorLayer layer];
    shortRepLayer.frame = _contentView.bounds;
    
    // 设置总刻度数
    NSInteger shortCount = 45;
    shortRepLayer.instanceCount = shortCount;
    shortRepLayer.instanceTransform = CATransform3DMakeTranslation(margin, 0, 0);
    [_contentView.layer addSublayer:shortRepLayer];
    
    // 添加短的,到复制层
    CALayer *shortItem = [CALayer layer];
    shortItem.frame = CGRectMake(rulerStartEdge, 40, 1, 10);
//    shortItem.backgroundColor = [UIColor grayColor].CGColor;
    shortItem.backgroundColor = [UIColor colorWithRed:0x61/255.0f green:0x61/255.0f blue:0x61/255.0f alpha:0.5].CGColor;
    [shortRepLayer addSublayer:shortItem];
    
    
    // 长复制制层
    CAReplicatorLayer *longRepLayer = [CAReplicatorLayer layer];
    
    longRepLayer.frame = _contentView.bounds;
    
    NSInteger longcount = shortCount/10+1;
    
    // 设置总份数
    longRepLayer.instanceCount = longcount;
    
    // 每条占用的间距
    CGFloat longmargin = margin*10;
    
    longRepLayer.instanceTransform = CATransform3DMakeTranslation(longmargin, 0, 0);
    [_contentView.layer addSublayer:longRepLayer];
    
    // 添加长条,到复制层
    CALayer *longItem = [CALayer layer];
    longItem.frame = CGRectMake(rulerStartEdge+2*margin, 30, 1, 30);
    longItem.backgroundColor = [UIColor colorWithRed:0x61/255.0f green:0x61/255.0f blue:0x61/255.0f alpha:0.5].CGColor;

    [longRepLayer addSublayer:longItem];
    
    int startNumber = 88;
    // 底部数字
    for (int i = 0; i<longcount; i++) {
        UILabel *vauleLabel = [[UILabel alloc]init];
        vauleLabel.text = [NSString stringWithFormat:@"%d",startNumber+i*5];
        // label 中心点
        vauleLabel.center = CGPointMake(rulerStartEdge+i*margin*10-8+2*margin, frame.size.height*0.60);
        [vauleLabel sizeToFit];
        vauleLabel.textColor = [UIColor colorWithRed:0x61/255.0f green:0x61/255.0f blue:0x61/255.0f alpha:0.5];//[UIColor whiteColor];
        [self.contentView addSubview:vauleLabel];
    }
    
    // 添加游标
    self.rulerMarkImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.contentView.frame.origin.y, 14, 65)];
    if (image != nil) {
        self.rulerMarkImageV.image = image;
    }
    else{
        self.rulerMarkImageV.image = [JFRulerView imageWithColor:[UIColor redColor]];
    }
    
    [self addSubview:self.rulerMarkImageV];
    self.rulerMarkImageV.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.contentView addGestureRecognizer:panGesture];
//    [self.rulerMarkImageV addGestureRecognizer:panGesture];

}

/**
 * 移动游标
 */
-(void)changeRulerMark:(CGFloat)value{
    CGFloat stepValue;
    if ((value>=87500)&&(value<=108000)) {
        stepValue = (value-87500)/100;
        
        CGPoint rulerCenter = self.rulerMarkImageV.center;
        rulerCenter.x = rulerStartEdge+margin*(1+stepValue/5) + 0.6;
        self.rulerMarkImageV.center = rulerCenter;
    }
}

/**
 * 起始有效区域,返回频率值
 */
-(CGFloat)machRulerFreValue:(CGFloat)pointX{
    CGFloat rulerPointFre = 0;
    if (pointX >= rulerStartEdge) {
        NSInteger num = (pointX-rulerStartEdge)/(margin/5);
        
        rulerPointFre = 87500 + num*100;
        if (rulerPointFre>108000) {
            rulerPointFre = 108000;
        }
    }
    
    return rulerPointFre;
}

// 设置第一响应方法
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.contentView.frame, point) ) {
        return YES;
    }
    return NO;
}

#pragma mark - gesture手势
//拖动手势
-(void) panGesture:(id)sender
{
    UIPanGestureRecognizer *panGesture = sender;

    CGPoint touchpoint = [panGesture locationInView:self.contentView];
    
    if ([self machRulerFreValue:touchpoint.x]) {
        
        movingFreValue = [self machRulerFreValue:touchpoint.x];
        [self changeRulerMark:movingFreValue];

//        NSLog(@"value = %f",movingFreValue);
    }
    else if(touchpoint.x<10){ // 滑动到刻度尺开始位置
        movingFreValue = 87500;
        [self changeRulerMark:movingFreValue];
    }
    
    
    // 回调
    if ([panGesture state] == UIGestureRecognizerStateBegan) {
        
    }
    else if ([panGesture state] == UIGestureRecognizerStateChanged) {
        
        if (_delagete && [_delagete respondsToSelector:@selector(frequencyRulerValueStateChangeMove:)]) {
            [_delagete frequencyRulerValueStateChangeMove:movingFreValue];
        }
        
    }
    else if (([panGesture state] == UIGestureRecognizerStateEnded) || [panGesture state] == UIGestureRecognizerStateCancelled ) {
        
        if (_delagete && [_delagete respondsToSelector:@selector(frequencyRulerValueStateChangeEnd:)]) {
            [_delagete frequencyRulerValueStateChangeEnd:movingFreValue];
        }
        
    }
   
}


//根据颜色返回图片
+(UIImage*)imageWithColor:(UIColor*)color
{
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    CGRect rect = CGRectMake(0.0f, 0.0f, 0.1f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
