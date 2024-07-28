import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healther/controller/comments_controller.dart';
import 'package:healther/core/utils/size_utils.dart';
import 'package:healther/firebase_options.dart';
import 'package:healther/routes/app_routes.dart';
import 'package:healther/user_state.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CommentsController()),
          ],
          child: MaterialApp(
            title: 'Comments-App',
            debugShowCheckedModeBanner: false,
            home: UserState(),
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }
}
