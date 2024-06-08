import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { User } from '../data/users';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  // data = [
  //   {
  //   id: 1,
  //   FirstName: 'wala',
  //   LastName: 'sedghiani',
  //   Email: 'wala@gmail.com',
  //   PhoneNumber: '43456544',
  //   Role: 'Admin',
  // },
  // {
  //   id: 2,
  //   FirstName: 'fedi',
  //   LastName: 'benahmed',
  //   Email: 'mark@gmail.com',
  //   PhoneNumber: '43456544',
  //   Role:'Admin',
  // },
  

//];
constructor(private http: HttpClient) { }
getData() {
  return this.http.get<User[]>(`${environment.apiUrl}/users`);
}
createUser(user:User) {
  return this.http.post<User>(`${environment.apiUrl}/users/createUser`,  user)
   
}
updateUser(user:User) {
  return this.http.post<User>(`${environment.apiUrl}/users/updateUser`,  user)
}
deleteUser(user:User) {
  return this.http.post<User>(`${environment.apiUrl}/users/deleteUser`,  user)
}

  
}
