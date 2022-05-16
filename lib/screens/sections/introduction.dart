import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:touristop/screens/main/login_screen.dart';
// import 'package:touriststap_capstone/Screens/homepage.dart';
// import 'package:touriststap_capstone/Screens/loginscreen.dart';
//import 'package:touriststap_capstone/home.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            titleWidget: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.neucha(
                          fontSize: 38.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Find the best '),
                          TextSpan(
                              text: 'Tourist Spot ',
                              style: GoogleFonts.neucha(
                                color: Color.fromRGBO(43, 193, 157, 1),
                              )),
                          TextSpan(text: 'yourself'),
                        ],
                      )),
                ),
              ],
            ),
            body: "Easily locate tourist spots near you.",
            image: Container(
              padding: EdgeInsets.only(top: 30),
              width: size.width,
              child: buildImage('assets/images/look.png'),
            ),
          ),
          PageViewModel(
            titleWidget: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.neucha(
                          fontSize: 38.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Travel all over '),
                          TextSpan(
                              text: 'Manila ',
                              style: GoogleFonts.neucha(
                                color: Color.fromRGBO(49, 64, 195, 1),
                              )),
                        ],
                      )),
                ),
              ],
            ),
            bodyWidget: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Go to different places in Manila with our built-in navigation for you.",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            image: Container(
              padding: EdgeInsets.only(top: 30),
              width: size.width,
              child: buildImage('assets/images/Travels.png'),
            ),
          ),
          PageViewModel(
            titleWidget: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.neucha(
                          fontSize: 38.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Appreciate the '),
                          TextSpan(
                              text: 'views  ',
                              style: GoogleFonts.neucha(
                                color: Color.fromRGBO(43, 193, 157, 1),
                              )),
                          TextSpan(text: 'and '),
                          TextSpan(
                              text: 'landmarks',
                              style: GoogleFonts.neucha(
                                color: Color.fromRGBO(49, 64, 195, 1),
                              )),
                        ],
                      )),
                ),
              ],
            ),
            bodyWidget: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Go to different places in Manila with our built-in navigation for you.",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            image: Container(
              padding: EdgeInsets.only(top: 30),
              width: size.width,
              child: buildImage('assets/images/Victory.png'),
            ),
          ),
        ],
        showNextButton: true,
        done: Text('Done',
            style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(49, 64, 195, 1))),
        onDone: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        },
        next: Container(
          alignment: Alignment.bottomRight,
          child: const FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 24,
            color: Color.fromRGBO(43, 193, 157, 1),
          ),
        ),
        dotsDecorator: getDotDecoration(),
      ),
    );
  }
}

Widget buildImage(String path) => Center(
      child: Image.asset(path),
    );

DotsDecorator getDotDecoration() => DotsDecorator(
    color: const Color.fromRGBO(196, 196, 196, 1),
    activeColor: const Color.fromRGBO(43, 193, 157, 1),
    size: const Size(10, 10),
    activeSize: const Size(28, 10),
    activeShape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)));

PageDecoration getPageDecoration() => PageDecoration(
      bodyTextStyle: GoogleFonts.roboto(fontSize: 18),
    );
