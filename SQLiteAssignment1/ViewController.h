//
//  ViewController.h
//  SQLiteAssignment1
//
//  Created by Sindhya on 9/23/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtContactName;

@property (weak, nonatomic) IBOutlet UITextField *txtLocation;

@property (weak, nonatomic) IBOutlet UITextView *txtAddress;

@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (strong, nonatomic) NSString *dbPath;
@property (nonatomic) sqlite3 *userDatabase;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;


@end

