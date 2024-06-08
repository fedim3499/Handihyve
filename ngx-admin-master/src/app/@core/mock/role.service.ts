import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';
import { Role } from '../data/role';

@Injectable({
  providedIn: 'root'
})
export class RoleService {

constructor(private http: HttpClient) { }

getData() {
  return this.http.get<Role[]>(`${environment.apiUrl}/role`);
}
createRole(role:Role) {
  return this.http.post<Role>(`${environment.apiUrl}/role/createrole`,  role)
   ;
}
updateRole(role:Role) {
  return this.http.post<Role>(`${environment.apiUrl}/role/updaterole`,  role)
}
}
