import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PickMusiciansPage extends ConsumerWidget {
  const PickMusiciansPage({Key? key, required this.unassignedMembersList}) : super(key: key);

  final List<String> unassignedMembersList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add musicians'),
      ),
      body: ListView.builder(
        itemCount: unassignedMembersList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(unassignedMembersList[index]),
          );
        },
      ),
    );
  }
}
