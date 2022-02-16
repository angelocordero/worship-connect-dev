import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/widgets/team_settings.dart';

class MembersListPage extends ConsumerWidget {
  const MembersListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _membersListNotifier = ref.watch(membersListProvider.notifier);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Members'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _membersListNotifier.initMemberList();
          },
          child: ListView(
            children: [
              _membersListNotifier.getLeader(),
              ..._membersListNotifier.getAdmins(),
              ..._membersListNotifier.getNormalMembers(),
            ],
          ),
        ),
      ),
    );
  }
}
