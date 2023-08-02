import 'package:dependency_plugin/dependencies/dependency_manager.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:efapp/presentation/global_widgets/layout/default_bottom_nav_bar.dart';
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
      bottomNavigationBar: const DefaultBottomNavigationBar(),
    );
  }

  PreferredSizeWidget? _getAppBar(String currentRoute) {
    logger('currentRoute: $currentRoute');
    if (currentRoute == MCANavigation.home) {
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
    return const DefaultAppBar();
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
