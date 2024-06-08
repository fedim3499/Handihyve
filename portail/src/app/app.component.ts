import { Component } from '@angular/core';

import { AuthenticationService } from './_services';
import { User } from './_models';

@Component({ selector: 'app-root' ,
 templateUrl: 'app.component.html',
 styleUrls: ['../assets/css/bootstrap/css/bootstrap.min.css',
 '../assets/icon/themify-icons/themify-icons.css',
 '../assets/icon/icofont/css/icofont.css',
 '../assets/icon/font-awesome/css/font-awesome.min.css',
 '../assets/pages/waves/css/waves.min.css',
 '../assets/css/style.css',
 '../assets/css/jquery.mCustomScrollbar.css',
 '../assets/css/google-font.css'
]
 })
export class AppComponent {
    user?: User | null;

    constructor(private authenticationService: AuthenticationService) {
        this.authenticationService.user.subscribe(x => this.user = x);
    }

    logout() {
        this.authenticationService.logout();
    }
}