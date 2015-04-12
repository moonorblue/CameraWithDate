//
//  ViewController.m
//  CameraWithDate
//
//  Created by KaeJer Cho on 14/2/28.
//  Copyright (c) 2014年 KaeJer Cho. All rights reserved.
//

#import "ViewController.h"
#import <Dropbox/Dropbox.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];

    [super viewDidLoad];
    [self datePickInit];
    [self linkDropBox];
//    [self checkAccount];
}
- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    DBAccount *myaccount = [[DBAccountManager sharedManager]linkedAccount];
    if(myaccount){
        if (![user objectForKey:@"isLink"]) {
            filesystem = [[DBFilesystem alloc]initWithAccount:myaccount];
            [DBFilesystem setSharedFilesystem:filesystem];
            [user setObject:@"yes" forKey:@"isLink"];
        }
       
        NSLog(@"link");
        root = [DBPath root];
    }
    else{
        NSLog(@"not link");
    }
}
- (void)linkDropBox
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![user objectForKey:@"isLogin"]) {
         [[DBAccountManager sharedManager] linkFromController:self];
    }
    DBAccount *myaccount = [[DBAccountManager sharedManager]linkedAccount];
    filesystem = [[DBFilesystem alloc]initWithAccount:myaccount];
    [DBFilesystem setSharedFilesystem:filesystem];

//     [[DBAccountManager sharedManager] linkFromController:self];
}

- (void)viewDidAppear:(BOOL)animated {

    [self Camerainit];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)Camerainit
{
    

    imagePicker = [[UIImagePickerController alloc] init];
    
    
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //get img
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *img;
    CGSize newSize;
    if (image.size.height > image.size.width) {
        //portrait
        img = [ViewController drawText:date
                                        inImage:image
                                        atPoint:CGPointMake(1600, 2900)];

        newSize.width = 600;
        newSize.height = 800;
    }
    else
    {
        //landscape

        img = [ViewController drawText:date
                                inImage:image
                                atPoint:CGPointMake(2300, 2200)];

        newSize.width = 800;
        newSize.height = 600;
          }
 
    
    UIImage *reSized = [self reSizeImage:img toSize:newSize];
    
    UIImageWriteToSavedPhotosAlbum(reSized, self,
                                   nil,
                                   nil);
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
//    NSData *myData = UIImagePNGRepresentation(reSized);
    NSData *myData = UIImageJPEGRepresentation(reSized, 0.5);
    
//    [self creatFolder:strDate];
    
    [self writeData:strDate withData:myData];
    
    //移除Picker
//    [picker dismissModalViewControllerAnimated:NO];
    [picker dismissViewControllerAnimated:NO completion:nil];
    
}

-(void)creatFolder:(NSString *)folderName
{
//    DBPath *path = [DBPath root];
//    NSLog(@"%@",[path stringValue]);
//    NSLog(@"%@",[[path stringValue]lastPathComponent]);
    DBPath *path = [root childPath:folderName];
    
    BOOL success = [filesystem createFolder:path error:nil];
    if (!success) {
        NSLog(@"Unable to be create folder");
    }
}
-(void)writeData:(NSString *)name withData:(NSData *)data
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *forDate = [dateFormatter stringFromDate:[NSDate date]];

    DBPath *path = [root childPath:name];
    
    DBPath *newPath = [path childPath:[NSString stringWithFormat:@"%@.jpg",forDate]];

    DBFile *file = [filesystem createFile:newPath error:nil];
    
    [file writeData:data error:nil];
}
//- (void)createAt:(NSString *)input {
//    
//    if (!_creatingFolder) {
//        NSString *noteFilename = [NSString stringWithFormat:@"%@.txt", input];
//        DBPath *path = [_root childPath:noteFilename];
//        DBFile *file = [_filesystem createFile:path error:nil];
//        
//        DBPath *newPath = [_root childPath:[NSString stringWithFormat:@"%@.mov",input]];
//        DBFile *myfile = [_filesystem createFile:newPath error:nil];
//        //        [myfile writeString:@"Hello World!" error:nil];
//        
//        //        UIImage *myImg = [UIImage imageNamed:@"anna"];
//        //        NSData *myData = UIImageJPEGRepresentation(myImg,0.0);
//        //        [myfile writeData:myData error:nil];
//        
//        
//        
//        NSString *mypath = [[NSBundle mainBundle] pathForResource:@"shoo" ofType:@"mov" ];
//        NSData *newData = [NSData dataWithContentsOfFile:mypath];
//        [myfile writeData:newData error:nil];
//        
//        //        DBPath *existingPath = [_root childPath:@"data"];
//        //        DBFile *afile = [_filesystem openFile:existingPath error:nil];
//        //        NSData *contents = [afile readData:nil];
//        //        NSLog(@"%@", contents);
//        
//        
//        
//        if (!file) {
//            Alert(@"Unable to create note", @"An error has occurred");
//        } else {
//            NoteController *controller = [[NoteController alloc] initWithFile:file];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//    } else {
//        DBPath *path = [_root childPath:input];
//        BOOL success = [_filesystem createFolder:path error:nil];
//        if (!success) {
//            Alert(@"Unable to be create folder", @"An error has occurred");
//        } else {
//            NotesFolderListController *controller =
//            [[NotesFolderListController alloc] initWithFilesystem:_filesystem root:path];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//    }
//}

- (void)datePickInit
{
 
    //UIDatePicker *oneDatePicker = [[UIDatePicker alloc] init];
//    self.DatePicker.frame = CGRectMake(0, 425, 260, 200);

    //oneDatePicker.frame = CGRectMake(0, 20, 320, 300); // 设置显示的位置和大小
    
    self.DatePicker.date = [NSDate date]; // 设置初始时间
    self.DatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"]; // 设置时区，中国在东八区
    self.DatePicker.datePickerMode = UIDatePickerModeDate; // 设置样式
    
    
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
    UIFont *font = [UIFont boldSystemFontOfSize:150];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor redColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;}

//-(UIImage *)resizeImage:(UIImage *)anImage width:(int)width height:(int)height
//{
//    
//    CGImageRef imageRef = [anImage CGImage];
//    
//    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
//    
//    if (alphaInfo == kCGImageAlphaNone)
//        alphaInfo = kCGImageAlphaNoneSkipLast;
//    
//    
//    CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width, CGImageGetColorSpace(imageRef), alphaInfo);
//    
//    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
//    
//    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
//    UIImage *result = [UIImage imageWithCGImage:ref];
//    
//    CGContextRelease(bitmap);
//    CGImageRelease(ref);
//    
//    return result;
//}


- (IBAction)TakePic:(id)sender {
    [self.imagePickerController takePicture];

}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

@end
