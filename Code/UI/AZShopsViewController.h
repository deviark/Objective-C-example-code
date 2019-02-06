//
//  AZShopsViewController.h
//  AutozvukUA
//
//  Created by Serbin Taras on 15.01.16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZNavBarController.h"
#import <CoreLocation/CoreLocation.h>
#import "AZWebAPI.h"
#import <MapKit/MapKit.h>
#import "AZShopPin.h"
#import "AZShopAnnotationView.h"
#import "AZShopsCollectionViewCell.h"

@interface AZShopsViewController :  AZNavBarController <CLLocationManagerDelegate, UIAlertViewDelegate, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapShops;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;
@property (weak, nonatomic) IBOutlet UIButton *btnShops;
@property (strong, nonatomic) NSArray *shops;
@property (weak, nonatomic) IBOutlet UIButton *btnShowUserLocation;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UICollectionView *colViewShops;
- (IBAction)showUserLocationTaped:(id)sender;

@end
