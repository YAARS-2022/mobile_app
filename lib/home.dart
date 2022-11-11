import 'package:flutter/material.dart';
import 'package:yaars/data/bus_data_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final busController = BusDataController();

  @override
  Widget build(BuildContext context) {
    busController.getLocationOfChild(name: 'Ashmit');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find My Child'),
      ),
      body: Container(),
    );
  }
}
