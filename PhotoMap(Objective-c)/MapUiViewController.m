
#import "MapUiViewController.h"
#import "MapPhotoPopUp.h"
#import "NVPhotoModel.h"
#import "NVConst.h"
#import "NVSingletonFireBaseManager.h"
#import "NVMapAnnotation.h"
#import "UIImage+NVConvertImageExtension.h"
#import "SettingsViewController.h"
#import "NVCustomCalloutView.h"
#import "NVCustomAnnotationView.h"

@interface MapUiViewController () <MKMapViewDelegate>
@property(assign, nonatomic) BOOL mapModeProperty;
@property(nonatomic,assign) CLLocationCoordinate2D photoLocation;
@property(strong,nonatomic) NSMutableArray *arrayWithUserDataForMap;
@property(strong,nonatomic) NSMutableArray *arrayWithPins;
@property(nonatomic,strong) NVCustomCalloutView *currentPinView;
@end

@implementation MapUiViewController

#pragma mark - View LifeCicle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    _mapView.showsUserLocation = YES;
    
    [self.mapModeButton setTintColor:[UIColor grayColor]];
    [self.mapModeButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.mapModeButton.layer setCornerRadius:25.f];
    [self.mapModeButton.layer setBorderWidth:1.f];
    
    UILongPressGestureRecognizer *gester = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressMap:)];
    [self.mapView addGestureRecognizer:gester];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataCome:)
                                                 name:FirebaseManagerDataComeNotification
                                               object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if(changeSettingsIndicator){
        [self prepareUserDataForMap];
        changeSettingsIndicator = NO;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Location

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.location = locations.lastObject;
    
    if([locations lastObject] && self.mapModeProperty){
        MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:[[locations lastObject] coordinate]
                                                         fromEyeCoordinate:[[locations lastObject] coordinate]
                                                               eyeAltitude:100];
        [self.mapView setCamera:camera animated:YES];
    }
}

#pragma mark - Gesture Action

-(void)onLongPressMap:(UIGestureRecognizer *)gester{
    if(gester.state == UIGestureRecognizerStateBegan){
        CGPoint point = [gester locationInView:self.mapView];
        self.photoLocation = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        NSLog(@"%f,%f",self.photoLocation.latitude,self.photoLocation.longitude);
        [self callAlertController];
    }
}

#pragma mark - Buttons Action

- (IBAction)touchOnMapModeButton:(UIButton *)sender {
    if(self.location != nil){
        if(self.mapModeProperty){
        self.mapModeProperty = NO;
            [self.mapView setScrollEnabled:YES];
            [self.mapModeButton setTintColor:[UIColor grayColor]];
            [self.mapModeButton.layer setBorderColor:[UIColor grayColor].CGColor];
        }else {
            self.mapModeProperty = YES;
            [self.mapView setScrollEnabled:NO];
            [self locationManager:self.locationManager didUpdateLocations:[NSArray arrayWithObject:self.location]];
            [self.mapModeButton setTintColor:[UIColor colorWithRed:48.0/255.0  green:79.0/255.0  blue:254.0/255.0 alpha:1]];
            [self.mapModeButton.layer setBorderColor:[UIColor colorWithRed:48.0/255.0  green:79.0/255.0  blue:254.0/255.0 alpha:1].CGColor];
            
        }
    }
}

- (IBAction)touchOnNewPhotoButton:(UIButton *)sender {
    if(self.location != nil){
        self.photoLocation = [self.location coordinate];
         NSLog(@"%f,%f",self.photoLocation.latitude,self.photoLocation.longitude);
        [self callAlertController];
    } else{
        [self callAlertControllerWithTitle:@"Error" andWithMessage:@"Cannot Identify current location"];
    }
}

#pragma mark - UIAlertController Action

-(void)callAlertController {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:nil
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Take a Picture"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                imagePickerController.delegate = self;
                                                [self presentViewController:imagePickerController animated:YES completion:nil];

                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Choose from Library"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Library");
                                                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                imagePickerController.delegate = self;
                                                [self presentViewController:imagePickerController animated:YES completion:nil];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Cancel");
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NVPhotoModel *model = [self preparePhotoModelWithUrl:image];
    MapPhotoPopUp *obj = [[MapPhotoPopUp alloc] initWithFrame: CGRectMake(self.view.frame.size.width/2 - 150,self.view.frame.size.height/2 - 207, 300, 414)
                                                    withModel: model
                                            andWithController: self];
    
    [self.view addSubview:obj];
    [self.view bringSubviewToFront:obj];
}

#pragma mark - Prepare data model

-(NVPhotoModel *)preparePhotoModelWithUrl:(UIImage *)image {
    NVPhotoModel *newModel = [NVPhotoModel new];
    newModel.photoId = 0;
    
    NSDateFormatter* dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"MMMM dd'th',yyyy - hh:mm a"];
    
    newModel.date = [dateFormat stringFromDate:[NSDate new]];
    newModel.coordinates = [NSString stringWithFormat:@"%f,%f",self.photoLocation.latitude,self.photoLocation.longitude];
    newModel.photo = image;
    newModel.type  = TypeOfPhotoDefault;
           
    return newModel;
}

