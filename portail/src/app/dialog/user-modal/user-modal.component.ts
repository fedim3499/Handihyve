import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-user-modal',
  templateUrl: './user-modal.component.html',
  styleUrls: ['./user-modal.component.less']
})
export class UserModalComponent implements OnInit {

  constructor( @Inject(MAT_DIALOG_DATA) data: { message: string },
  public dialogRef: MatDialogRef<UserModalComponent>) { }

  ngOnInit(): void {
  }

}
