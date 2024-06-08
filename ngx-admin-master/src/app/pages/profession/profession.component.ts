import { Component } from '@angular/core';
import { RoleService } from '../../@core/mock/role.service';
import { LocalDataSource } from 'ng2-smart-table';
import { professionTypeService } from '../../@core/mock/professionType.service';
import { Path } from 'leaflet';
import { ProfessionService } from '../../@core/mock/profession.service';
import { ActiveButtonComponent } from './ActiveButtonComponent';


@Component({
  selector: 'ngx-profession',
  templateUrl: './profession.component.html',
  styleUrls: ['./profession.component.scss']
})
export class ProfessionComponent {
  settings = {
    add: {
      addButtonContent: '<i class="nb-plus"></i>',
      createButtonContent: '<i class="nb-checkmark"></i>',
      cancelButtonContent: '<i class="nb-close"></i>',
      confirmCreate: true
    },
    edit: {
      editButtonContent: '<i class="nb-edit"></i>',
      saveButtonContent: '<i class="nb-checkmark"></i>',
      cancelButtonContent: '<i class="nb-close"></i>',
      confirmSave: true
    },
    delete: {
      deleteButtonContent: '<i class="nb-trash"></i>',
      confirmDelete: true,
    },
    columns: {
      professionName: {
        title: 'Profession Name',
        type: 'string',
      },
      userName: {
        title: 'User Name',
        type: 'string',
      },
      firstName: {
        title: 'First Name',
        type: 'string',
      },
      taxRegistrationNumber: {
        title: 'Tax registration number',
        type: 'string',
      },
      isActive: {
        title: 'Active',
        type: 'string',
      },
      Action: {
        title: 'Action',
        type: 'custom',
        filter: false,
        valuePrepareFunction: (value, row, cell) => {
          return value;
        },
        renderComponent: ActiveButtonComponent, 
        onComponentInitFunction: (instance) => {  
          instance.onActive.subscribe((data) => {
            this.service.ActiveProfession(data).subscribe(data=>{
              this.getData();
            });
         });
          
        }
      },
    },
  };
  
  source: LocalDataSource = new LocalDataSource();

  constructor(private service: ProfessionService) {
    this.getData();
  }

  onDeleteConfirm(event): void {

    if (window.confirm('Are you sure you want to delete?')) {
      this.service.DeleteProfession(event.data).subscribe(data=>{
      });
      event.confirm.resolve();
    } else {
      event.confirm.reject();
    }
  }

  onEditConfirm(event): void {

    if (window.confirm('Are you sure you want to update?')) {
      this.service.updateProfession(event.newData).subscribe(data=>{
        this.getData();
      });
      event.confirm.resolve();
    } else {
      event.confirm.reject();
    }
  }

  onCreateConfirm(event): void {

    if (window.confirm('Are you sure you want to create?')) {
      this.service.createProfession(event.newData).subscribe(data=>{
        this.getData();
      });
      event.confirm.resolve();
    } else {
      event.confirm.reject();
    }
  }
  onActiveConfirm(event): void {

    if (window.confirm('Are you sure you want to active?')) {
      this.service.DeleteProfession(event.data).subscribe(data=>{
        this.getData();
      });
      event.confirm.resolve();
    } else {
      event.confirm.reject();
    }
  }

  getData():void{
    this.service.getData().subscribe(data=>{
      this.source.load(data);
    });
  }
}
