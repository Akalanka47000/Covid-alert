import { Component, OnInit } from '@angular/core';
import LocationPicker from "location-picker";
import { NotificationService } from '../services/Notification/notification.service';
import Swal from 'sweetalert2'

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  lp: any=undefined;
  constructor(private readonly notificationService:NotificationService) { }

  ngOnInit(): void {
    this.lp = new LocationPicker('map',{
      // setCurrentPosition: true, // You can omit this, defaults to true
      lat:6.927079,
      lng:79.861244,

  }, {
      zoom: 15 // You can set any google map options here, zoom defaults to 15
  });
  }

  setLocation() {
    this.notificationService.notifyUsers(this.lp.getMarkerPosition().lat,this.lp.getMarkerPosition().lng).subscribe((data:any)=>{
      Swal.fire({
        icon: 'success',
        heightAuto: false,
        title:'<small><b>Notifications sent out</b></small>',
        showConfirmButton: false,
        timer: 1500,
      });
    },
    (err:any) =>{ 
      Swal.fire({
        icon: 'error',
        heightAuto: false,
        title:'<small><b>An error has occured</b></small>',
        showConfirmButton: false,
        timer: 1500,
      })
    });
  }

  uploadFile(fileInput:any) {
    if (fileInput.target.files && fileInput.target.files[0]) {
      const reader = new FileReader();
      reader.onload = (e: any) => {
          const image = new Image();
          image.src = e.target.result;
          image.onload = rs => {
              const imgBase64Path = e.target.result;
              this.notificationService.uploadImage(imgBase64Path).subscribe((data:any)=>{
                Swal.fire({
                  icon: 'success',
                  heightAuto: false,
                  title:'<small><b>Image Uploaded</b></small>',
                  showConfirmButton: false,
                  timer: 1500,
                });
              },
              (err:any) =>{ 
                Swal.fire({
                  icon: 'error',
                  heightAuto: false,
                  title:'<small><b>An error has occured</b></small>',
                  showConfirmButton: false,
                  timer: 1500,
                })
              });
          };
      };
      reader.readAsDataURL(fileInput.target.files[0]);
    }
  }

}
