//
//  FatosSdkUiView.m
//  Fatos
//
//  Created by 심규빈 on 2020/02/04.
//  Copyright © 2020 유춘성. All rights reserved.
//

#import "FatosSdkUiView.h"
#import <FatosMapView.h>
#import <FatosUtil.h>

#import "FatosSdkMenuView.h"
#import "FatosRgInfoView.h"
#import "FatosSearchView.h"
#import <FatosMapControlView.h>
#import <FatosFirstTbT.h>
#import <FatosSecondTbT.h>
#import <FatosSpeedMeter.h>
#import <FatosSdi.h>
#import <FatosLaneView.h>
#import <FatosHiPassView.h>
#import <FatosMapViewBridge.h>
#import <FatosNaviBridge.h>
#import <FatosBaseAppDelegate.h>

@interface FatosSdkUiView()

@end

@implementation FatosSdkUiView
{
    FatosMapControlView *m_MapControlView;
    FatosSdkMenuView *m_SdkMenuView;
    FatosRgInfoView *m_RgInfoView;
    FatosSearchView *m_SearchView;
    FatosFirstTbT *m_FirstTbT;
    FatosSecondTbT *m_SecondTbT;
    FatosSpeedMeter *m_SpeedMeter;
    FatosSdi *m_Sdi;
    FatosLaneView *m_LaneView;
    FatosHiPassView *m_HiPassView;
    FatosMapView *m_MapView;
    NSBundle *resourcebundle;
    NSMutableDictionary *longTouchPosDic;
    UIAlertController *longTouchAlert;
    id searchResultDelegate;
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if(self)
    {
        self.frame = [[UIScreen mainScreen] bounds];
    }
    
    return self;
}

- (IBAction)closeClick:(id)sender
{
    if(m_SearchView != nil)
    {
        [self hideSearchView];
    }
    else if(m_MapView != nil  && [m_MapView isSummaryMode] == YES)
    {
        [m_MapView DefaultMapSetting];
    }

    [_close setHidden:YES];
}

- (void)onMapLongTouch:(int)x y:(int)y
{
    if([m_MapView isSummaryMode] == YES)
        return;
    
    if([FatosNaviBridge IsRoute] == YES)
        return;
    
    if(longTouchAlert != nil)
        return;
    
    if([self checkRectContainsPoint:_sdkMenuContainer x:x y:y] == YES)
        return;
    
    if([self checkRectContainsPoint:_mapControlContainer x:x y:y] == YES)
        return;
        
    CGRect window = [[UIScreen mainScreen] bounds];
    float scale = [[UIScreen mainScreen] scale];
    float realwidth = window.size.width * scale;
    float realheight = window.size.height * scale;
    float fCenterX = x / realwidth;
    float fCenterY = (realheight - y) / realheight;
    
    NSMutableDictionary *screenPosDic = [FatosMapViewBridge GetPosWorldFromScreen:fCenterX fCenterY:fCenterY];
    
    if(screenPosDic != nil)
    {
        int x = [[FatosUtil getStringValue:[screenPosDic valueForKey:@"x"]] intValue];
        int y = [[FatosUtil getStringValue:[screenPosDic valueForKey:@"y"]] intValue];
        
        longTouchPosDic = [FatosMapViewBridge ConvWorldtoWGS84:x y:y];
        
        if(longTouchPosDic != nil)
        {
            NSString *strXlon = [FatosUtil getStringValue:[longTouchPosDic valueForKey:@"xlon"]];
            NSString *strYlat = [FatosUtil getStringValue:[longTouchPosDic valueForKey:@"ylat"]];

            double lon = [strXlon doubleValue];
            double lat = [strYlat doubleValue];
            
            [FatosMapViewBridge SetTouchState:0];
            [FatosMapViewBridge SetPosWGS84:lon ylat:lat];
            
            NSString *strLocation = [FatosNaviBridge GetGeoCodeString:lon lat:lat];
            
            UIViewController *viewController = [FatosBaseAppDelegate getRootViewController];

            NSString *strTitle = strLocation;
            NSString *strMessage = [NSString stringWithFormat:@"X:%@ Y:%@", strXlon, strYlat];

            NSString *strOk = [FatosUtil getResourceLocalizedString:@"string_goalpoint" comment:@""];

            longTouchAlert = [UIAlertController
                                         alertControllerWithTitle:strTitle
                                         message:strMessage
                                         preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *ok = [UIAlertAction actionWithTitle:strOk style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                [self->longTouchAlert dismissViewControllerAnimated:YES completion:nil];
                self->longTouchAlert = nil;
                [FatosNaviBridge Route:@"" startLon:@"" goalLat:strYlat goalLon:strXlon];
            }];

            [longTouchAlert addAction:ok];
                        
            [viewController presentViewController:longTouchAlert animated:YES completion:^{
                [self->longTouchAlert.view.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLongTouchAlertDismiss)]];
            }];
        }
    }
}

- (BOOL)checkRectContainsPoint:(UIView *)pView x:(int)x y:(int)y
{
    if(pView == nil)
        return YES;
    
    if([pView isHidden] == YES)
        return YES;
    
    CGPoint pt;
    pt.x = x;
    pt.y = y;
     
    if (CGRectContainsPoint(pView.frame, pt) == true)
    {
        return YES;
    }
    
    return NO;
}

- (void)onLongTouchAlertDismiss
{
    [longTouchAlert dismissViewControllerAnimated:YES completion:nil];
    longTouchAlert = nil;
}

