//
//  ViewController.m
//  SQLiteAssignment1
//
//  Created by Sindhya on 9/23/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *documentDirectory;
    NSArray *directoryPaths;
    
    directoryPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    documentDirectory = directoryPaths[0];
    
    _dbPath = [[NSString alloc]
                     initWithString: [documentDirectory stringByAppendingPathComponent:
                                      @"userDB.db"]];
    
    NSLog(@"\nDatabasePath %@\n", documentDirectory);
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _dbPath ] == NO)
    {
        const char *dbpath = [_dbPath UTF8String];
        
        if (sqlite3_open(dbpath, &_userDatabase) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS USER_CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, LOCATION TEXT, ADDRESS TEXT, PHONE TEXT, EMAIL TEXT)";
            
            if (sqlite3_exec(_userDatabase, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSString *alertMsg = @"Failed to create table";
                [self showAlert:alertMsg];
            }
            sqlite3_close(_userDatabase);
        } else {
            NSString *alertMsg = @"Failed to open/create database";
            [self showAlert:alertMsg];
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    
    sqlite3_stmt *SQLstatement;
    const char *databasePath = [_dbPath UTF8String];
    
    if (sqlite3_open(databasePath, &_userDatabase) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO USER_CONTACTS (name, location, address, phone, email) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",
                               _txtContactName.text,_txtLocation.text, _txtAddress.text, _txtPhoneNumber.text, _txtEmail.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_userDatabase, insert_stmt,
                           -1, &SQLstatement, NULL);
        NSString *alertMsg;
        if (sqlite3_step(SQLstatement) == SQLITE_DONE)
        {
            alertMsg = @"User added";
        } else {
            alertMsg = @"Error in adding user details";
        }
        [self showAlert:alertMsg];
        sqlite3_finalize(SQLstatement);
        sqlite3_close(_userDatabase);
    }

    
}

- (void)showAlert:(NSString*)alert_message
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Add User"
                                 message:alert_message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   _txtContactName.text = @"";
                                   _txtLocation.text = @"";
                                   _txtAddress.text = @"";
                                   _txtPhoneNumber.text = @"";
                                   _txtEmail.text = @"";
                               }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}



- (IBAction)cancel:(id)sender {
    _txtContactName.text = @"";
    _txtLocation.text = @"";
    _txtAddress.text = @"";
    _txtPhoneNumber.text = @"";
    _txtEmail.text = @"";
}
@end
