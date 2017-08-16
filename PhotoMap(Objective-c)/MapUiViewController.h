//
//  MapUiViewController.h
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 09.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"
#import <Photos/Photos.h>

@interface MapUiViewController : BaseViewController 

@property(strong,nonatomic) IBOutlet MKMapView* mapView;
@property(strong,nonatomic) CLLocationManager* locationManager;
@property(nonatomic,strong) CLLocation *location;

@property (weak, nonatomic) IBOutlet UIButton *mapModeButton;
- (IBAction)touchOnMapModeButton:(UIButton *)sender;
- (IBAction)touchOnNewPhotoButton:(UIButton *)sender;

@end
