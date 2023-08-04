import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Map<int, dynamic> navigations = {
  0: {
    "title": "Home",
    "route": "",
    "icon": Icons.home,
    "index": 0,
  },
  1: {
    "title": "Pillar of Cloud",
    "route": MCANavigation.pillarCloud,
    "icon": Icons.cloud,
    "index": 1,
  },
  2: {
    "title": "Pillar of Fire",
    "route": MCANavigation.pillarFire,
    "icon": Icons.fireplace,
    "index": 2,
  },
  3: {
    "title": "Love Offering",
    "route": MCANavigation.loveOffering,
    "icon": Icons.favorite,
    "index": 3,
  },
};

class DefaultBottomNavigationBar extends StatefulWidget {
  const DefaultBottomNavigationBar({super.key});

  @override
  State<DefaultBottomNavigationBar> createState() =>
      _DefaultBottomNavigationBarState();
}

class _DefaultBottomNavigationBarState
    extends State<DefaultBottomNavigationBar> {
  void _onItemTapped(int index, BuildContext context) {
    if (index == 1) {
      context.goToPillar(FirestoreDep.pillarOfCloud);
      return;
    }
    if (index == 2) {
      context.goToPillar(FirestoreDep.pillarOfFire);
      return;
    }
    context.go("${MCANavigation.home}${navigations[index]!["route"]}");
  }

  @override
  void initState() {
    super.initState();
    DependencyManager.instance.navigation.router.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = DependencyManager.instance.navigation.router.location;
    int currentIndex = navigations.values.firstWhereOrNull((element) {
          return "${MCANavigation.home}${element["route"]}" == currentRoute;
        })?["index"] ??
        0;

    return BottomNavigationBar(
      elevation: 8,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (value) => _onItemTapped(value, context),
      items: <BottomNavigationBarItem>[
        for (var item in navigations.values)
          BottomNavigationBarItem(
            icon: Icon(item["icon"]),
            label: item["title"],
          ),
      ],
    );
  }
}
