import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthenticationService {

  constructor(private readonly http:HttpClient) { }

  userAuthentication(username:String,password:String){
    let url = "http://localhost:8000/user/login";
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
