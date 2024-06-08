import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';
import { Profession } from '../data/profession';

@Injectable({
  providedIn: 'root'
})
export class ProfessionService {
deactivateProfession(row: any) {
  throw new Error('Method not implemented.');
}
activateProfession(row: any) {
  throw new Error('Method not implemented.');
}

constructor(private http: HttpClient) { }
getData() {
  return this.http.get<Profession[]>(`${environment.apiUrl}/profession`);
}
  
createProfession(profession:Profession) {
  return this.http.post<Profession>(`${environment.apiUrl}/profession/createProfession`, profession)
   ;
}
updateProfession(profession:Profession) {
  return this.http.post<Profession>(`${environment.apiUrl}/profession/updateProfession`,  profession)
  ;
}
DeleteProfession(profession:Profession) {
  return this.http.post<Profession>(`${environment.apiUrl}/profession/deleteProfession `,  profession)
}
ActiveProfession(profession:Profession) {
  return this.http.post<Profession>(`${environment.apiUrl}/profession/activeProfession `,  profession)
}

}