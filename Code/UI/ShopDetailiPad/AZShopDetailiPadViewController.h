//
//  AZShopdetailiPadViewController.h
//  AutozvukUA
//
//  Created by Serbin Taras on 04.03.16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//

#import "AZNavBarController.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKPlacemark.h>
#import "AZShop+CD.h"
#import "AZShopPin.h"

@interface AZShopDetailiPadViewController : AZNavBarController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnPrev;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UICollectionView *colPhotos;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkTime;
@property (weak, nonatomic) IBOutlet UITableView *tblPhones;
@property (strong, nonatomic) AZShop *shop;
@property (strong, nonatomic) AZShopPin *shopPin;
@property (weak, nonatomic) IBOutlet UILabel *lblShopName;
@property (weak, nonatomic) IBOutlet MKMapView *mapShops;

@end
