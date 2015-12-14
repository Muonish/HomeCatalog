//
//  RegistrationViewController.m
//  HomeCatalog
//
//  Created by Valeryia Breshko on 12/14/15.
//  Copyright © 2015 Valeria Breshko. All rights reserved.
//

#import "RegistrationViewController.h"
#import "DataBaseCommunicator.h"
#import "User.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registrationButton:(UIButton *)sender {
    if ((self.email.text.length == 0) || (self.password.text.length == 0) ||
        (self.repeatPassword.text.length == 0) || (self.firstName.text.length == 0) ||
        (self.lastName.text.length == 0) || (self.address.text.length == 0) ||
        (self.phone.text.length == 0)) {

        [self showAlertWithTitle:@"Ошибка!"
                         message:@"Заполните все поля."
                      andHandler:nil];

    } else if ([DataBaseCommunicator isUserExistsWithMail:self.email.text]) {

        [self showAlertWithTitle:@"Ошибка!"
                         message:@"Пользователь с таким e-mail уже зарегистрирован."
                      andHandler:nil];

    } else if (![self.password.text isEqualToString:self.repeatPassword.text] ||
               [self.password.text length] < 4 ) {

        [self showAlertWithTitle:@"Ошибка!"
                         message:@"Пароль не совпадает либо должен быть не короче 4 символов."
                      andHandler:nil];

    } else {

        User *user = [User sharedUser];
        user.email = self.email.text;
        user.password = self.password.text;
        user.firstName = self.firstName.text;
        user.lastName = self.lastName.text;
        user.address = self.address.text;
        user.tel = self.phone.text;
        [DataBaseCommunicator loadUser:user];

        [self showAlertWithTitle:@"Поздравляем!"
                         message:@"Регистрация успешно завершена."
                      andHandler:^(UIAlertAction *action) {
                          [self dismissViewControllerAnimated:YES completion:nil];
                      }];

    }
}

- (void) showAlertWithTitle:(NSString *)title message:(NSString *)message andHandler:(void (^)(UIAlertAction *action))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Продолжить" style:UIAlertActionStyleDefault handler:handler]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
