import 'package:dependency_plugin/dependencies/dependency_manager.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:efapp/presentation/global_widgets/layout/default_bottom_nav_bar.dart';
import 'package:efapp/presentation/global_widgets/layout/default_drawer.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:efapp/presentation/global_widgets/layout/page_wrapper.dart';

class DefaultLayout extends StatefulWidget {
  final Widget child;
  const DefaultLayout({super.key, required this.child});

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  @override
  Widget build(BuildContext context) {
    final currentRoute = DependencyManager.instance.navigation.router.location;
    return Scaffold(
      appBar: _getAppBar(currentRoute),
      resizeToAvoidBottomInset: true,
      body: PageWrapper(child: widget.child),
      bottomNavigationBar: _getBottomBar(currentRoute),
      drawer: DefaultDrawer(),
    );
  }

  PreferredSizeWidget? _getAppBar(String currentRoute) {
    if (currentRoute == MCANavigation.home ||
        currentRoute.split("/").contains("gallery") ||
        currentRoute == "${MCANavigation.home}${MCANavigation.pillarCloud}" ||
        currentRoute == "${MCANavigation.home}${MCANavigation.pillarFire}" ||
        currentRoute == "${MCANavigation.home}${MCANavigation.contactUs}") {
      return null;
    }
    if (currentRoute == "${MCANavigation.home}${MCANavigation.webView}") {
      return AppBar(
        leading: BackButton(
          onPressed: context.pop,
        ),
      );
    }
    if (currentRoute == "${MCANavigation.home}${MCANavigation.blogs}") {
      return AppBar(
        title: const Text("Blogs"),
        centerTitle: true,
        leading: BackButton(
          onPressed: context.pop,
        ),
      );
    }
    if (currentRoute == "${MCANavigation.home}${MCANavigation.galleryAlbum}") {
      return AppBar(
        title: const Text("Gallery Album"),
        centerTitle: true,
        leading: BackButton(
          onPressed: context.pop,
        ),
      );
    }
    if (currentRoute == "${MCANavigation.home}${MCANavigation.yt}") {
      return AppBar(
        title: const Text("Videos"),
        centerTitle: true,
        leading: BackButton(
          onPressed: context.pop,
        ),
      );
    }
    return AppBar(
      title: Text(_getTitle(currentRoute)),
      centerTitle: true,
    );
  }

  String _getTitle(String currentRoute) {
    if (currentRoute == "${MCANavigation.home}${MCANavigation.blogs}") {
      return "Blogs";
    }
    if (currentRoute == "${MCANavigation.home}${MCANavigation.galleryAlbum}") {
      return "Gallery";
    }
    if (currentRoute == "${MCANavigation.home}${MCANavigation.yt}") {
      return "Videos";
    }
    if (currentRoute == "${MCANavigation.home}${MCANavigation.loveOffering}") {
      return "Love Offering";
    }

    return "";
  }

  Widget? _getBottomBar(String currentRoute) {
    //hide bottom bar when viewing gallery
    if (currentRoute == MCANavigation.home ||
        currentRoute == "${MCANavigation.home}${MCANavigation.pillarCloud}" ||
        currentRoute == "${MCANavigation.home}${MCANavigation.pillarFire}" ||
        currentRoute == "${MCANavigation.home}${MCANavigation.loveOffering}") {
      return const DefaultBottomNavigationBar();
    }
    return null;
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onMenuPressed,
      icon: const Icon(Icons.menu),
    );
  }
}
