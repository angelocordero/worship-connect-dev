import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';

class MemberListPage extends ConsumerWidget {
  const MemberListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final WCUserInfoData _userData = ref.watch(wcUserInfoDataStream).asData!.value!;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Members'),
        ),
        body: ListView(),
        //TODO: show member list
      ),
    );
  }
}
