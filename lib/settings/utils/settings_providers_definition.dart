import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/providers/instruments_list_provider.dart';
import 'package:worship_connect/settings/providers/members_list_provider.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/settings/utils/wc_team_data.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

final wcWCTeamDataStream = StreamProvider<WCTeamData?>((ref) {
  final WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData?.value;

  if (_wcUserInfoData == null) {
    return Stream.value(null);
  }

  return TeamFirebaseAPI(_wcUserInfoData.teamID).teamData();
});

final membersListProvider = StateNotifierProvider<MembersListProvider, Map<String, WCUserInfoData>>(
  (ref) {
    AsyncData<WCUserInfoData?>? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData;

    return MembersListProvider(
      teamID: wcUserInfoData?.value?.teamID ?? '',
    );
  },
);

final customInstrumentsListProvider = StateNotifierProvider<CustomInstrumentsListProvider, List<String>>((ref) {
  final WCUserInfoData _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value!;

  return CustomInstrumentsListProvider(teamID: _wcUserInfoData.teamID);
});
