import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:efapp/utils/utils.dart';
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
  },
  2: {
    "title": "Videos",
    "route": MCANavigation.yt,
    "icon": Icons.video_collection,
    "index": 2,
  },
  3: {
    "title": "Gallery Album",
    "route": MCANavigation.galleryAlbum,
    "icon": Icons.photo_album,
    "index": 3,
  },
  4: {
    "title": "Pillar of Cloud",
    "route": MCANavigation.pillar,
    "icon": Icons.cloud,
    "index": 4,
  },
  5: {
    "title": "Pillar of Fire",
    "route": MCANavigation.pillar,
    "icon": Icons.fireplace,
    "index": 5,
  },
  6: {
    "title": "Love Offering",
    "route": MCANavigation.loveOffering,
    "icon": Icons.favorite,
    "index": 6,
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
    if (index == 4) {
      context.goToPillar(FirestoreDep.pillarOfCloud);
      return;
    }
    if (index == 5) {
      context.goToPillar(FirestoreDep.pillarOfFire);
      return;
    }
    context.go("${MCANavigation.home}${navigations[index]!["route"]}");
  }

  @override
  void initState() {
    super.initState();
    DependencyManager.instance.navigation.router.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = DependencyManager.instance.navigation.router.location;
    int currentIndex = navigations.values.firstWhereOrNull((element) =>
            "${MCANavigation.home}${element["route"]}" ==
            currentRoute)?["index"] ??
        0;
    print("currentRoute: $currentRoute currentIndex: $currentIndex");
    return BottomNavigationBar(
      elevation: 8,
      currentIndex: currentIndex,
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
