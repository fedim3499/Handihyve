import { Component, EventEmitter, Input, Output } from '@angular/core';

@Component({
  selector: 'app-actions-button',
  template: `
  <a class="accept-button" >
    <i class="nb-checkmark-circle" (click)="onActive.emit(rowData)"></i>
  </a>
  `,
styles: [
    `
    .accept-button {
      bdisplay: flex;
    align-items: center;
    justify-content: center;
    height: 100%;
    width: 100%;
    font-size: 2rem !important;
    color: #008000;
    }
     
    `
  ]
})
export class ActiveButtonComponent {
  @Input() rowData: any;
  @Output() onActive = new EventEmitter<any>();
  @Input() value; // data from table

}
