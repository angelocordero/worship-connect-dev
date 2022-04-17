import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/welcome/widgets/join_create_team_form_switcher.dart';

class JoinTeamForm extends ConsumerWidget {
  const JoinTeamForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinTeamID = ref.watch(joinTeamIDProvider.state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Ask your team for a Team ID',
          style: TextStyle(color: Colors.white),
        ),
        const Text(
          'A Team ID should look like this',
          style: TextStyle(color: Colors.white),
        ),
        const Text(
          '75a2U-fPcfs-hk1r7',
          style: TextStyle(color: Colors.white),
        ),
        TextField(
          onChanged: (value) {
            joinTeamID.state = value;
          },
          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(8),
            hintText: "Enter Team ID",
            hintStyle: wcHintStyle,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
