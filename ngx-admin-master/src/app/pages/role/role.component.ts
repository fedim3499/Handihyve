import { Component } from '@angular/core';
import { LocalDataSource } from 'ng2-smart-table';
import { SmartTableData } from '../../@core/data/smart-table';
import { RoleService } from '../../@core/mock/role.service';
import { first } from 'rxjs-compat/operator/first';

@Component({
  selector: 'ngx-role',
  templateUrl: './role.component.html',
  styleUrls: ['./role.component.scss']
})
export class RoleComponent {
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
      roleName: {
        title: 'Role Name',
        type: 'string',
      },
      description: {
        title: 'Description',
        type: 'string',
      }
      
    },
  };

  source: LocalDataSource = new LocalDataSource();

  constructor(private service: RoleService) {
    this.service.getData().subscribe(data=>{
      this.source.load(data);
    });
  }

  onDeleteConfirm(event): void {
    if (window.confirm('Are you sure you want to delete?')) {
      event.confirm.resolve();
    } else {
      event.confirm.reject();
    }
  }
  onEditConfirm(event): void {

    if (window.confirm('Are you sure you want to update?')) {
      this.service.updateRole(event.newData).subscribe(data=>{

      });
      event.confirm.resolve();
    } else {
      event.confirm.reject();
    }
  }

  onCreateConfirm(event): void {

    if (window.confirm('Are you sure you want to create?')) {
      this.service.createRole(event.newData).subscribe(data=>{

      });
      event.confirm.resolve();
    } else {
      event.confirm.reject();
    }
  }
}


