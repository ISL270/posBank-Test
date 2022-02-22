class Note {
  int? noteID;
  String? note;
  Note(this.note, {this.noteID});

//Create a Note from JSON data
  factory Note.fromJson(Map<String, dynamic> json) =>
      Note(json['note'], noteID: json['noteId']);

// Convert a Note to JSON to make it easier to store in the database
  Map<String, dynamic> toJson() => {'noteId': noteID, 'note': note};
}
