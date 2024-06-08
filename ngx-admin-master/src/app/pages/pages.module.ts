import { NgModule } from '@angular/core';
import { NbCardModule, NbIconModule, NbInputModule, NbMenuModule, NbTreeGridModule } from '@nebular/theme';

import { ThemeModule } from '../@theme/theme.module';
import { PagesComponent } from './pages.component';
import { DashboardModule } from './dashboard/dashboard.module';
import { ECommerceModule } from './e-commerce/e-commerce.module';
import { PagesRoutingModule } from './pages-routing.module';
import { MiscellaneousModule } from './miscellaneous/miscellaneous.module';
import { RoleComponent } from './role/role.component';
import { TablesRoutingModule } from './tables/tables-routing.module';
import { Ng2SmartTableModule } from 'ng2-smart-table';
import {  ProfessionTypeComponent } from './professionType/professionType.component';
import { UsersComponent } from './users/users.component';
import { ProfessionComponent } from './profession/profession.component';

@NgModule({
  imports: [
    PagesRoutingModule,
    ThemeModule,
    NbMenuModule,
    DashboardModule,
    
    MiscellaneousModule,
    NbCardModule,
    NbTreeGridModule,
    NbIconModule,
    NbInputModule,
    TablesRoutingModule,
    Ng2SmartTableModule,
  ],
  declarations: [
    PagesComponent,
    RoleComponent,
    ProfessionTypeComponent,
    UsersComponent,
    ProfessionComponent,
  ],
})
export class PagesModule {
}
