import 'package:flutter/material.dart';

import 'gamer/game.dart';
import 'gamer/keyboard.dart';
import 'material/audios.dart';
import 'screens/home_page.dart';

const backgroundColor = Colors.white;

class App extends StatelessWidget {
  const App({super.key});
  // Este widget é a raiz do seu aplicativo
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clash of Blocks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Sound(
            child: Game(
              child: KeyboardController(
                child: Center(child: HomePage()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
