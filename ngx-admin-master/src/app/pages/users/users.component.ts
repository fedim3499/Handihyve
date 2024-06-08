import { Component } from '@angular/core';
import { LocalDataSource } from 'ng2-smart-table';
import { UserService } from '../../@core/mock/users.service';

@Component({
  selector: 'ngx-users',
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.scss']
})
export class UsersComponent {
  settings = {
    add: {
      addButtonContent: '<i class="nb-plus"></i>',
      createButtonContent: '<i class="nb-checkmark"></i>',
      cancelButtonContent: '<i class="nb-close"></i>',
      confirmCreate : true
    },
    edit: {
      editButtonContent: '<i class="nb-edit"></i>',
      saveButtonContent: '<i class="nb-checkmark"></i>',
      cancelButtonContent: '<i class="nb-close"></i>',
      confirmSave : true
    },
    delete: {
      deleteButtonContent: '<i class="nb-trash"></i>',
      confirmDelete: true,
    },
    columns: {
    
      firstName: {
        title: 'FirstName',
        type: 'string',
      },
      lastName: {
        title: 'LastName',
        type: 'string',
      },
      email: {
        title: 'Email',
        type: 'string',
      },
      phoneNumber: {
        title: 'PhoneNumbre',
        type: 'int',
      },
      
      role: {
        title: 'Role',
        type: 'int',
      }
      
    },
  };

  source: LocalDataSource = new LocalDataSource();

  constructor(private service: UserService) {
    this.service.getData().subscribe(data=>{
      this.source.load(data);
    });
  }

  onDeleteConfirm(event): void {
    if (window.confirm('Are you sure you want to delete?')) {
      this.service.deleteUser(event.data).subscribe(data=>{
      });
      event.confirm.resolve();
    } else {
      event.confirm.reject();
    }
  }

  onEditConfirm(event): void {

    if (window.confirm('Are you sure you want to update?')) {
      this.service.updateUser(event.newData).subscribe(data=>{

      });
      event.confirm.resolve();
    } else {
      event.confirm.reject();
    }
  }

  onCreateConfirm(event): void {

    if (window.confirm('Are you sure you want to create?')) {
      this.service.createUser(event.newData).subscribe(data=>{

      });
      event.confirm.resolve();
    } else {
      event.confirm.reject();
    }
  }
}


