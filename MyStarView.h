//
//  MyStarView.h
//  star
//
//  Created by wyzc03 on 16/11/9.
//  Copyright © 2016年 wyzc03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#define weakTypeof(obj)  __weak typeof(obj) temp##obj = obj
typedef NS_ENUM(NSInteger, ShowStarStyle)
{
    WholeStar = 0, //只能整星评论
    HalfStar = 1,  //允许半星评论
    IncompleteStar = 2  //允许不完整星评论
};
@interface MyStarView : UIView
@property (nonatomic,assign) NSInteger numberOfStars;//默认5星,最少3星
@property (nonatomic,assign) CGFloat currentScore;//范围0 - numberOfStars,默认星星最大数
@property (nonatomic,assign) ShowStarStyle style;//默认是HalfStar
@end
