//
//  ViewController.h
//  SSH Admin
//
//  Created by Oskar Wirga on 4/7/18.
//  Copyright © 2018 Oskar Wirga. All rights reserved.
//

#import <UIKit/UIKit.h>
// Keep track of button presses
@interface ViewController : UIViewController {
    int buttonPressCount;
}
// Define our UI objects
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sshEnabledLabel;
@property (nonatomic, strong) UISwitch *sshEnabledSwitch;
@property (nonatomic, strong) UIButton *killAllSSHButton;
@property (nonatomic, strong) UIButton *viewSSHButton;
// Define our methods for these objects
void enableSSH();
void disableSSH();
- (IBAction)killSSHButtonPressed:(id)sender;
- (IBAction)viewSSHButtonPressed:(id)sender;
- (IBAction)sshEnabledSwitch:(id)sender;

@end
