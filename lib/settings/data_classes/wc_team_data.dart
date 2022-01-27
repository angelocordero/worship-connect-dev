enum TeamDataEnum {
  creatorID,
  teamName,
  teamID,
  isOpen,
}


class TeamData {
  final String creatorID;
  final String teamName;
  final String teamID;
  final bool isOpen;

  TeamData({
    required this.creatorID,
    required this.teamID,
    required this.teamName,
    required this.isOpen,
  });

  TeamData.empty()
      : creatorID = '',
        teamID = '',
        teamName = '',
        isOpen = true;
}
