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

bool isSSHENabled(){
    // Get root
    if(!(setuid(0) == 0))
        NSLog(@"Failed to get root :/");
    else
        NSLog(@"Got root ;)");
    // Set up bash cmd
    NSTask *task;
    task = [[NSTask alloc ]init];
    [task setLaunchPath:@"/bin/bash"];
    NSArray *args = [NSArray arrayWithObjects:@"-l",
                 @"-c",
                 @"launchctl list | grep ssh", 
                 nil];
    [task setArguments: args];
    // Create pipe to get cmd output
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    // Run cmd
    [task launch];
    // Read pipe -> data -> string
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *string;
    string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // Check if ssh is running 
    if ([string containsString:@"com.openssh.sshd"]) {
        return YES;
    } else {
        return NO;
    }
}

void patch_setuid() {
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

void disableSSH() {
    if(!(setuid(0) == 0))
        NSLog(@"Failed to get root :/");
    else
        NSLog(@"Got root ;)");
    
    NSTask *task;
    task = [[NSTask alloc ]init];
    [task setLaunchPath:@"/bin/bash"];
    NSArray *args = [NSArray arrayWithObjects:@"-l",
                 @"-c",
                 @"killall sshd;launchctl unload /Library/LaunchDaemons/com.openssh.sshd.plist", 
                 nil];
    [task setArguments: args];
    [task launch];
}

void enableSSH() {
    if(!(setuid(0) == 0))
        NSLog(@"Failed to get root :/");
    else
        NSLog(@"Got root ;)");

    NSTask *task;
    task = [[NSTask alloc ]init];
    [task setLaunchPath:@"/bin/bash"];
    NSLog(@"NSTask Set to Launch");
    NSLog(@"This is NSTask with killall command......\n");
    NSArray *args = [NSArray arrayWithObjects:@"-l",
                 @"-c",
                 @"launchctl load /Library/LaunchDaemons/com.openssh.sshd.plist", 
                 nil];
    [task setArguments: args];
    [task launch];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    patch_setuid();

    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(screen);
    CGFloat height = CGRectGetHeight(screen);

    // Title Label
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/2 - 100, 1 * height/10, 200, 100)];
    [_titleLabel setText:@"SSH Admin"];
    [_titleLabel setFont:[UIFont systemFontOfSize:(26) weight:(1)]];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    [_titleLabel setNumberOfLines:1];
    [self.view addSubview:_titleLabel];
    
    // Killall Button
    _killAllSSHButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_killAllSSHButton addTarget:self
               action:@selector(killSSHButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    [_killAllSSHButton setTitle:@"Kill SSH Sessions" forState:UIControlStateNormal];
    [_killAllSSHButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    _killAllSSHButton.frame = CGRectMake(width/2 - 100, height/2 - 80, 200.0, 40.0);
    _killAllSSHButton.layer.cornerRadius = 10; 
    _killAllSSHButton.clipsToBounds = YES;
    _killAllSSHButton.layer.borderWidth = 2.0f;
    if (isSSHENabled()){
        _killAllSSHButton.enabled = YES;
        _killAllSSHButton.layer.borderColor = [UIColor redColor].CGColor;
        [_killAllSSHButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        _killAllSSHButton.enabled = NO;
        _killAllSSHButton.layer.borderColor = [UIColor grayColor].CGColor;
        [_killAllSSHButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    [self.view addSubview:_killAllSSHButton];
    
    // View SSH Sessions Button
    _viewSSHButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_viewSSHButton addTarget:self
        action:@selector(viewSSHButtonPressed:)
        forControlEvents:UIControlEventTouchUpInside];
    [_viewSSHButton setTitle:@"View SSH Sessions" forState:UIControlStateNormal];
    [_viewSSHButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    _viewSSHButton.frame = CGRectMake(width/2 - 100, height/2, 200.0, 40.0);
    _viewSSHButton.layer.cornerRadius = 10; 
    _viewSSHButton.clipsToBounds = YES;
    _viewSSHButton.layer.borderWidth = 2.0f;
    if (isSSHENabled()){
        _viewSSHButton.enabled = YES;
        [_viewSSHButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _viewSSHButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }else{
        _viewSSHButton.enabled = NO;
        [_viewSSHButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _viewSSHButton.layer.borderColor = [UIColor grayColor].CGColor;
    }
    [self.view addSubview:_viewSSHButton];
    
    // SSH Enabled Switch
    _sshEnabledSwitch=[[UISwitch alloc] 
        initWithFrame:CGRectMake(width/2 - 51/2, height/2 + 80, 51, 31)];
    if (isSSHENabled())
        [_sshEnabledSwitch setOn:YES];
    else
        [_sshEnabledSwitch setOn:NO];

    [_sshEnabledSwitch addTarget:self action:@selector(sshEnabledSwitch:) 
                forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_sshEnabledSwitch];

    // SSH Enabled UILabel
    _sshEnabledLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/2 - 50, height/2 + 80, 100, 100)];
    [_sshEnabledLabel setFont:[UIFont systemFontOfSize:16]];
    [_sshEnabledLabel setText:(@"SSH Enabled")];
    [_sshEnabledLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:_sshEnabledLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
// Set the notification menu to be light to contrast with the black background
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)killSSHButtonPressed:(id)sender {
    if(!(setuid(0) == 0))
        NSLog(@"Failed to get root :/");
    else
        NSLog(@"Got root ;)");
    
    NSTask *task;
    task = [[NSTask alloc ]init];
    [task setLaunchPath:@"/bin/bash"];
    NSArray *args = [NSArray arrayWithObjects:@"-l",
                 @"-c",
                 @"killall sshd", 
                 nil];
    [task setArguments: args];
    [task launch];
    // Make a popup informing the user that connections have been terminated
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Connections Killed"
                                message:@"All SSH connections killed"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"confirm")
                      style:UIAlertActionStyleCancel
                      handler:^(UIAlertAction * _Nonnull action) {
    topWindow.hidden = YES;
    }]];
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)viewSSHButtonPressed:(id)sender {
    if(!(setuid(0) == 0))
        NSLog(@"Failed to get root :/");
    else
        NSLog(@"Got root ;)");

    NSTask *task;
    task = [[NSTask alloc ]init];
    [task setLaunchPath:@"/bin/bash"];
    NSArray *args = [NSArray arrayWithObjects:@"-l",
                 @"-c",
                 @"who -u", 
                 nil];
    [task setArguments: args];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *stringOld;
    stringOld = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

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
    topWindow.hidden = YES;
    }]];
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)sshEnabledSwitch:(id)sender {
    UISwitch *sshSwitch = (UISwitch *)sender;
    if (!(sshSwitch.on)){
        _killAllSSHButton.enabled = NO;
        _viewSSHButton.enabled = NO;
        [_killAllSSHButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _killAllSSHButton.layer.borderColor = [UIColor grayColor].CGColor;
        [_viewSSHButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _viewSSHButton.layer.borderColor = [UIColor grayColor].CGColor;
        
        if(!(setuid(0) == 0))
            NSLog(@"Failed to get root :/");
        else
            NSLog(@"Got root ;)");
        
        NSTask *task;
        task = [[NSTask alloc ]init];
        [task setLaunchPath:@"/bin/bash"];
        NSArray *args = [NSArray arrayWithObjects:@"-l",
                     @"-c",
                     @"killall sshd; launchctl unload /Library/LaunchDaemons/com.openssh.sshd.plist", 
                     nil];
        [task setArguments: args];
        [task launch];

        UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = [UIViewController new];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"SSH Disabled"
                                    message:@"All SSH connections have been terminated and SSH has been disabled"
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"confirm")
                          style:UIAlertActionStyleCancel
                          handler:^(UIAlertAction * _Nonnull action) {
        topWindow.hidden = YES;
        }]];
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }else{
        _killAllSSHButton.enabled = YES;
        _viewSSHButton.enabled = YES;
        [_killAllSSHButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _killAllSSHButton.layer.borderColor = [UIColor redColor].CGColor;
        [_viewSSHButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _viewSSHButton.layer.borderColor = [UIColor whiteColor].CGColor;

        if(!(setuid(0) == 0))
            NSLog(@"Failed to get root :/");
        else
            NSLog(@"Got root ;)");

        NSTask *task;
        task = [[NSTask alloc ]init];
        [task setLaunchPath:@"/bin/bash"];
        NSArray *args = [NSArray arrayWithObjects:@"-l",
                     @"-c",
                     @"launchctl load /Library/LaunchDaemons/com.openssh.sshd.plist", 
                     nil];
        [task setArguments: args];
        [task launch];

        UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = [UIViewController new];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"SSH Enabled"
                                    message:@"SSH has been enabled"
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"confirm")
                          style:UIAlertActionStyleCancel
                          handler:^(UIAlertAction * _Nonnull action) {
        topWindow.hidden = YES;
        }]];
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}
@end
