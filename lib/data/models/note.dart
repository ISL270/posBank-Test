class Note {
  dynamic noteID;
  String? userID;
  String? note;
  String? placeDateTime;
  Note(this.note,
      {this.noteID = 1,
      this.userID = '1',
      this.placeDateTime = "2022-02-23T21:38:24.0319748+00:00"});

//Create a Note from JSON data
  factory Note.fromJson(Map<String, dynamic> json) => Note(json['text'],
      noteID: json['id'],
      userID: json['userId'],
      placeDateTime: json['placeDateTime']);

// Convert a Note to JSON to make it easier to store in the database
  Map<String, dynamic> toJsonSQLite() => {'text': note};

  Map<String, dynamic> toJsonAPI() =>
      {'text': note, 'userId': userID, 'placeDateTime': placeDateTime};
}
