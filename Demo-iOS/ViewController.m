//
//  ViewController.m
//  Demo-iOS
//
//  Created by Jason Anderson on 4/13/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//

#import "ViewController.h"
#import <KSOTextInputEditText/KSOTextInputEditTextField.h>

@interface ViewController ()

@property (weak,nonatomic) IBOutlet UITextField *normalTextField;
@property (weak,nonatomic) IBOutlet KSOTextInputEditTextField *customTextField;

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


@end
