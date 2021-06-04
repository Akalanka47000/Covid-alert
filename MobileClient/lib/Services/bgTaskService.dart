
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';



class BluetoothService{

  static startScan() async{
    FlutterScanBluetooth _bluetooth = FlutterScanBluetooth();
    await _bluetooth.requestPermissions();
    await _bluetooth.startScan(pairedDevices: false);
    _bluetooth.devices.listen((device) {
      print( device.name+'(${device.address})\n');
    });
    // _bluetooth.scanStopped.listen((device) {
    //   // setState(() {
    //   //   _scanning = false;
    //   //   _data += 'scan stopped\n';
    //   // });
    // });
  }
}
