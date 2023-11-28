import 'package:flutter/widgets.dart';

import 'page_portrait.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PagePortrait();
    //only Android/iOS support land mode
    // return switch (MediaQuery.orientationOf(context)) {
    //   Orientation.landscape => const PageLand(),
    //   Orientation.portrait => const PagePortrait(),
    // };
  }
}
