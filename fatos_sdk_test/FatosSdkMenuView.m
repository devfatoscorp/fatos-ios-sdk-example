//
//  FatosSdkMenuView.m
//  Fatos
//
//  Created by 심규빈 on 2020/01/30.
//  Copyright © 2020 유춘성. All rights reserved.
//

#import "FatosSdkMenuView.h"
#import <FatosBaseAppDelegate.h>
#import <FatosNaviBridge.h>
#import <FatosMapViewBridge.h>
#import "FatosSelectRouteLineView.h"
#import <FatosUtil.h>

@interface FatosSdkMenuView() <FatosSelectRouteLineDelegate>

@end

@implementation FatosSdkMenuView
{
    int mn_RouteIndex;
    id<FatosSearchDelegate> searchDelegate;
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if(self)
    {

    }
    
    return self;
}

-(void)initSdkMenuView
{
    mn_RouteIndex = 0;
    
    [_routeSummary setTitle:[FatosUtil getResourceLocalizedString:@"string_routesummary" comment:@""] forState:UIControlStateNormal];
    [_selectRouteIndex setTitle:[FatosUtil getResourceLocalizedString:@"string_select_route_index" comment:@""] forState:UIControlStateNormal];
    [_cancelRoute setTitle:[FatosUtil getResourceLocalizedString:@"string_cancel_route" comment:@""] forState:UIControlStateNormal];
    [_startRoute setTitle:[FatosUtil getResourceLocalizedString:@"string_start_route" comment:@""] forState:UIControlStateNormal];
    [_reRoute setTitle:[FatosUtil getResourceLocalizedString:@"string_reroute" comment:@""] forState:UIControlStateNormal];
    [_moveMapLocation setTitle:[FatosUtil getResourceLocalizedString:@"string_move_map_location" comment:@""] forState:UIControlStateNormal];
    
    _searchTextField.placeholder = [FatosUtil getResourceLocalizedString:@"string_entersearchname" comment:@""];
    
    _searchTextField.delegate = self;
    
}

- (IBAction)routeSummaryClick:(id)sender
{
    [_searchTextField resignFirstResponder];
    
    NSString *strJson = [FatosNaviBridge GetRouteSummaryJson];
    
    if([strJson length] == 0)
    {
        NSString *strTitle = [FatosUtil getResourceLocalizedString:@"string_routesummary" comment:@""];
        NSString *strMessage = [FatosUtil getResourceLocalizedString:@"string_noresult_found" comment:@""];
        
        [FatosBaseAppDelegate showAlert:strTitle message:strMessage];
    }
    else
    {
        if([FatosNaviBridge IsRoute] == YES)
        {
            NSString *strLineColor1 = @"255,108,108,255";
            NSString *strLineColor2 = @"21,181,36,255";
            NSString *strLineColor3 = @"2,228,193,255";
            NSDictionary *lineColorDic = [NSDictionary dictionaryWithObjectsAndKeys:strLineColor1, @"0", strLineColor2, @"1",strLineColor3, @"2",nil];

            float xScale = 0.5f;
            float yScale = 0.5f;
            float hCenter = 0.5f;
            float vCenter = 0.5f;
             
            [FatosMapViewBridge SummaryMapSetting:lineColorDic xScale:xScale yScale:yScale hCenter:hCenter vCenter:(float)vCenter blnViewMode:true];
        }
        else
        {
            NSString *strTitle = [FatosUtil getResourceLocalizedString:@"string_routesummary" comment:@""];
            NSString *strMessage = [FatosUtil getResourceLocalizedString:@"string_noresult_found" comment:@""];
            
            [FatosBaseAppDelegate showAlert:strTitle message:strMessage];
        }
    }
}

- (IBAction)selectRouteIndexClick:(id)sender
{
    [_searchTextField resignFirstResponder];
    
    UIViewController *viewController = [FatosBaseAppDelegate getRootViewController];
    FatosSelectRouteLineView *selectRouteLineView = [FatosSelectRouteLineView new];
    selectRouteLineView.delegate = self;
    selectRouteLineView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [viewController presentViewController:selectRouteLineView animated:NO completion:nil];
}

- (IBAction)cancelRouteClick:(id)sender
{
    [_searchTextField resignFirstResponder];
    [FatosNaviBridge CancelRoute];
}

- (IBAction)startRouteClick:(id)sender
{
    [_searchTextField resignFirstResponder];
    
    if([FatosNaviBridge IsRoute] == NO)
    {
        NSString *strTitle = [FatosUtil getResourceLocalizedString:@"string_routesummary" comment:@""];
        NSString *strMessage = [FatosUtil getResourceLocalizedString:@"string_noresult_found" comment:@""];
        
        [FatosBaseAppDelegate showAlert:strTitle message:strMessage];
    }
    else
    {
        [FatosNaviBridge StartRouteGuidance:mn_RouteIndex];
    }
}

- (IBAction)reRouteClick:(id)sender
{
    [_searchTextField resignFirstResponder];
    [FatosNaviBridge ReRoute];
}

- (IBAction)moveMapLocationClick:(id)sender
{
    [_searchTextField resignFirstResponder];
    [FatosMapViewBridge SetTouchState:0];
    [FatosMapViewBridge SetPosWGS84:126.987283 ylat:37.565750];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString *searchText = [textField text];
    
    if([searchText length] != 0)
    {
        if(searchDelegate != nil)
        {
            [searchDelegate search:searchText];
        }
        textField.text = @"";
    }
    
    return true;
}

- (void)setSearchResultDelegate:(id<FatosSearchDelegate>)delegate;
{
    searchDelegate = delegate;
}

#pragma mark - FatosSelectRouteLineDelegate

- (void) selectRouteLine:(int)nIndex
{
    mn_RouteIndex = nIndex;
    [FatosNaviBridge StartRouteGuidance:mn_RouteIndex];
}
@end
