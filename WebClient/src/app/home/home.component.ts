import { Component, OnInit } from '@angular/core';
import LocationPicker from "location-picker";

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  lp: any=undefined;
  constructor() { }

  ngOnInit(): void {
    this.lp = new LocationPicker('map',{
      setCurrentPosition: true, // You can omit this, defaults to true
  }, {
      zoom: 15 // You can set any google map options here, zoom defaults to 15
  });
  }

  setLocation() {
    console.log(this.lp.getMarkerPosition());
  }

  uploadImages(){
    console.log("uploading images");
  }

}
