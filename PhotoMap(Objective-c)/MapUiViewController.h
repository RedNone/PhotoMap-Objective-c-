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

@interface MapUiViewController : UIViewController

@property (strong,nonatomic) IBOutlet MKMapView* mapView;
@property (strong,nonatomic) CLLocationManager* locationManager;
@property (strong,nonatomic) CLLocation* location;

@end
