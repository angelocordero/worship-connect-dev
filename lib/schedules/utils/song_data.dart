enum WCSongDataEnum {
  songTitle,
  songURL,
  songKey,
  songID,
  songURLTitle,
}

class WCSongData {
  final String songTitle;
  final String? songURL;
  final String songKey;
  final String songID;
  final String? songURLTitle;

  WCSongData({
    required this.songTitle,
    required this.songKey,
    required this.songID,
    this.songURL,
    this.songURLTitle,
  });
}
