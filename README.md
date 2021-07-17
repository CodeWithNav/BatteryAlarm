# BtteryAlarm 
## A Application Thats Notify When Battery Is Full During Charging.
```dart 
_batteryStateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) {
      _batteryState = state;
      print(state);
      setIsCharging();
    });
````

![a](asset/images/a.jpg) | ![a](asset/images/a.jpg)
------------------------------------|-----------------------------------
