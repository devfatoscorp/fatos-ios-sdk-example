//
//  FatosSelectRouteLineView.h
//  Fatos
//
//  Created by 심규빈 on 2020/02/10.
//  Copyright © 2020 유춘성. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FatosSelectRouteLineDelegate <NSObject>
- (void) selectRouteLine:(int)nIndex;
@end

@interface FatosSelectRouteLineView : UIViewController

@property(strong, nonatomic) id<FatosSelectRouteLineDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
