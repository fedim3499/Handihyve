import { Component } from '@angular/core';
import { RoleService } from '../../@core/mock/role.service';
import { LocalDataSource } from 'ng2-smart-table';
import { professionTypeService } from '../../@core/mock/professionType.service';
import { Path } from 'leaflet';

@Component({
  selector: 'ngx-professionType',
  templateUrl: './professionType.component.html',
  styleUrls: ['./professionType.component.scss']
})
export class ProfessionTypeComponent {
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
      
      professionName: {
        title: 'Profession Name',
        type: 'string',
      },
      description: {
        title: 'Description',
        type: 'string',
      },
      path: {
        title: 'Path Name',
        type: 'string',
      },
      
    },
  };

  source: LocalDataSource = new LocalDataSource();

  constructor(private service: professionTypeService) {
    this.service.getData().subscribe(data=>{
      this.source.load(data);
    });
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

      });
      event.confirm.resolve();
    } else {
      event.confirm.reject();
    }
  }

  onCreateConfirm(event): void {

    if (window.confirm('Are you sure you want to create?')) {
      this.service.createProfession(event.newData).subscribe(data=>{

      });
      event.confirm.resolve();
    } else {
      event.confirm.reject();
    }
  }
}


