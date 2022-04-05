import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/providers/announcement_list_provider.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

final announcementListProvider = StateNotifierProvider<AnnouncementListProvider, List>(
  (ref) {
    WCUserInfoData? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData?.value;

    return AnnouncementListProvider(teamID: wcUserInfoData?.teamID ?? '');
  },
);
