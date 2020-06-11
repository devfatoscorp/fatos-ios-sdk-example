//
//  FatosSdkUiView.h
//  Fatos
//
//  Created by 심규빈 on 2020/02/04.
//  Copyright © 2020 유춘성. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FatosMapView;

@interface FatosSdkUiView : UIView

@property (weak, nonatomic) IBOutlet UIView *sdkMenuContainer;
@property (weak, nonatomic) IBOutlet UIView *mapControlContainer;
@property (weak, nonatomic) IBOutlet UIView *rgInfoContainer;
@property (weak, nonatomic) IBOutlet UIView *searchContainer;
@property (weak, nonatomic) IBOutlet UIButton *close;
@property (weak, nonatomic) IBOutlet UIImageView *firstTbtContainer;
@property (weak, nonatomic) IBOutlet UIImageView *secondTbtContainer;
@property (weak, nonatomic) IBOutlet UIImageView *speedMeterContainer;
@property (weak, nonatomic) IBOutlet UIImageView *sdiContainer;
@property (weak, nonatomic) IBOutlet UIView *laneContainer;
@property (weak, nonatomic) IBOutlet UIView *hiPassContainer;

- (IBAction)closeClick:(id)sender;

- (void)onMapLongTouch:(int)x y:(int)y;
- (void)initSdkUiView:(FatosMapView *)pMapView searchResultDelegate:(id)delegate;
- (void)onUpdateRG:(NSString *)rgJson;
- (void)currposButtonVisible:(BOOL)visible;
- (void)mapLevelUpdate:(int)nLevel;
- (void)touchMoveMode:(int)nMode;
- (void)showSearchView:(NSString *)strResult;
- (void)hideSearchView;
- (void)setSearchCellClickDelegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
