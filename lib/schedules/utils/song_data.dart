enum WCSongDataEnum {
  songTitle,
  songURL,
  songKey,
  songID,
}

class WCSongData {
  final String songTitle;
  final String? songURL;
  final String songKey;
  final String songID;

  WCSongData({
    required this.songTitle,
    required this.songKey,
    required this.songID,
    this.songURL,
  });
}
