import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';

class AssignMembersPage extends ConsumerStatefulWidget {
  const AssignMembersPage({
    Key? key,
    required this.unassignedMembersList,
    required this.instrumentName,
  }) : super(key: key);

  final List<String> unassignedMembersList;
  final String instrumentName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AssignMembersPageState();
}

class AssignMembersPageState extends ConsumerState<AssignMembersPage> {
  final List<String> _selectedMembers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assign members',
          style: GoogleFonts.exo2(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.unassignedMembersList.length,
              itemBuilder: (context, index) {
                String _name = widget.unassignedMembersList[index];

                return CheckboxListTile(
                  title: Text(_name),
                  value: _selectedMembers.contains(_name),
                  onChanged: (selected) {
                    if (selected!) {
                      setState(() {
                        _selectedMembers.add(_name);
                      });
                    } else if (!selected) {
                      setState(() {
                        _selectedMembers.remove(_name);
                      });
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await ref.read(scheduleMusiciansProvider.notifier).addMusicians(instrument: widget.instrumentName, musicians: _selectedMembers);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
}
