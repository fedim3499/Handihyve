import { Component, OnInit } from '@angular/core';
import { User } from '@app/_models';
import { UserService } from '@app/_services';
import { first } from 'rxjs';
import {
    MatDialog,
    MAT_DIALOG_DATA,
    MatDialogRef,
    MatDialogTitle,
    MatDialogContent,
    MatDialogActions,
    MatDialogClose,
  } from '@angular/material/dialog';
import { UserModalComponent } from '@app/dialog/user-modal/user-modal.component';
@Component({
  selector: 'app-user',
  templateUrl: './user.component.html',
  styleUrls: ['../../assets/css/bootstrap/css/bootstrap.min.css',
  '../../assets/icon/themify-icons/themify-icons.css',
  '../../assets/icon/icofont/css/icofont.css',
  '../../assets/icon/font-awesome/css/font-awesome.min.css',
  '../../assets/pages/waves/css/waves.min.css',
  '../../assets/css/style.css',
  '../../assets/css/jquery.mCustomScrollbar.css',
  '../../assets/css/google-font.css'
 ]})
export class UserComponent implements OnInit {
    loading = false;
    users?: User[];
    dataFromDialog: any;

    constructor(private userService: UserService,
        private dialog: MatDialog
    ) { }

    ngOnInit() {
        this.loading = true;
        this.userService.getAll().pipe(first()).subscribe(users => {
            this.loading = false;
            this.users = users;
        });}
  
    addUser(){
        const dialogRef = this.dialog.open(UserModalComponent, {
            data: {
                message: 'Hello World from Edupala',
            },
          });
    }
 

}
