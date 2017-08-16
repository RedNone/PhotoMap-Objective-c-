
#import "MapUiViewController.h"
#import "MapPhotoPopUp.h"
#import "NVPhotoModel.h"
#import "NVConst.h"

@interface MapUiViewController ()
@property (assign, nonatomic) BOOL mapModeProperty;
@property (nonatomic,assign) CLLocationCoordinate2D photoLocation;

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
    [self.navigationController setNavigationBarHidden:YES animated:animated];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Location

-(void) locationManager:(CLLocationManager*)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
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

-(void) onLongPressMap:(UIGestureRecognizer*) gester{
    NSLog(@"LongPressMap");
    if(gester.state == UIGestureRecognizerStateBegan){
        CGPoint point = [gester locationInView:self.mapView];
        self.photoLocation = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
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
    [self callAlertController];
    } else{
        [self callAlertControllerWithTitle:@"Error" andWithMessage:@"Cannot Identify current location"];
    }
}

#pragma mark - UIAlertController Action

-(void) callAlertController {
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

-(NVPhotoModel*) preparePhotoModelWithUrl:(UIImage*)image {
    NVPhotoModel *newModel = [NVPhotoModel new];
    newModel.photoId = 0;
    
    NSDateFormatter* dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"MMMM dd'th',yyyy - hh:mm a"];
    
    newModel.date = [dateFormat stringFromDate:[NSDate new]];
    newModel.coordinates = [NSString stringWithFormat:@"%f,%f",self.location.coordinate.latitude,self.location.coordinate.longitude];
    newModel.photo = image;
    newModel.type  = TypeOfPhotoDefault;
           
    return newModel;
}

#pragma mark - User Data

-(void) userDataCome:(NSNotification *) notification{
    NSLog(@"DATA COME!!");
}

@end
