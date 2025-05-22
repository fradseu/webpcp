import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MobileHomePage extends ConsumerWidget {
  const MobileHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(body: Center(child: Text("Mobile")));
  }
}

class TabletHomePage extends ConsumerWidget {
  const TabletHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(body: Center(child: Text("Tablet")));
  }
}

class DesktopHomePage extends ConsumerWidget {
  const DesktopHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(body: Center(child: Text("Desktop")));
  }
}
