//
//  AZShopAnnotationView.h
//  AutozvukUA
//
//  Created by Serbin Taras on 18.01.16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "AZShopPin.h"


@interface AZShopAnnotationView : MKAnnotationView
@property (nonatomic, strong) UIView *calloutView;

@end
