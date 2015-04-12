//
//  ViewController.h
//  CameraWithDate
//
//  Created by KaeJer Cho on 14/2/28.
//  Copyright (c) 2014年 KaeJer Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>
@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIDatePicker *datepicker;
    NSString *date;
    UIImagePickerController *imagePicker;
    DBFilesystem *filesystem;
    DBAccount *account;
    DBPath *root;
    
}
- (IBAction)click:(id)sender;
- (IBAction)time:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nonatomic)UIView *oview;
@property (strong, nonatomic) IBOutlet UIView *CamerOview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *TimeButLebel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *CamerButLabel;
@property (weak, nonatomic) IBOutlet UIButton *CameraBut;

- (IBAction)TakePic:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *camerView;
@property (nonatomic) UIImagePickerController *imagePickerController;
@end
