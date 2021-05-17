import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router'
import { AuthenticationService } from '../services/Authentication/authentication.service';
import Swal from 'sweetalert2'

@Component({
  selector: 'app-sign-in',
  templateUrl: './sign-in.component.html',
  styleUrls: ['./sign-in.component.css']
})
export class SignInComponent implements OnInit {
  errorMsg:String="";
  email:String="";
  password:String="";
  
  constructor(private router : Router,private readonly authService:AuthenticationService) { }


  ngOnInit(): void {

  }

   login(){
    if(this.email==""||this.password==""){
      Swal.fire({
        icon: 'warning',
        heightAuto: false,
        title: '<small><b>Username or password is empty</b></small>',
        showConfirmButton: false,
        timer: 1500
      })
    }else{
      this.authService.userAuthentication(this.email,this.password).subscribe((data:any)=>{
          localStorage.setItem("Bearer",data["token"]);
          this.router.navigate(['home']);
      },
      (err:any) =>{ 
        let error=err.error["message"];
        if(error=="invalid credentialls"){
          error="Invalid Credentials";
        }
        Swal.fire({
          icon: 'error',
          heightAuto: false,
          title:error=="Not authorized"?'<small><b>Not authorized</b></small>':'<small><b>Invalid Credentials</b></small>',
          showConfirmButton: false,
          timer: 1500,
        })
      }
      )
    }  
  }
}
