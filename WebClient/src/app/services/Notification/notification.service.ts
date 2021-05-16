import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class NotificationService {

  constructor(private readonly http:HttpClient) { }

  notifyUsers(latitude:any,longitude:any){
    let url = "http://localhost:8000/notification/send";
    let header = new HttpHeaders({
      'Content-Type': 'application/json',
    })
    let body = {
      'latitude': latitude,
      'longitude': longitude,
    }
    return this.http.post(url,body,{'headers':header});
  }

  uploadImage(base64URL:String){
    let url = "http://localhost:8000/notification/uploadImage";
    let header = new HttpHeaders({
      'Content-Type': 'application/json',
    })
    let body = {
      'base64URL': base64URL
    }
    return this.http.put(url,body,{'headers':header});
  }

}
