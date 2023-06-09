import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'HomeScreen.dart';


void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   @override
//   void initState() {
//     super.initState();

//     /// whenever your initialization is completed, remove the splash screen:
//     Future.delayed(Duration(seconds: 1)).then((value) => {
//       FlutterNativeSplash.remove()
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Splash Screen"),
//         backgroundColor: Colors.red,
//       ),
//       body: const Center(
//         child: Text("Wasn't this\nAWESOME?!", style: TextStyle(fontSize: 24,),),
//       ),
//     );
//   }
// }
