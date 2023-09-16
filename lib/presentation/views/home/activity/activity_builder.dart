import 'package:anirecord/data/providers/riverpod/serie_provider.dart';
import 'package:anirecord/presentation/views/home/activity/activity_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityBuilder extends ConsumerWidget {
  const ActivityBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(getActivityProvider);
    return Scaffold(
      backgroundColor: Colors.white,
        body: activity.when(data: (data) {
      return ActivityView(data: data);
    }, error: (_, __) {
      return Center(
        child: Text(__.toString()),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }));
  }
}
