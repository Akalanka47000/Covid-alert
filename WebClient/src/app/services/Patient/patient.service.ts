import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class PatientService {

  constructor(private readonly http:HttpClient) { }

  //serverURL="http://ec2-13-213-51-110.ap-southeast-1.compute.amazonaws.com:8000";
  serverURL="http://192.168.8.102:8000";
  
  markPositive(email:String){
    let url = this.serverURL+"/user/markPositive/"+email;
    let Bearer = localStorage.getItem("Bearer");
    let header = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization':'Bearer '+Bearer,
    })
    let body = {
      'positiveStatus': true,
      'statusChangePermission': true,
    }
    return this.http.patch(url,body,{'headers':header});
  }
}