- (void)initSdkUiView:(FatosMapView *)pMapView searchResultDelegate:(id)delegate;
{
    m_MapView = pMapView;
    
    resourcebundle = [FatosUtil getResourcebundle];
    
    m_SdkMenuView = [[[NSBundle mainBundle] loadNibNamed:@"sdkmenu" owner:nil options:nil] lastObject];
    [m_SdkMenuView setSearchResultDelegate:delegate];
    [m_SdkMenuView initSdkMenuView];
    [_sdkMenuContainer addSubview:m_SdkMenuView];
    
    m_RgInfoView = [[[NSBundle mainBundle] loadNibNamed:@"rginfo" owner:nil options:nil] lastObject];
    [_rgInfoContainer addSubview:m_RgInfoView];
    
    m_MapControlView = [[resourcebundle loadNibNamed:@"mapcontrol" owner:nil options:nil] lastObject];
    [m_MapControlView initMapControlView:m_MapView];
    [_mapControlContainer addSubview:m_MapControlView];
    
    m_FirstTbT = [[resourcebundle loadNibNamed:@"firstTbt" owner:nil options:nil] lastObject];
    [m_FirstTbT initFirstTbT];
    [_firstTbtContainer addSubview:m_FirstTbT];
    [_firstTbtContainer setHidden:YES];
    
    m_SecondTbT = [[resourcebundle loadNibNamed:@"secondTbt" owner:nil options:nil] lastObject];
    [m_SecondTbT initSecondTbT];
    [_secondTbtContainer addSubview:m_SecondTbT];
    [_secondTbtContainer setHidden:YES];
    
    m_SpeedMeter = [[resourcebundle loadNibNamed:@"speedmeter" owner:nil options:nil] lastObject];
    [_speedMeterContainer addSubview:m_SpeedMeter];
    
    m_Sdi = [[resourcebundle loadNibNamed:@"sdi" owner:nil options:nil] lastObject];
    [m_Sdi initSdi];
    [_sdiContainer addSubview:m_Sdi];
    [m_Sdi setHidden:YES];
    
    m_LaneView = [[resourcebundle loadNibNamed:@"lane" owner:nil options:nil] lastObject];
    [m_LaneView initLaneView:_laneContainer];
    [_laneContainer addSubview:m_LaneView];
    [_laneContainer setHidden:YES];
    
    m_HiPassView = [[resourcebundle loadNibNamed:@"hipass" owner:nil options:nil] lastObject];
    [m_HiPassView initHiPassView:_hiPassContainer];
    [_hiPassContainer addSubview:m_HiPassView];
    [_hiPassContainer setHidden:YES];
    
    [_searchContainer setHidden:YES];
    m_SearchView = nil;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)update
{
    [_sdkMenuContainer setHidden:[m_MapView isSummaryMode]];
    [_mapControlContainer setHidden:[m_MapView isSummaryMode]];
    [_rgInfoContainer setHidden:[m_MapView isSummaryMode]];
    [_searchContainer setHidden:[m_MapView isSummaryMode]];
    [_firstTbtContainer setHidden:[m_MapView isSummaryMode]];
    [_secondTbtContainer setHidden:[m_MapView isSummaryMode]];
    [_speedMeterContainer setHidden:[m_MapView isSummaryMode]];
    [_sdiContainer setHidden:[m_MapView isSummaryMode]];
    [_laneContainer setHidden:[m_MapView isSummaryMode]];
    [_hiPassContainer setHidden:[m_MapView isSummaryMode]];
        
    if(m_SearchView != nil || (m_MapView != nil  && [m_MapView isSummaryMode] == YES))
    {
        [_close setHidden:NO];
    }
}

- (void)currposButtonVisible:(BOOL)visible
{
    if(m_MapControlView != nil)
    {
        [m_MapControlView currposButtonVisible:visible];
    }
}

- (void)mapLevelUpdate:(int)nLevel
{
    if(m_MapControlView != nil)
    {
        [m_MapControlView mapLevelUpdate:nLevel];
    }
}

- (void)touchMoveMode:(int)nMode
{
    if(m_MapControlView != nil)
    {
        [m_MapControlView touchMoveMode:nMode];
    }
}

- (void)showSearchView:(NSString *)strResult
{
    NSMutableDictionary *dic = [FatosUtil getJsonDictionary:strResult];
    
    if(dic == nil)
    {
        [self performSelector:@selector(showNoSearchResult) withObject:nil afterDelay:0.1f];
        return;
    }
    
    NSArray *items = [dic valueForKey:@"items"];
    
    if([items count] == 0)
    {
        [self performSelector:@selector(showNoSearchResult) withObject:nil afterDelay:0.1f];
        return;
    }
    
    if(m_SearchView == nil)
    {
        [_searchContainer setHidden:NO];
        m_SearchView = [[[NSBundle mainBundle] loadNibNamed:@"searchlist" owner:nil options:nil] lastObject];
        [_searchContainer addSubview:m_SearchView];
    }
    
    [m_SearchView setSearchData:dic];
}

- (void)hideSearchView
{
    if(m_SearchView != nil)
    {
        [_searchContainer setHidden:YES];
        [m_SearchView removeFromSuperview];
        m_SearchView = nil;
    }
    
    [_close setHidden:YES];
}

- (void)setSearchCellClickDelegate:(id)delegate
{
    if(m_SearchView != nil)
    {
        [m_SearchView setSearchCellClickDelegate:delegate];
    }
}

- (void)showNoSearchResult
{
    NSString *strTitle = [FatosUtil getResourceLocalizedString:@"string_results" comment:@""];
    NSString *strMessage = [FatosUtil getResourceLocalizedString:@"string_noresult_found" comment:@""];
    [FatosBaseAppDelegate showAlert:strTitle message:strMessage];
}

@end
