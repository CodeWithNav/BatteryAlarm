import 'package:flutter/material.dart';

import 'components/battery.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BatteryComponent(),
    );
  }
}
