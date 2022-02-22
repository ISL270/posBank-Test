import 'package:bawq_test/data/providers/mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Use SQLite",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Switch.adaptive(
                value: Provider.of<ModeProvider>(context).useSQLite,
                onChanged: (value) {
                  final themeProvider =
                      Provider.of<ModeProvider>(context, listen: false);
                  themeProvider.toggleMode();
                }),
          ],
        ),
      ),
    );
  }
}
