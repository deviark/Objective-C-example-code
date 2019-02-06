//
//  AZShopAnnotationView.m
//  AutozvukUA
//
//  Created by Serbin Taras on 18.01.16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//

#import "AZShopAnnotationView.h"
static float kTop = 4;
static float kLeft = 8;
static float kBottom = 4;


@implementation AZShopAnnotationView


- (instancetype)initWithAnnotation:(AZShopPin *)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    self.image = [UIImage imageNamed:@"shopPin"];
    self.canShowCallout = NO;
    [self configureView];
    self.calloutView.hidden = YES;
    return self;
}

-(void)configureView
{
    if ([self.annotation isKindOfClass:[AZShopPin class]])
    {
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(kLeft, kTop, 0, 0)];
        labelTitle.text = ((AZShopPin *)self.annotation).title;
        labelTitle.textColor = [UIColor whiteColor];
        [labelTitle sizeToFit];
        
        int titleWidth = labelTitle.frame.size.width;
        int titleHeight = labelTitle.frame.size.height;
        
        UILabel *labelWorkTime = [[UILabel alloc] initWithFrame:CGRectMake(kLeft, kTop + titleHeight + kBottom, titleWidth,titleHeight)];
        labelWorkTime.text = ((AZShopPin *)self.annotation).shopWorkTime;
        labelWorkTime.textAlignment = NSTextAlignmentCenter;
        labelWorkTime.textColor = [UIColor whiteColor];
        [labelWorkTime sizeToFit];
        if (labelWorkTime.frame.size.width > titleWidth)
        {
            titleWidth = labelWorkTime.frame.size.width;
            [labelTitle setFrame:CGRectMake(labelTitle.frame.origin.x, labelTitle.frame.origin.y, titleWidth, titleHeight)];
            labelTitle.textAlignment = NSTextAlignmentCenter;
        }
        
        float imgWidth = titleWidth + 28 + 10;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x - imgWidth + self.frame.size.width / 2, self.frame.origin.y / 2, imgWidth, titleHeight * 2 + kTop *2 + kBottom * 2)];
        UIImage *buble = [UIImage imageNamed:@"shopCallout"];
        [imgView setImage:[buble resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 28.0)]];
        imgView.alpha = 0.8;
        [imgView addSubview:labelTitle];
        [imgView addSubview:labelWorkTime];
        [imgView setUserInteractionEnabled:YES];
        [self addSubview:imgView];
        self.calloutView = imgView;
    }

}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    
    if (!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            
            if (isInside)
            {
                break;
            }
        }
    }
    
    return isInside;
}
@end
