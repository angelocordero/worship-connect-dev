import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/providers/members_list_provider.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/settings/utils/wc_team_data.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';

final wcTeamDataStream = StreamProvider<TeamData>((ref) {
  final WCUserInfoData _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value!;

  return TeamFirebaseAPI(_wcUserInfoData.teamID).teamData();
});

final membersListProvider = StateNotifierProvider.autoDispose<MembersListProvider, dynamic>(
  (ref) {
    AsyncData<WCUserInfoData?>? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData;

    return MembersListProvider(
      teamID: wcUserInfoData?.value?.teamID ?? '',
    );
  },
);