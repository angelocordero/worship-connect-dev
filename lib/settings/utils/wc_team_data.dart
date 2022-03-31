enum TeamDataEnum {
  creatorID,
  teamName,
  teamID,
  isOpen,
  coreInstruments,
  customInstruments,
}

class TeamData {
  final String creatorID;
  final String teamName;
  final String teamID;
  final bool isOpen;
  final List<String> coreInstruments;
  final List<String> customInstruments;

  TeamData({
    required this.creatorID,
    required this.teamID,
    required this.teamName,
    required this.isOpen,
    required this.coreInstruments,
    required this.customInstruments,
  });

  TeamData.empty()
      : creatorID = '',
        teamID = '',
        teamName = '',
        isOpen = true,
        coreInstruments = [],
        customInstruments = [];
}
