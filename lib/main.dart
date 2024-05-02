import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
      statusBarBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Translate',
      debugShowCheckedModeBanner: false,
      home: LanguageSwitcher(),
    );
  }
}

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({super.key});

  @override
  _LanguageSwitcherState createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  bool isEnglishShown = true;
  String englishText = '';
  String spanishText = '';

  String englishTitle = 'English';
  String spanishTitle = 'Spanish';

  final String apiKey = 'api';

  Future<String> translateText(String text, String targetLanguage) async {
    try {
      final Uri url = Uri.parse(
          "https://google-translate113.p.rapidapi.com/api/v1/translator/text");
      final Map<String, String> headers = {
        'content-type': "application/x-www-form-urlencoded",
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': "google-translate113.p.rapidapi.com",
      };
      final String payload = "from=auto&to=$targetLanguage&text=$text";

      final http.Response response =
          await http.post(url, headers: headers, body: payload);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('trans')) {
          final String translatedText = responseData['trans'];
          return translatedText;
        } else if (responseData.containsKey('output')) {
          final String translatedText = responseData['output'];
          return translatedText;
        } else if (responseData.containsKey('translation')) {
          final String translatedText = responseData['translation'];
          return translatedText;
        } else {
          throw Exception(
              'Failed to translate text: Translation data not found in response');
        }
      } else {
        throw Exception('Failed to translate text: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Translation failed: $e');
    }
  }

  void _updateTranslation(String text) async {
    try {
      if (isEnglishShown) {
        spanishText = await translateText(text, 'es');
        englishText = text;
      } else {
        englishText = await translateText(text, 'en');
        spanishText = text;
      }
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    englishTitle = isEnglishShown ? 'English' : 'Spanish';
    spanishTitle = isEnglishShown ? 'Spanish' : 'English';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Translate",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  isEnglishShown ? "English" : "Spanish",
                  style: const TextStyle(fontSize: 25),
                ),
                IconButton(
                  icon: const Icon(Icons.compare_arrows),
                  iconSize: 35,
                  onPressed: () {
                    setState(() {
                      isEnglishShown = !isEnglishShown;
                      englishText = '';
                      spanishText = '';
                    });
                  },
                ),
                Text(
                  isEnglishShown ? "Spanish" : "English",
                  style: const TextStyle(fontSize: 25),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.mic_rounded,
                    color: Colors.grey,
                  ),
                  iconSize: 35,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  ),
                  iconSize: 35,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.home_outlined,
                    color: Colors.grey,
                  ),
                  iconSize: 35,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 270,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromARGB(200, 236, 236, 236),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        englishTitle,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        maxLength: 500,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Text",
                          border: InputBorder.none,
                          labelStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        onChanged: (value) {
                          _updateTranslation(value);
                        },
                      ),
                      const Expanded(child: SizedBox()),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 270,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        spanishTitle,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        isEnglishShown ? spanishText : englishText,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
        ],
      ),
    );
  }
}
