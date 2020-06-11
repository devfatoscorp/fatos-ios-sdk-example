//
//  FatosRgInfoView.m
//  Fatos
//
//  Created by 심규빈 on 2020/02/04.
//  Copyright © 2020 유춘성. All rights reserved.
//

#import "FatosRgInfoView.h"
#import <FatosUtil.h>
#import <FatosNaviBridge.h>
#import <FatosMapViewBridge.h>
#import <FatosBaseAppDelegate.h>
@interface FatosRgInfoView()

@end

@implementation FatosRgInfoView
{
    CGFloat mf_Lable_pos_y;
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if(self)
    {
        [self initRgInfoView];
    }
    
    return self;
}

-(void)initRgInfoView
{
    mf_Lable_pos_y = 0.0f;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void) update
{
    NSMutableDictionary *info = [[FatosBaseAppDelegate sharedAppDelegate] getDriveInfo];
    
    // 일단 데이터 다 지우고
    for (UIView *v in self.scrollView.subviews) {
        [v removeFromSuperview];
        mf_Lable_pos_y = 0.0f;
    }

    if(info != nil && [info count] > 0)
    {
        NSString *strMapCenterPos = [NSString stringWithFormat:@"%f, %f",[[info objectForKey:@"center_lon"] floatValue] ,[[info objectForKey:@"center_lat"] floatValue]];
        
        [self addLabel:@"speed" value:[info objectForKey:@"speed"]];
        [self addLabel:@"isroute" value:[info objectForKey:@"isroute"]];
        [self addLabel:@"cur pos" value:[info objectForKey:@"cur_pos"]];
        [self addLabel:@"cur lonx" value:[info objectForKey:@"cur_lonx"]];
        [self addLabel:@"cur laty" value:[info objectForKey:@"cur_laty"]];
        [self addLabel:@"angle" value:[info objectForKey:@"angle"]];
        [self addLabel:@"gpsStatus" value:[info objectForKey:@"gpsStatus"]];
        
        [self addLabel:@"remain distance" value:[info objectForKey:@"remain_distance"]];
        
        [self addLabel:@"remain time" value:[info objectForKey:@"remain_time"]];
        [self addLabel:@"center pos" value:strMapCenterPos];
    }
}

- (void)addLabel:(NSString *)key value:(NSString *)value
{
    CGFloat height = 14;
    CGRect frame = self.scrollView.frame;
    CGRect rect = CGRectMake(10, mf_Lable_pos_y, frame.size.width, height);
    
    NSString *text = @"### ";
    text = [text stringByAppendingString:key];
    text = [text stringByAppendingString:@" : "];
    text = [text stringByAppendingString:value];
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    
    [self.scrollView addSubview:label];
    mf_Lable_pos_y += height;
}

@end
