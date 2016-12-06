//
//  MyStarView.m
//  star
//
//  Created by wyzc03 on 16/11/9.
//  Copyright © 2016年 wyzc03. All rights reserved.
//

#import "MyStarView.h"
#define WIDTH self.frame.size.width
//星星的宽度
#define STARWIDTH (self.frame.size.width / self.numberOfStars)
@interface MyStarView ()
@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,strong) UIView * forangeView;
@property (nonatomic,strong) UIView * backgroundView;
@property (nonatomic,assign) CGFloat heheda;
@property (nonatomic,strong) NSTimer * timer;
@end
@implementation MyStarView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.numberOfStars = 5;
        self.currentScore = 0;
        self.style = HalfStar;
        [self createStarView];
        //下面的两个方法解决在ViewController或其他视图中不能直接改变星星点亮数目的bug
        [self addTimer];
        [self addObserver];
    }
    return self;
}

#pragma mark 重写setter方法
- (void)setNumberOfStars:(NSInteger)numberOfStars{
    if (_numberOfStars != numberOfStars) {
        if (numberOfStars <= 3) {
            _numberOfStars = 3;
        }else{
            _numberOfStars = numberOfStars;
        }
        //移除就视图 加载新视图
        for (UIView * vie in self.subviews) {
            [vie removeFromSuperview];
        }
        [self createStarView];
    }
}
- (void)setCurrentScore:(CGFloat)currentScore{
    weakTypeof(self);
    if (currentScore > _numberOfStars) {
        _currentScore = _numberOfStars;
        [UIView animateWithDuration:0 animations:^{
            tempself.forangeView.frame = CGRectMake(0, 0, _currentScore * STARWIDTH, tempself.frame.size.height);
        }];
        return;
    }else if (currentScore < 0){
        _currentScore = 0;
        [UIView animateWithDuration:0 animations:^{
            tempself.forangeView.frame = CGRectMake(0, 0, _currentScore * STARWIDTH, tempself.frame.size.height);
        }];
        return;
    }
    _currentScore = [self judgeStyleWithScore:currentScore];
    [UIView animateWithDuration:0 animations:^{
        tempself.forangeView.frame = CGRectMake(0, 0, _currentScore * STARWIDTH, tempself.frame.size.height);
    }];
}
#pragma mark 设置承载星星的视图
- (void)createStarView{
    _backgroundView = [self createStarWithImageName:@"gray"];
    [self addSubview:_backgroundView];
    [self makeAllStarImageViewConstrainsOnView:_backgroundView superView:self];
    
    _forangeView = [self createStarWithImageName:@"yellow"];
    [self addSubview:_forangeView];
    [self makeAllStarImageViewConstrainsOnView:_forangeView superView:self];
    //给自身添加手势控制器
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
}


#pragma mark 添加星星✨
- (UIView *)createStarWithImageName:(NSString *)imageName{
    self.imageArray = [NSMutableArray array];
    UIView * contentView = [[UIView alloc]init];
    //设置clips to bounds 为 YES 可以展示View上的size大小的内容 其他内容不展示变成透明状态(其余部分被掩盖掉)
    contentView.clipsToBounds = YES;
    
    for (int i = 0; i < self.numberOfStars; i ++) {
        UIImageView * imageV = [[UIImageView alloc]init];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.userInteractionEnabled = YES;
        imageV.image = [UIImage imageNamed:imageName];
        [contentView addSubview:imageV];
        [self.imageArray addObject:imageV];
    }
    return contentView;
}



#pragma mark 设置两个以上星星的约束
- (void)makeAllStarImageViewConstrainsOnView:(UIView *)view superView:(UIView *)superView{
    weakTypeof(superView);
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(tempsuperView);
    }];
    for (int i = 0; i < self.imageArray.count; i ++) {
        UIImageView * image1 = self.imageArray[i];
        NSInteger index = i + 1;
        if (i + 1 == self.imageArray.count) {
            index = self.imageArray.count - 2;
        }
        UIImageView * image2 = self.imageArray[index];
        [image1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
        }];
        
        if (i == 0) {
            [image1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view);
                make.right.equalTo(image2.mas_left);
                make.width.equalTo(image2);
            }];
        }else if (i == self.imageArray.count - 1){
            [image1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view);
                make.left.equalTo(image2.mas_right);
            }];
            if (self.numberOfStars == 2) {
                [image1 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(image2.mas_left);
                    make.width.equalTo(image2);
                }];
            }
        }else{
            
            [image1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(image2.mas_left);
                make.width.equalTo(image2);
            }];
        }
    }
}

#pragma mark 手势控制器走的方法
//点击星星
- (void)tapAction:(UITapGestureRecognizer *)tap{
    weakTypeof(self);
    CGPoint point = [tap locationInView:self];
    CGFloat score = point.x;
    _currentScore = [self judgeStyleWithScore:score / STARWIDTH];
    [UIView animateWithDuration:0.1 animations:^{
        tempself.forangeView.frame = CGRectMake(0, 0, _currentScore * STARWIDTH, self.frame.size.height);
    }];
}
//滑动星星
- (void)panAction:(UIPanGestureRecognizer *)pan{
    weakTypeof(self);
    CGPoint point = [pan locationInView:self];
    CGFloat score = point.x;
    //消除将forangeView滑动出界的影响
    if (point.x<=0) {
        score = 0;
    }
    _currentScore = [self judgeStyleWithScore:score / STARWIDTH];
    [UIView animateWithDuration:0.1 animations:^{
        tempself.forangeView.frame = CGRectMake(0, 0, _currentScore * STARWIDTH, self.frame.size.height);
    }];
}

#pragma mark 判断显示类型 并返回对应的星星数
- (CGFloat)judgeStyleWithScore:(CGFloat)currentScore{
    switch (_style) {
        case WholeStar:
        {
            //允许0星
            if (currentScore < 0.5) {
                return 0;
            }
            return ceilf(currentScore);//ceilf向大数取整
            break;
        }
        case HalfStar:
            //允许0星
            if (currentScore <= 0.25) {
                return 0;
            }
            //currentScore - 0.1变为5舍6入
            return roundf(currentScore - 0.1)>=currentScore ? ceilf(currentScore):(ceilf(currentScore)-0.5);//roundf四舍五入
            break;
        case IncompleteStar:
            return currentScore;
            break;
        default:
            break;
    }
}

#pragma mark 解决在ViewController或其他视图中不能直接改变星星点亮数目的bug
- (void)addTimer{
    weakTypeof(self);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        //当WIDTH的值发生变化的时候 说明视图已经有frame了
        tempself.heheda = WIDTH;
    }];
}

- (void)addObserver{
    [self addObserver:self forKeyPath:@"heheda" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    self.currentScore = _currentScore;
    [self.timer invalidate];
    self.timer = nil;
}
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"heheda"];
}

@end
