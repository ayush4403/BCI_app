import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mindwave_mobile2_example/screens/morning.dart';
import 'package:mindwave_mobile2_example/screens/music.dart';

class SessionSelectionPage extends StatefulWidget {
  @override
  _SessionSelectionPageState createState() => _SessionSelectionPageState();
}

class _SessionSelectionPageState extends State<SessionSelectionPage> {
  final List<int> sessionDurations = [40,120,300]; // Session durations in minutes
  final List<String> musicNames = [
    "Visualize",
    "Guided",
    "BrainBeats"
  ]; // Music names
  final List<String> musicFiles = [
    "https://firebasestorage.googleapis.com/v0/b/test-4fa40.appspot.com/o/Visualize_1.mp3?alt=media&token=3ff30fb7-ad95-48de-9500-11b79c02ea63",
    "https://firebasestorage.googleapis.com/v0/b/test-4fa40.appspot.com/o/guided_1.mp3?alt=media&token=0b36663b-8c9e-46eb-9a83-b9c003437a25",
    "https://firebasestorage.googleapis.com/v0/b/test-4fa40.appspot.com/o/B-BALANCE_BRAIN_AND_BODY.mp3?alt=media&token=5d0a90e6-00cf-490b-8425-17d8dea27714"
  ]; // Music file paths
  int? selectedDuration;
  String? selectedMusicName;
  String? selectedMusicFile;
  bool playMusic = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Session Duration:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            DropdownButton<int>(
              hint: Text('Pick a duration'),
              value: selectedDuration,
              onChanged: (int? newValue) {
                setState(() {
                  selectedDuration = newValue;
                });
              },
              items: sessionDurations.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value seconds'),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Select Music:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: musicNames.map((musicName) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedMusicName = musicName;
                      selectedMusicFile =
                          musicFiles[musicNames.indexOf(musicName)];
                    });
                  },
                  child: Text(musicName),
                  style: ElevatedButton.styleFrom(
                    primary: selectedMusicName == musicName
                        ? Colors.blueAccent
                        : Colors.blue,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Play Music:',
              style: TextStyle(fontSize: 18),
            ),
            Switch(
              value: playMusic,
              onChanged: (bool value) {
                setState(() {
                  playMusic = value;
                });
              },
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (selectedDuration != null) {
                  final musicStatus = playMusic && selectedMusicName != null
                      ? "will be played: $selectedMusicName"
                      : "will not be played";
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Session Details'),
                      content: Text(
                          'Session duration: $selectedDuration minutes\nMusic $musicStatus'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => MorningMeditation(
                                          audiostatus: playMusic,
                                          audiofile: selectedMusicFile ?? '', value: selectedDuration ?? 40,
                                          
                                        )));
                                        //Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>)));
              },
              child: Text('Submit'),
            ),
            // if (playMusic )
            //   MusicPlayerWidget(audioUrl:selectedMusicFile ??'' ),
            // if (playMusic )
            //   Text("Now Playing ${musicNames[musicFiles.indexOf(selectedMusicFile!)]}"),
          ],
        ),
      ),
    );
  }
}
