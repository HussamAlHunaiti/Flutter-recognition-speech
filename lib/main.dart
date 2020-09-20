import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Recognition Speech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () {
        print('flutter');
      },
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'speech recognition': HighlightedWord(
      onTap: () {
        print('speech recognition');
      },
      textStyle: const TextStyle(
        color: Colors.amber,
        fontWeight: FontWeight.bold,
      ),
    ),
    'hussam': HighlightedWord(
      onTap: () {
        print('hussam');
      },
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () {
        print('voice');
      },
      textStyle: const TextStyle(
        color: Colors.purple,
        fontWeight: FontWeight.bold,
      ),
    ),
    'github': HighlightedWord(
      onTap: () {
        print('github');
      },
      textStyle: const TextStyle(
        color: const Color(0xff424242),
        fontWeight: FontWeight.bold,
      ),
    ),
  };
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button to start.';
  double _confidunce = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus ${val}'),
        onError: (val) => print('onError ${val}'),
      );

      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (val) => setState(() {
            _text += ' ' + val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidunce = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: %${(_confidunce * 100.0).toStringAsFixed(1)}'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
