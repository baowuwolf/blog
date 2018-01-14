//
//  UIPresentationController+PresentNotification.m
//  iOSInterfaceDemo
//
//  Created by yu cao on 2018/1/14.
//  Copyright © 2018年 wolf. All rights reserved.
//

#import "UIPresentationController+PresentNotification.h"
#import <objc/runtime.h>

NSNotificationName const CYPresentationControllerDidPresentNotification = @"CYPresentationControllerDidPresentNotification";
NSNotificationName const CYPresentationControllerDidDismissNotification = @"CYPresentationControllerDidDismissNotification";

@implementation UIPresentationController (PresentNotification)

+ (void)load {
    Method originPresnetMethod = class_getInstanceMethod(self, @selector(presentationTransitionDidEnd:));
    Method newPresnetMethod = class_getInstanceMethod(self, @selector(nty_presentationTransitionDidEnd:));
    method_exchangeImplementations(originPresnetMethod, newPresnetMethod);
    
    Method originDismissMethod = class_getInstanceMethod(self, @selector(dismissalTransitionDidEnd:));
    Method newDismissMethod = class_getInstanceMethod(self, @selector(nty_dismissalTransitionDidEnd:));
    method_exchangeImplementations(originDismissMethod, newDismissMethod);
}

- (void)nty_presentationTransitionDidEnd:(BOOL)completed {
    [self nty_presentationTransitionDidEnd:completed];
    if (completed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CYPresentationControllerDidPresentNotification object:nil];
    }
    NSLog(@"%s",__FUNCTION__);
}

- (void)nty_dismissalTransitionDidEnd:(BOOL)completed {
    [self nty_dismissalTransitionDidEnd:completed];
    if (completed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CYPresentationControllerDidDismissNotification object:nil];
    }
}


@end

