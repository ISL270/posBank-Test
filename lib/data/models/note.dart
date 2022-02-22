class Note {
  dynamic noteID;
  String? note;
  Note(this.note, {this.noteID});

//Create a Note from JSON data
  factory Note.fromJson(Map<String, dynamic> json) =>
      Note(json['text'], noteID: json['id']);

// Convert a Note to JSON to make it easier to store in the database
  Map<String, dynamic> toJson() => {'text': note, 'id': noteID};
}
