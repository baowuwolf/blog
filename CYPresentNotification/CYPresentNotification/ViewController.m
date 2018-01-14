//
//  ViewController.m
//  CYPresentNotification
//
//  Created by yu cao on 2018/1/14.
//  Copyright © 2018年 yu cao. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>
#import "ViewController2.h"
#import "UIPresentationController+PresentNotification.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"presentationController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
    [self addObservers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark -- Setup

- (void)setupUI {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(100, 300, 80, 40)];
    [button setBackgroundColor:[UIColor blueColor]];
    [button addTarget:self action:@selector(clickFunction)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)addObservers {
    [self addObserver:self forKeyPath:@"presentationController" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentedSomeViewController) name:CYPresentationControllerDidPresentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentedViewControllerDidDismiss) name:CYPresentationControllerDidDismissNotification object:nil];
}

#pragma mark -- observer Methods

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    NSLog(@"%@",change);
}

- (void)presentedSomeViewController {
    NSLog(@"%s",__FUNCTION__);
}

- (void)presentedViewControllerDidDismiss {
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark -- Actions

- (void)clickFunction {
    // 以打开APPStore形式
    //    NSString * url = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1291270693&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:nil completionHandler:nil];
    
    
    //StoreKit形式
    //    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    //    storeProductVC.delegate = self;
    //    NSString * APPID = @"1291270693";
    //    NSDictionary *dic = [NSDictionary dictionaryWithObject:APPID forKey:SKStoreProductParameterITunesItemIdentifier];
    //    [storeProductVC loadProductWithParameters:dic completionBlock:^(BOOL result, NSError * _Nullable error) {
    //        if (!error) {
    //            if (NO) {
    //                [self presentViewController:storeProductVC animated:YES completion:nil];
    //            }else {
    //                ViewController2 *vc2 = [[ViewController2 alloc] init];
    //                [self presentViewController:vc2 animated:YES completion:nil];
    //            }
    //        } else {
    //            NSLog(@"ERROR:%@",error);
    //        }
    //    }];
    
    
    //Present形式
    ViewController2 *vc2 = [[ViewController2 alloc] init];
    [self presentViewController:vc2 animated:YES completion:nil];
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
