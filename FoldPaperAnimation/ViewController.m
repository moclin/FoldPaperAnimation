//
//  ViewController.m
//  FoldPaperAnimation
//
//  Created by Moclin on 16/1/18.
//  Copyright © 2016年 Moclin. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Fold.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UIView *foldView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *foldsLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_foldView foldWithoutAnimation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)fold:(id)sender {
    [_foldView foldWithFolds:_foldsLabel.text.intValue duration:_durationLabel.text.doubleValue completion:^(BOOL finished) {
        
    }];
}
- (IBAction)unfold:(id)sender {
    [_foldView unfoldWithFolds:_foldsLabel.text.intValue duration:_durationLabel.text.doubleValue completion:^(BOOL finished) {
        
    }];
}
- (IBAction)durationAction:(id)sender {
    UIStepper *steper = sender;
    _durationLabel.text = [NSString stringWithFormat:@"%.0f", steper.value];
}

- (IBAction)foldsAction:(id)sender {
    UIStepper *steper = sender;
    _foldsLabel.text = [NSString stringWithFormat:@"%.0f", steper.value];
}

@end
