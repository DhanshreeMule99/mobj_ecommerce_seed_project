import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mobj_project/module/home/homeScreen.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key});

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  int _currentPage = 0;

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return SafeArea(
      child: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,
        allowImplicitScrolling: true,
        showNextButton: false,
        // autoScrollDuration: 3000,
        // infiniteAutoScroll: false,
        globalFooter: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            child: Text(_currentPage == 2 ? 'Done' : 'Next',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            onPressed: () {
              if (_currentPage < 2) {
                introKey.currentState?.animateScroll(_currentPage + 1);
                // _currentPage++;
              } else {
                _onIntroEnd(context);
              }
            },
          ),
        ),
        pages: [
          PageViewModel(
            title: "Updated Products Everyday",
            body:
                "Don't worry you won't be outdated. Stay up-to-date everyday.",
            image: _buildImage('women.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Easy Transcation And Payment",
            body: "Very safe and Secure payment transcations.",
            image: _buildImage('splach2.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Free Shipping",
            body: "Free shipping all over India.",
            image: _buildImage('shipping.jpg'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        showBackButton: false,
        done: const Text('', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        onChange: (value) {
          setState(() {
            _currentPage = value;
          });
        },
      ),
    );
  }
}
