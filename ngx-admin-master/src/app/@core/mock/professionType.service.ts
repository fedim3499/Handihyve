import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ProfessionType } from '../data/professionType';
import { environment } from '../../../environments/environment';
import { map } from 'leaflet';

@Injectable({
  providedIn: 'root'
})
export class professionTypeService {
//  data = [
//     {
//     id: 1,
//     professionName: 'Mark',
//     description: 'Otto',
    
//   },
//   {
//     id: 2,
//     professionName: 'Mark',
//     description: 'Otto',
    
//   }

// ];
constructor(private http: HttpClient) { }
getData() {
  return this.http.get<ProfessionType[]>(`${environment.apiUrl}/professionType`);
}
  
createProfession(professionType:ProfessionType) {
  return this.http.post<ProfessionType>(`${environment.apiUrl}/professionType/createProfessionType`,  professionType)
   ;
}
updateProfession(professionType:ProfessionType) {
  return this.http.post<ProfessionType>(`${environment.apiUrl}/professionType/updateProfessionType`,  professionType)
  ;
}
DeleteProfession(professionType:ProfessionType) {
  return this.http.post<ProfessionType>(`${environment.apiUrl}/professionType/deleteProfessionType`,  professionType)
}
}
