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
      setCurrentPosition: true, // You can omit this, defaults to true
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

  uploadImages(){
    console.log("uploading images");
  }

}
