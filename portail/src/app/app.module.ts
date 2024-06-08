import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { MatDialogModule } from '@angular/material/dialog'; 

import { JwtInterceptor, ErrorInterceptor } from './_helpers';

import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import { HomeComponent } from './home';
import { LoginComponent } from './login';
import { RoleComponent } from './role/role.component';
import { UserComponent } from './user/user.component';
import { RendezVousComponent } from './rendez-vous/rendez-vous.component';
import { UserProfilComponent } from './user-profil/user-profil.component';
import { UserModalComponent } from './dialog/user-modal/user-modal.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
@NgModule({
    imports: [
        BrowserModule,
        ReactiveFormsModule,
        HttpClientModule,
        AppRoutingModule,
        MatDialogModule,
        BrowserAnimationsModule // Add MatDialogModule to imports
    ],
    declarations: [
        AppComponent,
        HomeComponent,
        LoginComponent,
        RoleComponent,
        UserComponent,
        RendezVousComponent,
        UserProfilComponent,
        UserModalComponent
    ],
    providers: [
        { provide: HTTP_INTERCEPTORS, useClass: JwtInterceptor, multi: true },
        { provide: HTTP_INTERCEPTORS, useClass: ErrorInterceptor, multi: true },
    ],
    bootstrap: [AppComponent]
})
export class AppModule { }
