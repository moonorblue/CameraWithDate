//
//  ViewController.m
//  CameraWithDate
//
//  Created by KaeJer Cho on 14/2/28.
//  Copyright (c) 2014年 KaeJer Cho. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self datePickInit];
   
   // [self performSelector:@selector(Camerainit) withObject:nil afterDelay:0];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"hii"); [self Camerainit];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)Camerainit
{
    

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    //imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.showsCameraControls = NO;
    imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    
    [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
    
    self.CamerOview.frame = imagePicker.cameraOverlayView.frame;

    imagePicker.cameraOverlayView = self.CamerOview;
    
    self.CamerOview = nil;
    
    self.imagePickerController = imagePicker;
    [self presentViewController:self.imagePickerController animated:NO completion:nil];
   
    //[self.toolBar setFrame:CGRectMake(0, 425, 320, 140)];
    [self datePickInit];
    
    
}
- (IBAction)click:(id)sender {
     [self Camerainit];
}

- (IBAction)time:(id)sender {
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //get img
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *img;
    
    if (image.size.height > image.size.width) {
        NSLog(@"1");
        img = [ViewController drawText:date
                                        inImage:image
                                        atPoint:CGPointMake(1600, 2900)];
       

    }
    else{
        NSLog(@"2");
     img = [ViewController drawText:date
                                inImage:image
                                atPoint:CGPointMake(2300, 2200)];
          }
    
    
    UIImageWriteToSavedPhotosAlbum(img, self,
                                   nil,
                                   nil);
    
    //移除Picker
    [picker dismissModalViewControllerAnimated:NO];
    
}
- (void)datePickInit
{
 
    //UIDatePicker *oneDatePicker = [[UIDatePicker alloc] init];
    self.DatePicker.frame = CGRectMake(0, 425, 260, 200);

    //oneDatePicker.frame = CGRectMake(0, 20, 320, 300); // 设置显示的位置和大小
    
    self.DatePicker.date = [NSDate date]; // 设置初始时间
    // [oneDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:48 * 20 * 18] animated:YES]; // 设置时间，有动画效果
    self.DatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"]; // 设置时区，中国在东八区
    //oneDatePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60 * -1]; // 设置最小时间
    //oneDatePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60]; // 设置最大时间
    
    
    self.DatePicker.datePickerMode = UIDatePickerModeDate; // 设置样式
    // 以下为全部样式
    // typedef NS_ENUM(NSInteger, UIDatePickerMode) {
    //    UIDatePickerModeTime,           // 只显示时间
    //    UIDatePickerModeDate,           // 只显示日期
    //    UIDatePickerModeDateAndTime,    // 显示日期和时间
    //    UIDatePickerModeCountDownTimer  // 只显示小时和分钟 倒计时定时器
    // };
    
    
    [self.DatePicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加监听器
    
   // [self.view addSubview:oneDatePicker]; // 添加到View上
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy/MM/dd";
    date = [selectDateFormatter stringFromDate:self.DatePicker.date];
    self.time.text = date;//get date

}
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {
    
    NSDate *select = [sender date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy/MM/dd"; // 设置时间和日期的格式
    date = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
    
    self.time.text = date;
    
   
    NSLog(@"%@", [sender date]);
}


- (void)renderView:(UIView*)view inContext:(CGContextRef)context
{
    // -renderInContext: renders in the coordinate space of the layer,
    // so we must first apply the layer's geometry to the graphics context
    CGContextSaveGState(context);
 
    // Center the context around the window's anchor point
    CGContextTranslateCTM(context, [view center].x, [view center].y - 72);
    // Apply the window's transform about the anchor point
    CGContextConcatCTM(context, [view transform]);
    // Offset by the portion of the bounds left of and above the anchor point
    CGContextTranslateCTM(context,
                          -[view bounds].size.width * [[view layer] anchorPoint].x,
                          -[view bounds].size.height * [[view layer] anchorPoint].y);
    
    // Render the layer hierarchy to the current context
    [[view layer] renderInContext:context];
    
    // Restore the context
    CGContextRestoreGState(context);
}


+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    NSLog(@"hi");

    UIFont *font = [UIFont boldSystemFontOfSize:150];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor redColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;}

-(UIImage *)resizeImage:(UIImage *)anImage width:(int)width height:(int)height
{
    
    CGImageRef imageRef = [anImage CGImage];
    
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    if (alphaInfo == kCGImageAlphaNone)
        alphaInfo = kCGImageAlphaNoneSkipLast;
    
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width, CGImageGetColorSpace(imageRef), alphaInfo);
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}

- (IBAction)SelectTime:(id)sender {
}

- (IBAction)TakePic:(id)sender {
    [self.imagePickerController takePicture];

}



@end
