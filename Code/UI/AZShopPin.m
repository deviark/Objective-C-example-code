//
//  ShopPin.m
//  AutozvukUA
//
//  Created by Serbin Taras on 18.01.16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//

#import "AZShopPin.h"

@implementation AZShopPin
- (id)initWithCoordinates:(CLLocationCoordinate2D)location
{
    self = [super init];
    if (self != nil) {
        _coordinate = location;
    }
    return self;
}


@end
