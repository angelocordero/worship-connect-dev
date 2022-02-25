import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';

final userNameProvider = StateProvider.autoDispose<String>((ref) {
  AsyncData<WCUserInfoData?>? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData;

  return wcUserInfoData?.value?.userName ?? '';
});