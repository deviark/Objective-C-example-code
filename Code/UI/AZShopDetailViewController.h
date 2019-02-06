//
//  AZShopDetailViewController.h
//  AutozvukUA
//
//  Created by Serbin Taras on 21.01.16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKPlacemark.h>
#import "AZShop+CD.h"
#import "AZShopPin.h"
@interface AZShopDetailViewController : AZNavBarController <UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *imgLarge;
@property (weak, nonatomic) IBOutlet UIButton *btnNextImg;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevImg;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkTime;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionPhone;
@property (weak, nonatomic) IBOutlet MKMapView *mapShops;
@property (strong, nonatomic) AZShop *shop;
@property (strong, nonatomic) AZShopPin *shopPin;
@property (weak, nonatomic) IBOutlet UILabel *lblShopName;

@end
