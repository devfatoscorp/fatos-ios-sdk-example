//
//  ViewController.m
//  test
//
//  Created by 심규빈 on 2020/02/20.
//  Copyright © 2020 fatos. All rights reserved.
//

#import "ViewController.h"
#import "FatosSdkUiView.h"
#import "FatosSearchCell.h"
#import "FatosSdkMenuView.h"
#import <FatosBaseAppDelegate.h>
#import <FatosUtil.h>
#import <FatosNaviBridge.h>
#import <FatosEnvBridge.h>
#import <FatosIndicator.h>
#import <FatosMapView.h>

@interface ViewController () <FatosMapViewDelegate, FatosSearchDelegate, FatosSearchCellDelegate>

@end

@implementation ViewController
{
    FatosSdkUiView *sdkUiView;
    FatosIndicator *indicator;
    FatosMapView *m_MapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    indicator = nil;
    
    m_MapView = [[FatosMapView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    m_MapView.delegate = self;
    
    self.view = m_MapView;
    
    sdkUiView = [[[NSBundle mainBundle] loadNibNamed:@"sdkui" owner:nil options:nil] lastObject];
    [sdkUiView initSdkUiView:m_MapView searchResultDelegate:self];
    [self.view addSubview:sdkUiView];
    
    [FatosEnvBridge SetAutoCurrentPos:YES];
    [[FatosBaseAppDelegate sharedAppDelegate] setRouteStartListener:self selector:@selector(onRouteStart:)];
    [[FatosBaseAppDelegate sharedAppDelegate] setRouteResultListener:self selector:@selector(onRouteResult:)];
    [[FatosBaseAppDelegate sharedAppDelegate] setRouteCancelListener:self selector:@selector(onRouteCancel)];
    [[FatosBaseAppDelegate sharedAppDelegate] setRouteCompleteListener:self selector:@selector(onRouteComplete)];
}


- (void) showIndicator
{
    if(indicator == nil)
    {
        indicator = [FatosIndicator new];
        indicator.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:indicator animated:NO completion:nil];
    }
}

- (void) hideIndicator
{
    if(indicator != nil)
    {
        [indicator dismissViewControllerAnimated:NO completion:nil];
        indicator = nil;
    }
}

- (void) hideKeyboard
{
    [self.view endEditing:true];
}

- (void) onRouteStart:(NSMutableDictionary *)jsonDic
{
    int nType = [[jsonDic objectForKey:@"type"] intValue];
    
    switch (nType) {
      case 0:
        [self showIndicator];
        break;
      case 1:
        [self showIndicator];
        break;
      case 2:
        break;
      default:
        break;
    }
}

- (void) onRouteResult:(NSMutableDictionary *)jsonDic
{
    int nType = [[jsonDic objectForKey:@"type"] intValue];
    
    [self hideIndicator];
}

- (void) onRouteCancel
{
    
}

- (void) onRouteComplete
{
    
}

#pragma mark - FatosMapViewDelegate

- (void) MapLevelUpdateListener:(int)nLevel
{
   if(sdkUiView != nil)
   {
       [sdkUiView mapLevelUpdate:nLevel];
   }
}

- (void) PosWorldLocationUpdateListener:(NSString *)strLocation
{
    
}

- (void) TouchMoveModeListener:(int)nMode
{
    if(nMode == 1)
    {
        //키보드 닫기
        [self hideKeyboard];
    }

    if(sdkUiView != nil)
    {
        [sdkUiView touchMoveMode:nMode];
    }
}

- (void) MapLongTouchListener:(int)x y:(int)y
{
   if(sdkUiView != nil)
   {
       [sdkUiView onMapLongTouch:x y:y];
   }
}

- (void) UpdatePickerInfo:(NSString *)strID nLong:(int)nLong nLat:(int)nLat
{
    
}

- (void) MapReadyListener
{
    
}

#pragma mark - FatosSearchDelegate

- (void) search:(NSString *)strResult
{
    [self showIndicator];
    [FatosNaviBridge Search:self selector:@selector(searchResult:) searchText:strResult];
}
#pragma mark - FatosSearchResultDelegate

- (void) searchResult:(NSString *)strResult
{
    [self hideIndicator];
    if(sdkUiView != nil)
    {
        [sdkUiView showSearchView:strResult];
        [sdkUiView setSearchCellClickDelegate:self];
    }
}

#pragma mark - FatosSearchCellDelegate

- (void) selectSearchItem:(NSDictionary *)item
{
    NSString *goalLat = [FatosUtil getStringValue:[item valueForKey:@"enty"]];
    NSString *goalLon = [FatosUtil getStringValue:[item valueForKey:@"entx"]];
    [FatosNaviBridge Route:@"0" startLon:@"0" goalLat:goalLat goalLon:goalLon];
    
    if(sdkUiView != nil)
    {
        [sdkUiView hideSearchView];
    }
}

@end
