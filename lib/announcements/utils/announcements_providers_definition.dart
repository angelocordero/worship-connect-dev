import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/providers/announcement_list_provider.dart';
import 'package:worship_connect/announcements/providers/send_announcement_provider.dart';
import 'package:worship_connect/announcements/utils/announcements_data.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';

final sendAnnouncementProvider = StateNotifierProvider.autoDispose<SendAnnouncementProvider, WCAnnouncementsData>(
  (ref) {
    AsyncData<WCUserInfoData?>? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData;

    return SendAnnouncementProvider(
      data: WCAnnouncementsData.empty(),
      teamID: wcUserInfoData?.value?.teamID ?? '',
    );
  },
);

final announcementListProvider = StateNotifierProvider<AnnouncementListProvider, List>(
  (ref) {
    WCUserInfoData? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData?.value;

    return AnnouncementListProvider(teamID: wcUserInfoData?.teamID ?? '');
  },
);

