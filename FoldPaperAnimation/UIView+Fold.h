//
//  UIView+Fold.h
//  FoldPaperAnimation
//
//  Created by Moclin on 16/1/18.
//  Copyright © 2016年 Moclin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Fold)

- (void)unfoldWithoutAnimation;
- (void)foldWithoutAnimation;
- (void)unfoldWithFolds:(NSInteger)folds duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;
- (void)foldWithFolds:(NSInteger)folds duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;

@property (nonatomic, assign, readonly) BOOL isFold;
@property (nonatomic, assign, readonly) BOOL folding;

@end
