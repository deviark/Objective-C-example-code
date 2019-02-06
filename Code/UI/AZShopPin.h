//
//  ShopPin.h
//  AutozvukUA
//
//  Created by Serbin Taras on 18.01.16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AZShopPin : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *shopWorkTime;
@property (nonatomic) int16_t index;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location;
@end
