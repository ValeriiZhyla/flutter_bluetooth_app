import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'router.dart';

class DeviceList extends StatefulWidget {
  DeviceList({Key? key}) : super(key: key);

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final Map<Guid, List<int>> readValues = Map<Guid, List<int>>();

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  final _writeController = TextEditingController();
  BluetoothDevice? _connectedDevice;
  List<BluetoothService>? _services;
  List<int> steps = [];

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = <Container>[];
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(device.name == '' ? '(unknown device)' : device.name),
                      Text(device.id.toString()),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: const Text(
                    'Connect',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    widget.flutterBlue.stopScan();
                    try {
                      await device.connect();
                      Navigator.pushNamed(context, startGameRoute);
                    } catch (e) {
                      if (e.toString() != 'already_connected') {
                        rethrow;
                      }
                    } finally {
                      _services = await device.discoverServices();
                    }
                    setState(() {
                      _connectedDevice = device;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }


  ListView _buildView() {
    return _buildListViewOfDevices();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Available BLE devices"),
    ),
    body: _buildView(),
  );

  Future<List<int>> _fetchStepCharacteristic() async {
    String stepsServiceUUID = "0000fee0-0000-1000-8000-00805f9b34fb";
    BluetoothService? stepService = _services?.where((element) => element.uuid.toString() == stepsServiceUUID).first;
    if (stepService == null) {
      throw Exception("Service with UUID [$stepsServiceUUID] was not found");
    }
    String stepsCharacteristicsUUID = "00000007-0000-3512-2118-0009af100700";
    BluetoothCharacteristic stepCharacteristic = stepService.characteristics.where((element) => element.uuid.toString() == stepsCharacteristicsUUID).first;

    var sub = stepCharacteristic.value.listen((value) {
      setState(() {
        steps.add(value[1]);
      });
    });
    await stepCharacteristic.read();

    return stepCharacteristic.read();

  }

  void printStepCounterList() async {
    var stepCounter = await _fetchStepCharacteristic();
    print(stepCounter.toString());
  }

}