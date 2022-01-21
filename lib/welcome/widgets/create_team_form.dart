import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/welcome/widgets/join_create_team_form_switcher.dart';

class CreateTeamForm extends ConsumerWidget {
  const CreateTeamForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createTeamName = ref.watch(createTeamNameProvider.state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'You can add other members by sharing the Team ID after the team has been created',
          style: TextStyle(color: Colors.white),
        ),
        TextField(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          onChanged: (value) {
            createTeamName.state = value;
          },
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(8),
            hintText: "Enter Team Name",
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
