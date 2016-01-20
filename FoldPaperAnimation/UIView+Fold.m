//
//  UIView+Fold.m
//  FoldPaperAnimation
//
//  Created by Moclin on 16/1/18.
//  Copyright © 2016年 Moclin. All rights reserved.
//

#import "UIView+Fold.h"
#import <objc/runtime.h>

@implementation UIView (Fold)

#pragma mark - Property

const NSString *keyOfIsFold = @"keyOfIsFold";
- (void)setIsFold:(BOOL)isFold
{
    objc_setAssociatedObject(self, &keyOfIsFold, [NSNumber numberWithBool:isFold], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isFold
{
    NSNumber *isFold = objc_getAssociatedObject(self, &keyOfIsFold);
    return isFold.boolValue;
}

const NSString *keyOfFolding = @"keyOfFolding";
- (void)setFolding:(BOOL)folding
{
    objc_setAssociatedObject(self, &keyOfFolding, [NSNumber numberWithBool:folding], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)folding
{
    NSNumber *folding = objc_getAssociatedObject(self, &keyOfFolding);
    return folding.boolValue;
}

#pragma mark - 
- (void)unfoldWithoutAnimation
{
    [self showAnimationWithIsFold:NO folds:0 duration:0 completion:nil];
}

- (void)foldWithoutAnimation
{
    [self showAnimationWithIsFold:YES folds:0 duration:0 completion:nil];
}

- (void)unfoldWithFolds:(NSInteger)folds duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion
{
    [self showAnimationWithIsFold:NO folds:folds duration:duration completion:completion];
}

- (void)foldWithFolds:(NSInteger)folds duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion
{
    [self showAnimationWithIsFold:YES folds:folds duration:duration completion:completion];
}

#pragma mark -
- (CATransformLayer *)layerWithFrame:(CGRect)frame image:(UIImage *)image foldNum:(NSInteger)foldNum isFold:(BOOL)isFold
{
    //trsformLayer
    CATransformLayer *transformLayer = [CATransformLayer layer];
    transformLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    transformLayer.anchorPoint = CGPointMake(0.5, 0);
    transformLayer.position = CGPointMake(CGRectGetWidth(frame) / 2.0, foldNum == 0 ? 0 : frame.size.height);
    
    //layer
    CALayer *contentLayer = [CALayer layer];
    contentLayer.bounds = transformLayer.bounds;
    contentLayer.position = CGPointMake(transformLayer.bounds.size.width / 2.0, transformLayer.bounds.size.height / 2.0);
    [transformLayer addSublayer:contentLayer];
    
    //image
    CGImageRef imageInRect = CGImageCreateWithImageInRect(image.CGImage, frame);
    contentLayer.contents = (__bridge id)imageInRect;
    
    //angle
    double angle = 0;
    if (foldNum == 0) {
        angle = -M_PI_2;
    } else if (foldNum % 2) {
        angle = M_PI;
    } else {
        angle = -M_PI;
    }
    //add animation
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    [animation setFromValue:[NSNumber numberWithDouble:(isFold ? 0 : angle)]];
    [animation setToValue:[NSNumber numberWithDouble:(isFold ? angle : 0)]];
    [animation setRemovedOnCompletion:NO];
    animation.fillMode = kCAFillModeForwards;   //Layer remains visible in its final state when the animation is completed.
    [transformLayer addAnimation:animation forKey:@"transformLayer"];
    
    //shadow
    if ((foldNum + 1) % 2) {
        CAGradientLayer *shadowLayer = [CAGradientLayer layer];
        shadowLayer.colors = @[(id)[UIColor clearColor],(id)[[UIColor blackColor] CGColor]];
        shadowLayer.bounds = contentLayer.bounds;
        shadowLayer.position = contentLayer.position;
        shadowLayer.opacity = isFold ? 0 : 1;
        [transformLayer addSublayer:shadowLayer];
        
        //shadow animation
        CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        shadowAnimation.fromValue = [NSNumber numberWithFloat:isFold ? 0 : 1];
        shadowAnimation.toValue = [NSNumber numberWithFloat:isFold ? 1 : 0];
        [shadowAnimation setRemovedOnCompletion:NO];
        shadowAnimation.fillMode = kCAFillModeForwards; //Layer remains visible in its final state when the animation is completed.
        [shadowLayer addAnimation:shadowAnimation forKey:@"shadowAnimation"];
    }
    
    return transformLayer;
}

#pragma mark - capture
- (UIImage *)capture
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark -
- (void)showAnimationWithIsFold:(BOOL)isFold folds:(NSInteger)folds duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion
{
    //return if self without superview.
    if (![self superview]) {
        return;
    }
    
    //return if folding.
    if (self.folding) {
        return;
    }
    
    if (self.isFold == isFold) {
        return;
    }
    
    //folding
    self.folding = YES;
    
    //save self's backgroundColor
    UIColor *bColor = self.backgroundColor;
    //image
    self.hidden = NO;
    UIImage *viewImg = [self capture];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    //add containerLayer
    CALayer *containerLayer = [CALayer layer];
    containerLayer.bounds = self.bounds;
    containerLayer.position = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);
    containerLayer.backgroundColor = self.superview.backgroundColor.CGColor;
    [self.layer addSublayer:containerLayer];
    
    //
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1 / 500.0;
    containerLayer.sublayerTransform = transform;
    
    //begin
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setCompletionBlock:^{
        containerLayer.hidden = YES;
        [containerLayer removeFromSuperlayer];
        if (isFold) {
            self.hidden = YES;
            self.isFold = YES;
        } else {
            self.hidden = NO;
            self.isFold = NO;
        }
        self.backgroundColor = bColor;
        self.folding = NO;
        
        if (completion) {
            completion(YES);
        }
    }];
    
    //config layer
    CALayer *layer = containerLayer;
    CGFloat foldHeight = CGRectGetHeight(self.frame) / (folds*1.0);
    CGRect foldFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), foldHeight);
    for (NSInteger i = 0; i < folds; i++) {
        
        foldFrame.origin.y = i * foldHeight;
        
        //add layer
        CATransformLayer *transformLayer = [self layerWithFrame:foldFrame image:viewImg foldNum:i isFold:isFold];
        [layer addSublayer:transformLayer];
        layer = transformLayer;
    }
    
    [CATransaction commit];
}

@end
