//
//  JFRulerView.h
//  尺子
//
//  Created by arrfu on 16/1/5.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol JFRulerDelegate <NSObject>

-(void)frequencyRulerValueStateChangeMove:(CGFloat)frequencyValue; // 频率滑动回调
-(void)frequencyRulerValueStateChangeEnd:(CGFloat)frequencyValue; // 频率滑动回调 松手

@end

@interface JFRulerView : UIView

@property (nonatomic,strong) UIImageView *rulerMarkImageV; // 滑动游标
-(void)rulerWithCGRect:(CGRect)frame image:(UIImage*)image;
-(void)changeRulerMark:(CGFloat)value;

@property(nonatomic,unsafe_unretained)id<JFRulerDelegate>delagete;
@end
