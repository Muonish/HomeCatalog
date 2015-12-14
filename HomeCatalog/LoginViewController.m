//
//  LoginViewController.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/14/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "LoginViewController.h"
#import "DataBaseCommunicator.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelPopover:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)enterUser:(UIButton *)sender {
    if ((self.mail.text.length == 0) || (self.password.text.length == 0)) {

        [self showAlertWithTitle:@"Ошибка!"
                         message:@"Заполните все поля."
                      andHandler:nil];

    } else if (![DataBaseCommunicator isUserLoginWithMail:self.mail.text andPassword:self.password.text]) {

        [self showAlertWithTitle:@"Ошибка!"
                         message:@"Неверный e-mail или пароль."
                      andHandler:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) showAlertWithTitle:(NSString *)title message:(NSString *)message andHandler:(void (^)(UIAlertAction *action))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Продолжить" style:UIAlertActionStyleDefault handler:handler]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
