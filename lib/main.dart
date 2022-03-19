import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'user_page/bloc/picture_bloc.dart';
import 'user_page/profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: FeatureDiscovery.withProvider(
        persistenceProvider: NoPersistenceProvider(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => PictureBloc()),
//            BlocProvider(
//                create: (context) => AcclistBloc()..add(ListUpdateEvent())),
          ],
          child: Profile(),
        ),
      ),
    );
  }
}
