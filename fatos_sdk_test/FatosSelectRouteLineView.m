//
//  FatosSelectRouteLineView.m
//  Fatos
//
//  Created by 심규빈 on 2020/02/10.
//  Copyright © 2020 유춘성. All rights reserved.
//

#import "FatosSelectRouteLineView.h"
#import <FatosUtil.h>

@interface FatosSelectRouteLineView ()

@end

@implementation FatosSelectRouteLineView

- (void)loadView{
    
    UIView *selectrouteline = [[[NSBundle mainBundle] loadNibNamed:@"selectrouteline" owner:nil options:nil] lastObject];

    selectrouteline.frame = [[UIScreen mainScreen] bounds];
    self.view = selectrouteline;
    
    UIButton *btn1 = [selectrouteline viewWithTag:0];
    UIButton *btn2 = [selectrouteline viewWithTag:1];
    UIButton *btn3 = [selectrouteline viewWithTag:2];
    
    [btn1 addTarget:self action:@selector(selectRouteLine:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(selectRouteLine:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(selectRouteLine:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn1 setTitle:[FatosUtil getResourceLocalizedString:@"fmp_txt_setting_route_option_summary_1" comment:@""] forState:UIControlStateNormal];
    [btn2 setTitle:[FatosUtil getResourceLocalizedString:@"fmp_txt_setting_route_option_summary_4" comment:@""] forState:UIControlStateNormal];
    [btn3 setTitle:[FatosUtil getResourceLocalizedString:@"fmp_txt_setting_route_option_summary_6" comment:@""] forState:UIControlStateNormal];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDismiss)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)onDismiss
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
     
- (void)selectRouteLine:(id)sender
{
    NSInteger tag = ((UIButton*)sender).tag;
    
    if(_delegate != nil)
    {
        int nIndex = 0;
        
        if(tag == 0)
        {
            nIndex = 0;
        }
        else if(tag == 1)
        {
            nIndex = 8;
        }
        else if(tag == 2)
        {
            nIndex = 32;
        }
        
        [_delegate selectRouteLine:nIndex];
    }
        
    [self onDismiss];
}

@end
