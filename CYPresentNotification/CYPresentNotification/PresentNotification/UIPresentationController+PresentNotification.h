//
//  UIPresentationController+PresentNotification.h
//  iOSInterfaceDemo
//
//  Created by yu cao on 2018/1/14.
//  Copyright © 2018年 wolf. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSNotificationName const CYPresentationControllerDidPresentNotification;//得到有controllerPresent的通知
UIKIT_EXTERN NSNotificationName const CYPresentationControllerDidDismissNotification;//得到Present的controllerDissmiss的通知

@interface UIPresentationController (PresentNotification)

@end



