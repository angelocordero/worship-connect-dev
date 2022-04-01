import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worship_connect/settings/utils/settings_providers_definition.dart';

class MembersListPage extends ConsumerWidget {
  const MembersListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _membersListNotifier = ref.watch(membersListProvider.notifier);

    //TODO: list not reseting

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Members',
            style: GoogleFonts.exo2(),
          ),
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
