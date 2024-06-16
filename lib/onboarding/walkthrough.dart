import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:retro/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalkthroughScreen extends StatelessWidget {
  final PageController _controller = PageController();

  final Uri _discord = Uri.parse('https://discord.retromusic.co');
  final Uri _twitter = Uri.parse('https://twitter.com/retro_mp3');

  _launchDiscord() async {
    if (!await launchUrl(_discord)) {
      throw Exception('Could not launch $_discord');
    }
  }

  _launchTwitter() async {
    if (!await launchUrl(_twitter)) {
      throw Exception('Could not launch $_twitter');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _controller,
        children: <Widget>[
          // Initial page
          Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 10, 0), // Provide some padding from the top-right edge
                    child: TextButton(
                      child: Text('Skip', style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        int lastIndex = 4;  // The index of the last page
                        _controller.animateToPage(
                          lastIndex,
                          duration: Duration(milliseconds: 800), // Define the duration of the animation
                          curve: Curves.easeInOut, // Define the type of animation
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(0, -1), 
                        child: Icon(
                          SFSymbols.music_note_2, // Replace with your desired icon
                          size: 35, // Adjust the size as needed
                          color: Colors.black, // Adjust the color as needed
                        ),
                      ),
                      SizedBox(width: 5), // Creates space between the icon and the text
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: 40, color: Colors.black, fontFamily: 'Heros'),
                          children: <TextSpan>[
                            TextSpan(text: 'Retro', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    HapticFeedback.mediumImpact();
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0), // Adjust the bottom padding as needed
                      child: Text(
                        'Let\'s Get Started!',
                        style: TextStyle(fontSize: 24, color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // First page - retro-labeled
          Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 10, 0), // Provide some padding from the top-right edge
                    child: TextButton(
                      child: Text('Skip', style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        int lastIndex = 4;  // The index of the last page
                        _controller.animateToPage(
                          lastIndex,
                          duration: Duration(milliseconds: 800), // Define the duration of the animation
                          curve: Curves.easeInOut, // Define the type of animation
                        );
                      },
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.9,
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/onboarding/retro-labeled.png')
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    HapticFeedback.mediumImpact();
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0, right: 30,), // Adjust the bottom padding as needed
                      child: Icon(
                        SFSymbols.arrow_right, // Replace with your desired icon
                        size: 35, // Adjust the size as needed
                        color: Color.fromARGB(255, 59, 59, 59), // Adjust the color as needed
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Second page - retro-controls
          Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 10, 0), // Provide some padding from the top-right edge
                    child: TextButton(
                      child: Text('Skip', style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        int lastIndex = 4;  // The index of the last page
                        _controller.animateToPage(
                          lastIndex,
                          duration: Duration(milliseconds: 800), // Define the duration of the animation
                          curve: Curves.easeInOut, // Define the type of animation
                        );
                      },
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.9, // Adjust scale to match retro-labeled
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/onboarding/retro-controls.png')
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    HapticFeedback.mediumImpact();
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0, left: 30,), // Adjust the bottom padding as needed
                      child: Icon(
                        SFSymbols.arrow_left, // Replace with your desired icon
                        size: 35, // Adjust the size as needed
                        color: Color.fromARGB(255, 59, 59, 59), // Adjust the color as needed
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    HapticFeedback.mediumImpact();
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0, right: 30,), // Adjust the bottom padding as needed
                      child: Icon(
                        SFSymbols.arrow_right, // Replace with your desired icon
                        size: 35, // Adjust the size as needed
                        color: Color.fromARGB(255, 59, 59, 59), // Adjust the color as needed
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Third page - retro-spotify
          Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 10, 0), // Provide some padding from the top-right edge
                    child: TextButton(
                      child: Text('Skip', style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        int lastIndex = 4;  // The index of the last page
                        _controller.animateToPage(
                          lastIndex,
                          duration: Duration(milliseconds: 800), // Define the duration of the animation
                          curve: Curves.easeInOut, // Define the type of animation
                        );
                      },
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.9, // Adjust scale to match retro-labeled
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/onboarding/retro-spotify.png')
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    HapticFeedback.mediumImpact();
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0, left: 30,), // Adjust the bottom padding as needed
                      child: Icon(
                        SFSymbols.arrow_left, // Replace with your desired icon
                        size: 35, // Adjust the size as needed
                        color: Color.fromARGB(255, 59, 59, 59), // Adjust the color as needed
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    HapticFeedback.mediumImpact();
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0, right: 30,), // Adjust the bottom padding as needed
                      child: Icon(
                        SFSymbols.arrow_right, // Replace with your desired icon
                        size: 35, // Adjust the size as needed
                        color: Color.fromARGB(255, 59, 59, 59), // Adjust the color as needed
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Spotify API Key input page (conditional)
          if (dotenv.env['SPOTIFY_CLIENT_ID'] == "invalid") Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 10, 0), // Provide some padding from the top-right edge
                    child: TextButton(
                      child: Text('Skip', style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        int lastIndex = 4;  // The index of the last page
                        _controller.animateToPage(
                          lastIndex,
                          duration: Duration(milliseconds: 800), // Define the duration of the animation
                          curve: Curves.easeInOut, // Define the type of animation
                        );
                      },
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0), // Provide some padding from the top
                      child: Column(
                        children: <Widget>[
                          Text(
                            'One last step...',
                            style: TextStyle(color: Colors.blue, fontSize: 45,),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Retro detected that it has been sideloaded. To access Spotify features within our app, please provide your own Spotify API keys. Your credentials will only be stored locally and sent to Spotify for authentication purposes.\nEnter the Client ID into the text field below.',
                            style: TextStyle(color: Colors.blue[200], fontSize: 20,),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Client ID',
                            ),
                            onChanged: (text) async {
                              print(text);
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('clientID', text);
                              print(prefs.getString('clientID'));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    HapticFeedback.mediumImpact();
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0, left: 30,), // Adjust the bottom padding as needed
                      child: Icon(
                        SFSymbols.arrow_left, // Replace with your desired icon
                        size: 35, // Adjust the size as needed
                        color: Color.fromARGB(255, 59, 59, 59), // Adjust the color as needed
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    HapticFeedback.mediumImpact();
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0, right: 30,), // Adjust the bottom padding as needed
                      child: Icon(
                        SFSymbols.arrow_right, // Replace with your desired icon
                        size: 35, // Adjust the size as needed
                        color: Color.fromARGB(255, 59, 59, 59), // Adjust the color as needed
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Final page
          Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 100, 20, 0), // Provide some padding from the top
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Thanks for checking out Retro v2!\n\nFor assistance or more information, consider joining the Discord or following us on X (formerly Twitter)!',
                          style: TextStyle(color: Colors.blue, fontSize: 16,),
                          textAlign: TextAlign.center,
                        ),
                        Text('\nListen responsibly.\n', style: TextStyle(color: Colors.blue, fontSize: 17, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // aligns the images horizontally
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _launchDiscord();
                            HapticFeedback.mediumImpact();
                          },
                          child: Image.asset(
                            'assets/onboarding/discord.png', 
                            width: 125,
                          ),
                        ),
                        SizedBox(width: 20), // optional, adds space between the images
                        GestureDetector(
                          onTap: () {
                            _launchTwitter();
                            HapticFeedback.mediumImpact();
                          },
                          child: Image.asset(
                            'assets/onboarding/twitter.png', 
                            width: 125,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    HapticFeedback.mediumImpact();
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0, left: 30,), // Adjust the bottom padding as needed
                      child: Icon(
                        SFSymbols.arrow_left, // Replace with your desired icon
                        size: 35, // Adjust the size as needed
                        color: Color.fromARGB(255, 59, 59, 59), // Adjust the color as needed
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => IPodApp()),
                    );
                    HapticFeedback.mediumImpact();
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0, right: 30,), // Adjust the bottom padding as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Continue to Retro',  // Replace with your desired text
                            style: TextStyle(
                              fontSize: 20,  // Adjust the size as needed
                              color: Color.fromARGB(255, 59, 59, 59),  // Adjust the color as needed
                            ),
                          ),
                          SizedBox(width: 10),  // Creates space between the text and the icon
                          Icon(
                            SFSymbols.arrow_right, // Replace with your desired icon
                            size: 35, // Adjust the size as needed
                            color: Color.fromARGB(255, 59, 59, 59), // Adjust the color as needed
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
