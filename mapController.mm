//  *
//   \
//    \
//     \
//      \
//       \
//        *
// made by Martijn Mellema
// Interaction Designer from Arnhem, The Netherlands

#import "mapController.h"
#import "RMFoundation.h"



#import "RMAnnotation.h"
#import "RMMBTilesSource.h"


@interface mapController (
                          
                          
                          
                          )


@end


@implementation mapController{
    
    
}
@synthesize setZoom;
@synthesize mapView;



- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    // VIEWLOAD any retained subviews of the main view
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    setZoom = true;
    NSLog (@"loading online map");
    [[[ofxiPhoneGetAppDelegate() glViewController] glView] removeFromSuperview];
    self.mapView= [[mapSubView  alloc] initWithFrame: frame];
    
    eagleScrollView = iPhoneGetGLView();
    
    [self.mapView._mapScrollView addSubview:eagleScrollView ];
    [self.mapView._mapScrollView bringSubviewToFront:eagleScrollView];
    // for the GLView update
    self.mapView._mapScrollView.delegate = self;
    
    return self;
}


-(bool)setZoom:(bool) value
{
    setZoom = value;
    
}


- (id)initWithFrame:(CGRect)frame andTilesource:offlineSource
{
    self = [super init];
    setZoom = true;
    [[[ofxiPhoneGetAppDelegate() glViewController] glView] removeFromSuperview];
    self.mapView= [[mapSubView  alloc] initWithFrame: frame  andTilesource:offlineSource];
    eagleScrollView = iPhoneGetGLView();
    [self.mapView._mapScrollView addSubview: eagleScrollView ];
    [self.mapView._mapScrollView bringSubviewToFront: eagleScrollView];
    // for the GLView update
    self.mapView._mapScrollView.delegate = self;
    
    NSLog(@"loading map");
    
    return self;
}



- (id)initWithFrame:(CGRect)frame andOnlineTilesource:onlineSource
{
    self = [super init];
    setZoom = true;
    [[[ofxiPhoneGetAppDelegate() glViewController] glView] removeFromSuperview];
    
    self.mapView= [[mapSubView  alloc] initWithFrame: frame  andTilesource:onlineSource];
    eagleScrollView = iPhoneGetGLView();
    [self.mapView._mapScrollView addSubview:eagleScrollView ];
    [self.mapView._mapScrollView bringSubviewToFront:eagleScrollView];
    // for the GLView update
    self.mapView._mapScrollView.delegate = self;
    
    NSLog(@"loading map");
    
    return self;
}

-(mapSubView*) getMapView{
    return mapView;
}

-(void) addMarker: (NSString*) name coordinates:(CLLocationCoordinate2D) coord image: (NSString *) image
{
    RMAnnotation *Annotation = [RMAnnotation annotationWithMapView:mapView coordinate:coord andTitle: name];
    Annotation.annotationIcon = [UIImage imageNamed: image];
    [mapView addAnnotation:Annotation];
    
}


// zooming sollution
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    // for zoom stop
    
    cout<<setZoom<<endl;
    
    // allow zooming
    if (setZoom == true){
        return mapView._tiledLayersSuperview;
    } else{
        return  nil;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    iPhoneGetOFWindow()->timerLoop();
    
    // added to hold GLView into place
    eagleScrollView.center = CGPointMake(mapView._mapScrollView.contentOffset.x + ofGetWidth()/2, mapView._mapScrollView.contentOffset.y + ofGetHeight()/2);
    
    RMProjectedRect planetBounds = self.mapView._projection.planetBounds;
    self.mapView._metersPerPixel = planetBounds.size.width / self.mapView._mapScrollView.contentSize.width;
}




- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    [self.mapView correctPositionOfAllAnnotations];
    
    if (self.mapView._delegateHasAfterMapZoom)
        [self.mapView._delegate afterMapZoom:self.mapView];
    [self.mapView scrollViewDidZoom:scrollView];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}



@end
