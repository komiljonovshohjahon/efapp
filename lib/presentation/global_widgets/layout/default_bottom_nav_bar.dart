import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:flutter/material.dart';

Map<int, dynamic> navigations = {
  0: {
    "title": "Home",
    "route": "",
    "icon": Icons.home,
    "index": 0,
  },
  1: {
    "title": "Blogs",
    "route": MCANavigation.blogs,
    "icon": Icons.newspaper,
    "index": 1,
  }
};

class DefaultBottomNavigationBar extends StatefulWidget {
  const DefaultBottomNavigationBar({super.key});

  @override
  State<DefaultBottomNavigationBar> createState() =>
      _DefaultBottomNavigationBarState();
}

class _DefaultBottomNavigationBarState
    extends State<DefaultBottomNavigationBar> {
  void _onItemTapped(int index) {
    context.go("${MCANavigation.home}${navigations[index]!["route"]}");
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = DependencyManager.instance.navigation.router.location;
    int currentIndex = navigations.values.firstWhereOrNull((element) =>
            "${MCANavigation.home}${element["route"]}" ==
            currentRoute)?["index"] ??
        0;
    return BottomNavigationBar(
      elevation: .1,
      currentIndex: currentIndex,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper),
          label: 'Blogs',
          backgroundColor: Colors.green,
        ),
      ],
    );
  }
}
