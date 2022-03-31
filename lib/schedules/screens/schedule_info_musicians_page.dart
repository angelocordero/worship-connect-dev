import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/widgets/add_instruments_card.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class ScheduleInfoMusiciansPage extends ConsumerWidget {
  const ScheduleInfoMusiciansPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: Visibility(
              child: Container(),
            ),
          ),
          if (WCUtils.isAdminOrLeader(_wcUserInfoData!)) _buildButtons(context, ref),
        ],
      ),
    );
  }

  Row _buildButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Hero(
            tag: 'instruments',
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  WCCustomRoute(
                    builder: (context) {
                      return const AddInstrumentsCard();
                    },
                  ),
                );
              },
              child: const Text('Add Instruments'),
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {},
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }
}
