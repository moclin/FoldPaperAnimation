# FoldPaperAnimation
FoldPaperAnimation

 ![image](https://github.com/moclin/FoldPaperAnimation/raw/master/FoldPaperAnimation/demo@2x.png)

#English
##What?

Make the UIView esay to achieve effect of paper fold.

##Use

1. #import "UIView+Fold.h"

2. use the following API to …

- (void)unfoldWithoutAnimation; //To unfold without animation.
- (void)foldWithoutAnimation; //To fold without animation.
- (void)unfoldWithFolds:(NSInteger)folds duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;
//To unfold with animation.
- (void)foldWithFolds:(NSInteger)folds duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;
//To fold with animation.


#中文
##这是什么?

让UIView可以快速地实现折纸（多层折叠）效果

##如何使用

1. #import "UIView+Fold.h"

2. 使用以下API可快速地实现…

- (void)unfoldWithoutAnimation; //无动画展开
- (void)foldWithoutAnimation; //无动画折叠
- (void)unfoldWithFolds:(NSInteger)folds duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;
//有动画展开
- (void)foldWithFolds:(NSInteger)folds duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;
//有动画折叠

