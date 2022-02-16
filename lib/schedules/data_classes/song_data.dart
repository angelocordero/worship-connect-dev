enum SongDataEnum {
  songTitle,
  songURL,
  songKey,
  songID,
}

class SongData {
  final String songTitle;
  final String songURL;
  final String songKey;
  final String songID;

  SongData({
    required this.songTitle,
    required this.songKey,
    required this.songURL,
    required this.songID,
  });
}
