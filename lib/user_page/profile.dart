import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/picture_bloc.dart';
import 'circular_button.dart';
import 'cuenta_item.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScreenshotController screenshotController = ScreenshotController();

  StreamSubscription<ConnectivityResult>? _subscription;

  @override
  void initState() {
    _subscription =
        Connectivity().onConnectivityChanged.listen((connectivityResult) {
      print(connectivityResult);
      switch (connectivityResult) {
        case ConnectivityResult.wifi:
        case ConnectivityResult.mobile:
          _isThereConnectivity(true);
          break;
        case ConnectivityResult.none:
          _isThereConnectivity(false);
          break;
        default:
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: "Compartir pantalla",
              onPressed: () async {
                await _shareScreen();
              },
              icon: Icon(Icons.share),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BlocConsumer<PictureBloc, PictureState>(
                  listener: (context, state) {
                    if (state is PictureErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${state.errorMsg}")),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is PictureSelectedState) {
                      return CircleAvatar(
                        backgroundImage: FileImage(state.picture!),
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    } else if (state is PictureErrorState) {
                      return CircleAvatar(
                        backgroundColor: Colors.red.shade900,
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    } else {
                      return CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 122, 113, 113),
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    }
                  },
                ),
                SizedBox(height: 16),
                Text(
                  "Bienvenido",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(height: 8),
                Text("Usuario${UniqueKey()}"),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DescribedFeatureOverlay(
                      featureId: "tarjeta",
                      tapTarget: const Icon(Icons.credit_card),
                      title: Text("Mostrar Tarjetas"),
                      description: Text(
                          "Muestra una lista de las tarjetas disponibles en la cuenta"),
                      backgroundColor: Theme.of(context).primaryColor,
                      targetColor: Colors.white70,
                      textColor: Colors.white70,
                      contentLocation: ContentLocation.above,
                      overflowMode: OverflowMode.extendBackground,
                      child: CircularButton(
                        textAction: "Ver tarjeta",
                        iconData: Icons.credit_card,
                        bgColor: Color(0xff123b5e),
                        action: null,
                      ),
                    ),
                    DescribedFeatureOverlay(
                      featureId: "foto",
                      tapTarget: const Icon(Icons.camera_alt),
                      title: Text("Tomar Foto"),
                      description: Text(
                          "Cambia la foto de perfil utilizando la \ncamara"),
                      backgroundColor: Theme.of(context).primaryColor,
                      targetColor: Colors.white70,
                      textColor: Colors.white70,
                      child: CircularButton(
                        textAction: "Cambiar foto",
                        iconData: Icons.camera_alt,
                        bgColor: Colors.orange,
                        action: () {
                          BlocProvider.of<PictureBloc>(context).add(
                            ChangeImageEvent(),
                          );
                        },
                      ),
                    ),
                    DescribedFeatureOverlay(
                      featureId: "tutorial",
                      tapTarget: const Icon(Icons.play_arrow_outlined),
                      title: Text("Tutorial"),
                      description: Text(
                          "Muestra un tutorial acerca del funcionamiento de la aplicacion"),
                      backgroundColor: Theme.of(context).primaryColor,
                      targetColor: Colors.white70,
                      textColor: Colors.white70,
                      child: CircularButton(
                        textAction: "Ver tutorial",
                        iconData: Icons.play_arrow,
                        bgColor: Colors.green,
                        action: () {
                          FeatureDiscovery.discoverFeatures(
                            context,
                            const <String>{
                              // Feature ids for every feature that you want to showcase in order.
                              "tutorial", "tarjeta", "foto"
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48),
                // CuentaItem(),
                // CuentaItem(),
                // CuentaItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _isThereConnectivity(bool bool) {
    setState(() {});
    if (bool) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Conectado a la red"),
          ),
        );
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Descontectado de la red"),
          ),
        );
    }
  }

  Future _shareScreen() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        await Share.shareFiles([imagePath.path]);
      }
    });
  }
}
