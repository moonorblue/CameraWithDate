//
//  ViewController.h
//  CameraWithDate
//
//  Created by KaeJer Cho on 14/2/28.
//  Copyright (c) 2014年 KaeJer Cho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIDatePicker *datepicker;
    NSString *date;
}
- (IBAction)click:(id)sender;
- (IBAction)time:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nonatomic)UIView *oview;
@property (strong, nonatomic) IBOutlet UIView *CamerOview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *TimeButLebel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *CamerButLabel;
- (IBAction)SelectTime:(id)sender;
- (IBAction)TakePic:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *camerView;
@property (nonatomic) UIImagePickerController *imagePickerController;
@end
