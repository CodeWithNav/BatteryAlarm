import 'dart:async';

import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BatteryComponent extends StatefulWidget {
  @override
  _BatteryComponentState createState() => _BatteryComponentState();
}

class _BatteryComponentState extends State<BatteryComponent> {
  FlutterTts _flutterTts = FlutterTts();
  Battery _battery = Battery();
  bool isCharging = false;
  bool isChargingFull = false;
  int batteryValue = 0;
  BatteryState _batteryState;

  StreamSubscription<BatteryState> _batteryStateSubscription;

  speak(String msg) async {
    await _flutterTts.speak(msg);
  }

  @override
  void initState() {
    setData();
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      _batteryState = state;
      print(state);
      setIsCharging();
    });
    super.initState();
  }

  setData() async {
    batteryValue = await _battery.batteryLevel;
  }

  setIsCharging() async {
    await setData();
    setState(() {
      if (_batteryState == BatteryState.charging) {
        if (!isCharging) {
          speak("Charger Connected");
        }
        isCharging = true;
        playAlarm(batteryValue);
      }
      if (_batteryState == BatteryState.discharging) {
        isCharging = false;
        speak("Charger Is Remove");
      }
    });
  }

  playAlarm(int value) {
    switch (value) {
      case 100:
        isChargingFull = true;
        _batteryStateSubscription.cancel();
        speak("Battery Is Full Please Remove Your Phone From Charging");
        break;
      case 50:
        speak("Battery Level is 50");
        break;
      case 75:
        speak("Battery Level is 75");
        break;
      case 30:
        speak("Battery Level is 30");
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 20,
                width: 30,
                color: Colors.redAccent,
              ),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 2,
                        ),
                        color: Colors.greenAccent),
                    height: 120,
                    width: 80,
                  ),
                  Container(
                    height: 120 - (batteryValue / 100) * 120,
                    width: 80,
                    color: Colors.red,
                  ),
                ],
              ),
              Text(
                "$batteryValue",
                style: TextStyle(fontSize: 62, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          if (isChargingFull)
            Text(
              "Battery is Full Remove Your Phone From Charging",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (isCharging)
            Column(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  child: Center(
                    child: Icon(
                      Icons.charging_station,
                      color: Colors.green,
                      size: 100,
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(200),
                      ),
                      border: Border.all(color: Colors.green, width: 5)),
                ),
                Container(
                  width: 20,
                  color: Colors.green,
                  height: 50,
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _batteryStateSubscription.cancel();
    super.dispose();
  }
}
