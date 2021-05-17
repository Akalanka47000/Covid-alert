import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthenticationService {

  constructor(private readonly http:HttpClient) { }

  serverURL="http://ec2-13-213-51-110.ap-southeast-1.compute.amazonaws.com:8000";

  userAuthentication(username:String,password:String){
    let url = this.serverURL+"/user/login";
    let header = new HttpHeaders({
      'Content-Type': 'application/json',
    })
    let body = {
      'email': username,
      'password': password,
      'device':"Web"
    }
    return this.http.post(url,body,{'headers':header});
  }
}
