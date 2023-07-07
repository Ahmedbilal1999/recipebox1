// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecognization extends StatefulWidget {
  VoiceRecognization(
      {required this.controller,
      required this.focusNode,
      this.onChanged,
      super.key});
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  Function(String)? onChanged;

  @override
  State<VoiceRecognization> createState() => _VoiceRecognizationState(
      controller: controller, focusNode: focusNode, onChanged: onChanged);
}

class _VoiceRecognizationState extends State<VoiceRecognization> {
  _VoiceRecognizationState(
      {required this.controller, required this.focusNode, this.onChanged});
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  Function(String)? onChanged;
  late SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';

  //String _currentLocale = 'en_US';
  Language selectedLang = const Language('English', 'en_US');
  Future<void> activateSpeechRecognizer() async {
    _speech = SpeechRecognition();
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      _speech.setAvailabilityHandler(onSpeechAvailability);
      _speech.setRecognitionStartedHandler(onRecognitionStarted);
      _speech.setRecognitionResultHandler(onRecognitionResult);
      _speech.setRecognitionCompleteHandler(onRecognitionComplete);
      _speech.setErrorHandler(errorHandler);
      _speech.activate('en_US').then((res) {
        setState(() => _speechRecognitionAvailable = res);
      });
    }
  }

  @override
  initState() {
    super.initState();

    activateSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    controller.text = transcription;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        onChanged: (val) {
          controller.text = val;
          transcription = val;
        },
        onFieldSubmitted: onChanged,
        decoration: InputDecoration(
            // hintText: controller.text,
            suffixIcon: _speechRecognitionAvailable && !_isListening
                ? IconButton(
                    onPressed: () {
                      transcription = '';
                      start();
                    },
                    icon: Icon(Icons.keyboard_voice_sharp))
                : IconButton(
                    onPressed: () {
                      transcription = '';
                      stop();
                    },
                    icon: Icon(Icons.keyboard_voice_outlined))),
      ),
    );
  }

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_MyAppState.start => result $result');
          setState(() {
            _isListening = result;
            onChanged;
          });
        });
      });

  void cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
    print('_MyAppState.onRecognitionResult... $text');
    setState(() {
      transcription = text;
      onChanged;
    });
  }

  void onRecognitionComplete(String text) {
    print('_MyAppState.onRecognitionComplete... $text');
    setState(() {
      _isListening = false;
    });
  }

  void errorHandler() => activateSpeechRecognizer();
}

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}
