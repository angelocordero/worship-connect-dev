enum WCTeamDataEnum {
  creatorID,
  teamName,
  teamID,
  isOpen,
}

class WCTeamData {
  final String creatorID;
  final String teamName;
  final String teamID;
  final bool isOpen;

  WCTeamData({
    required this.creatorID,
    required this.teamID,
    required this.teamName,
    required this.isOpen,
  });

  WCTeamData.empty()
      : creatorID = '',
        teamID = '',
        teamName = '',
        isOpen = true;
}
