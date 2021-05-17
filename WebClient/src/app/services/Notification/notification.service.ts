import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class NotificationService {

  constructor(private readonly http:HttpClient) { }

  serverURL="http://ec2-13-213-51-110.ap-southeast-1.compute.amazonaws.com:8000";

  notifyUsers(latitude:any,longitude:any){
    let url = this.serverURL+"/notification/send";
    let Bearer = localStorage.getItem("Bearer");
    let header = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization':'Bearer '+Bearer,
    })
    let body = {
      'latitude': latitude,
      'longitude': longitude,
    }
    return this.http.post(url,body,{'headers':header});
  }

  uploadImage(base64URL:String){
    let url = this.serverURL+"/notification/uploadImage";
    let Bearer = localStorage.getItem("Bearer");
    let header = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization':'Bearer '+Bearer,
    })
    let body = {
      'base64URL': base64URL
    }
    return this.http.put(url,body,{'headers':header});
  }

}
