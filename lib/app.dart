// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ta_ews_application/core.dart';
import 'package:ta_ews_application/features/call_center/view/call_center_view.dart';
import 'package:ta_ews_application/features/detail/view/detail_view.dart';
import 'package:ta_ews_application/features/home/bloc/data_sungai_bloc.dart';
import 'package:ta_ews_application/features/home/view/home_view.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<Widget> pages = [
    Homepage(),
    DetailPage(),
    CallCenterPage(),
    CallCenterPage()
  ];

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    // DataSungaiBloc sungaiBloc = context.read<DataSungaiBloc>();

    return Scaffold(
      backgroundColor: Constant.grey,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.amber[800],
        title: Constant.appTitle,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: const <Color>[
                    Constant.orange,
                    Constant.grey,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
                child: BlocConsumer<DataSungaiBloc, DataSungaiState>(
                  listenWhen: (previous, current) {
                    if (current is LoadedDataSensor) return true;
                    return false;
                  },
                  listener: (context, state) {
                    state as LoadedDataSensor;
                    if (state.dataSensor.levelBahayaNode1 == "bahaya" ||
                        state.dataSensor.levelBahayaNode1 == "sangat bahaya") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Kondisi Sungai : ${state.dataSensor.levelBahayaNode1} di Node 1'),
                          backgroundColor: Constant.orange));
                    }
                    if (state.dataSensor.levelBahayaNode2 == "bahaya" ||
                        state.dataSensor.levelBahayaNode2 == "sangat bahaya") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Kondisi Sungai : ${state.dataSensor.levelBahayaNode2} di Node 2'),
                          backgroundColor: Constant.orange));
                    }
                  },
                  buildWhen: (previous, current) {
                    if (current is DataSungaiInitial) return true;
                    if (current is LoadedDataSungai) return true;
                    return false;
                  },
                  builder: (context, state) {
                    if (state is LoadedDataSungai) {}
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: Text(
                            state is LoadedDataSungai
                                ? state.dataSungai.namaSungai
                                : 'Nama Sungai',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        Positioned(
                            left: 30,
                            child: Row(
                              children: [
                                Image(
                                    image: AssetImage(
                                        'assets/images/trail-map.png')),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                    state is LoadedDataSungai
                                        ? state.dataSungai.lokasiSungai
                                        : 'Lokasi Sungai',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ))
                              ],
                            )),
                        Positioned(
                            right: 30,
                            child: Row(
                              children: [
                                Image(
                                    image: AssetImage(
                                        'assets/images/location-icon.png')),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                    state is LoadedDataSungai
                                        ? state.dataSungai.koordinatSungai
                                        : 'Koordinat Sungai',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ))
                              ],
                            ))
                      ],
                    );
                  },
                ))),
      ),
      bottomNavigationBar: NavigationBar(
          // backgroundColor: Colors.amber[800],
          indicatorColor: Colors.white,
          selectedIndex: _currentIndex,
          onDestinationSelected: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.list),
                selectedIcon: Icon(Icons.list_alt_outlined),
                label: 'Detail'),
            NavigationDestination(
                icon: Icon(Icons.call_outlined),
                selectedIcon: Icon(Icons.call),
                label: 'Call Center'),
            NavigationDestination(
                icon: Icon(Icons.info_outline),
                selectedIcon: Icon(Icons.info),
                label: 'About'),
          ]),
      body: pages.elementAt(_currentIndex),
    );
  }
}