-(void)prepareUserDataForMap {
    if(![[NVSingletonFireBaseManager sharedManager] userData]){
        return;
    }
    
    if(self.arrayWithPins){
        [self.mapView removeAnnotations:self.arrayWithPins];
    }
    
    
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    
    bool settingsStatusNature = [userSettings boolForKey:TypeOfPhotoNature];
    bool settingsStatusFriends = [userSettings boolForKey:TypeOfPhotoFriends];
    bool settingsStatusDefault = [userSettings boolForKey:TypeOfPhotoDefault];
        
    self.arrayWithUserDataForMap = [[NSMutableArray alloc] initWithArray:[[NVSingletonFireBaseManager sharedManager] userData] copyItems:YES];
    
    for(int i = 0; i < self.arrayWithUserDataForMap.count; i++){
        NVPhotoModel *model = [self.arrayWithUserDataForMap objectAtIndex:i];
        
        if([model.type isEqualToString:TypeOfPhotoDefault]){
            if(!settingsStatusDefault){
                [self.arrayWithUserDataForMap removeObjectAtIndex:i];
                i--;
            }
        }
        if([model.type isEqualToString:TypeOfPhotoNature]){
            if(!settingsStatusNature){
                [self.arrayWithUserDataForMap removeObjectAtIndex:i];
                i--;
            }
        }
        if([model.type isEqualToString:TypeOfPhotoFriends]){
            if(!settingsStatusFriends){
                [self.arrayWithUserDataForMap removeObjectAtIndex:i];
                i--;
            }
        }
    }
    
    
    for(NVPhotoModel *model in self.arrayWithUserDataForMap){
        model.date = [self convertTimeFormatWith:model.date
                                   withOldFormat:@"MMMM dd'th',yyyy - hh:mm a"
                                andWithNewFormat:@"MM-dd-yyyy"];
    }
   
    self.arrayWithPins = [NSMutableArray arrayWithCapacity:self.arrayWithUserDataForMap.count];
    
    for(NVPhotoModel *model in self.arrayWithUserDataForMap){
        NVMapAnnotation *annotation = [NVMapAnnotation new];
        annotation.title = model.text;
        annotation.subtitle = model.date;
        annotation.photoId = model.photoId;
        annotation.photoPath = model.photoPath;
        annotation.coordinate = [self getLocationFromString:model.coordinates];
        annotation.type = model.type;
        
        [self.arrayWithPins addObject:annotation];
        [self.mapView addAnnotation:annotation];
    }
    
}

-(CLLocationCoordinate2D)getLocationFromString:(NSString *)locationString{
    NSArray *location = [locationString componentsSeparatedByString:@","];
    
    return CLLocationCoordinate2DMake([[location objectAtIndex:0] doubleValue], [[location objectAtIndex:1] doubleValue]);
}

-(NSString *)convertTimeFormatWith:(NSString*)timeString withOldFormat:(NSString*)oldFormat andWithNewFormat:(NSString*)newFormat{
    
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:oldFormat];
    
    NSDate *date = [dateFormat dateFromString:timeString];
    
    NSDateFormatter *newDateFormat = [NSDateFormatter new];
    [newDateFormat setDateFormat:newFormat];
    
    return [newDateFormat stringFromDate:date] ;
}

#pragma mark - User Data Notification

-(void)userDataCome:(NSNotification *)notification{
    if(notification.name == FirebaseManagerDataComeNotification){
         [self prepareUserDataForMap];
    }
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(NVMapAnnotation*)annotation{
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    static NSString *identifier = @"Annotation";
    
    NVCustomAnnotationView *pin = [[NVCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    pin.animatesDrop = YES;
    pin.canShowCallout = NO;
    
    if([annotation.type isEqualToString:TypeOfPhotoNature]){
       pin.pinColor = MKPinAnnotationColorGreen;
    }
    if([annotation.type isEqualToString:TypeOfPhotoFriends]){
       pin.pinColor = MKPinAnnotationColorRed;
    }
    if([annotation.type isEqualToString:TypeOfPhotoDefault]){
       pin.pinColor = MKPinAnnotationColorPurple;
    }
    
    return pin;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        
        NVMapAnnotation *annotation = view.annotation;
        NVCustomCalloutView *customView = [[NVCustomCalloutView alloc] initWithFrame: CGRectMake(view.superview.frame.origin.x-104.f, view.superview.frame.origin.y-70.f, 208.0f, 69.0f )
                                                                           withModel: [self.arrayWithUserDataForMap objectAtIndex:annotation.photoId]
                                                                   andWithController: self
                                           ];
        self.currentPinView = customView;
        [view addSubview:customView];
    }
    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [self.currentPinView removeFromSuperview];    
}

@end
