//
//  ViewController.m
//  SSH Admin
///Users/oskarwirga/GitHub/TestApp/SSH Admin/SSH Admin/AppDelegate.m
//  Created by Oskar Wirga on 4/7/18.
//  Copyright © 2018 Oskar Wirga. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#include "NSTask.h"
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

@interface ViewController ()

@end

@implementation ViewController

void patch_setuid() {
    NSLog(@"patch_setuid Set to Launch");
    void* handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
    if (!handle)
        return;

    // Reset errors
    dlerror();
    typedef void (*fix_setuid_prt_t)(pid_t pid);
    fix_setuid_prt_t ptr = (fix_setuid_prt_t)dlsym(handle, "jb_oneshot_fix_setuid_now");

    const char *dlsym_error = dlerror();
    if (dlsym_error)
        return;

    ptr(getpid());
}

- (void)viewDidLoad {
    [super viewDidLoad];
    patch_setuid();
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(screen);
    CGFloat height = CGRectGetHeight(screen);

    // Title Label
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/2 - 100, 1 * height/10, 200, 100)];//Set frame of label in your viewcontroller.
    [_titleLabel setText:@"SSH Admin"];//Set text in label.
    [_titleLabel setFont:[UIFont systemFontOfSize:(26) weight:(1)]];
    [_titleLabel setTextColor:[UIColor whiteColor]];//Set text color in label.
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];//Set text alignment in label.
    [_titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];//Set line adjustment.
    [_titleLabel setNumberOfLines:1];//Set number of lines in label.
    [self.view addSubview:_titleLabel];//Add it to the view of your choice.
    
    // Killall Button
    UIButton *killAllSSHButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [killAllSSHButton addTarget:self
               action:@selector(killSSHButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    [killAllSSHButton setTitle:@"Kill SSH Sessions" forState:UIControlStateNormal];
    [killAllSSHButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [killAllSSHButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    killAllSSHButton.frame = CGRectMake(width/2 - 100, height/2 - 80, 200.0, 40.0);
    killAllSSHButton.layer.cornerRadius = 10; // this value vary as per your desire
    killAllSSHButton.clipsToBounds = YES;
    killAllSSHButton.layer.borderWidth = 2.0f;
    killAllSSHButton.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:killAllSSHButton];
    
    
    // View SSH Sessions Button
    UIButton *viewSSHButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [viewSSHButton addTarget:self
        action:@selector(viewSSHButtonPressed:)
        forControlEvents:UIControlEventTouchUpInside];
    [viewSSHButton setTitle:@"View SSH Sessions" forState:UIControlStateNormal];
    [viewSSHButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [viewSSHButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    viewSSHButton.frame = CGRectMake(width/2 - 100, height/2, 200.0, 40.0);
    viewSSHButton.layer.cornerRadius = 10; // this value vary as per your desire
    viewSSHButton.clipsToBounds = YES;
    viewSSHButton.layer.borderWidth = 2.0f;
    viewSSHButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:viewSSHButton];
    
    // SSH Enabled Switch
    _sshEnabledSwitch=[[UISwitch alloc] 
        initWithFrame:CGRectMake(width/2 - 51/2, height/2 + 80, 51, 31)];
    [_sshEnabledSwitch setOn:YES];
    [_sshEnabledSwitch addTarget:self action:@selector(sshEnabledSwitch:) 
                forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_sshEnabledSwitch];//Add it to the view of your choice.
    // SSH Enabled UILabel
    _sshEnabledLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/2 - 50, height/2 + 80, 100, 100)];
    [_sshEnabledLabel setFont:[UIFont systemFontOfSize:16]];
    [_sshEnabledLabel setText:(@"SSH Enabled")];
    [_sshEnabledLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:_sshEnabledLabel];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
/*

#define FLAG_PLATFORMIZE (1 << 1)

void platformize_me() {
    void* handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
    if (!handle) return;
    
    // Reset errors
    dlerror();
    typedef void (*fix_entitle_prt_t)(pid_t pid, uint32_t what);
    fix_entitle_prt_t ptr = (fix_entitle_prt_t)dlsym(handle, "jb_oneshot_entitle_now");
    
    const char *dlsym_error = dlerror();
    if (dlsym_error) return;
    
    ptr(getpid(), FLAG_PLATFORMIZE);
}
*/
- (IBAction)killSSHButtonPressed:(id)sender {
    //platformize_me();
    //patch_setuid();
    
    if(!(setuid(0) == 0))
        NSLog(@"Failed to get root :/");
    else
        NSLog(@"Got root ;)");

    const char *dlsym_error = dlerror();
    if (dlsym_error) {
        NSLog(@"dlerror line 147");
        NSLog(@"%s", dlsym_error);
    }

    NSTask *task;
    task = [[NSTask alloc ]init];
    [task setLaunchPath:@"/bin/bash"];
    NSLog(@"NSTask Set to Launch");
    NSLog(@"This is NSTask with killall command......\n");
    NSArray *args = [NSArray arrayWithObjects:@"-l",
                 @"-c",
                 @"killall sshd", 
                 nil];
    [task setArguments: args];
    NSLog(@"NSTask who command set to exec");
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    NSLog(@"NSTask who command exec-ing");
    [task launch];
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *stringOld;
    stringOld = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",stringOld);
    
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Connections Killed"
                                message:@"All SSH connections killed"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"confirm")
                      style:UIAlertActionStyleCancel
                      handler:^(UIAlertAction * _Nonnull action) {
    // continue your work
    // important to hide the window after work completed.
    // this also keeps a reference to the window until the action is invoked.
    topWindow.hidden = YES;
    }]];

    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)viewSSHButtonPressed:(id)sender {
    //platformize_me();
    //patch_setuid();
    
    if(!(setuid(0) == 0))
        NSLog(@"Failed to get root :/");
    else
        NSLog(@"Got root ;)");

    const char *dlsym_error = dlerror();
    if (dlsym_error) {
        NSLog(@"dlerror line 147");
        NSLog(@"%s", dlsym_error);
    }

    NSTask *task;
    task = [[NSTask alloc ]init];
    [task setLaunchPath:@"/bin/bash"];
    NSLog(@"NSTask Set to Launch");
    NSLog(@"This is NSTask with who command......\n");
    NSArray *args = [NSArray arrayWithObjects:@"-l",
                 @"-c",
                 @"who -u", 
                 nil];
    [task setArguments: args];
    NSLog(@"NSTask who command set to exec");
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    NSLog(@"NSTask who command exec-ing");
    [task launch];
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *stringOld;
    stringOld = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",stringOld);

    NSString * string = [stringOld stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSArray *array = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    int i = 0;
    int rows = [array count];
    rows = rows / 7;
    NSMutableArray *myArray = [NSMutableArray array];
    for (i = 0; i < rows; i++){
        [myArray addObject:[NSString stringWithFormat:@"%d.", (i + 1)]];
        [myArray addObject:[array objectAtIndex:((i * 7))]];
        [myArray addObject:[array objectAtIndex:((i * 7) + 6)]];
        [myArray addObject:[array objectAtIndex:((i * 7) + 1)]];
        [myArray addObject:[array objectAtIndex:((i * 7) + 3)]];
        [myArray addObject:[array objectAtIndex:((i * 7) + 2)]];
        if (i < rows - 1)
            [myArray addObject:@"\n"];
    }
    NSString *toPrint = [myArray componentsJoinedByString:@" "];

    
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"SSH Connections"
                                message:toPrint
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"confirm")
                      style:UIAlertActionStyleCancel
                      handler:^(UIAlertAction * _Nonnull action) {
    // continue your work
    // important to hide the window after work completed.
    // this also keeps a reference to the window until the action is invoked.
    topWindow.hidden = YES;
    }]];

    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)sshEnabledSwitch:(id)sender {
    
}

@end

