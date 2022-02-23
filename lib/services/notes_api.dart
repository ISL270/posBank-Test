class NotesAPI {
  static const String _host = '192.236.155.173';

  Uri getAllNotesUri() => Uri(
        scheme: 'http',
        host: _host,
        port: 55886,
        path: 'notes/getall',
      );

  Uri addNoteUri() => Uri(
        scheme: 'http',
        host: _host,
        port: 55886,
        path: 'notes/insert',
      );
}
