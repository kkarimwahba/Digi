import 'package:digi2/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:digi2/components/constants.dart';
import 'package:digi2/components/allinonboardscreen.dart';
import 'package:flutter/widgets.dart';

class OnboardScreen extends StatefulWidget {
  OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  late PageController _pageController;
  int currentIndex = 0;

  List<AllinOnboardModel> allinonboardlist = [
    AllinOnboardModel("assets/images/1.jpg", "", "Duplicate yourself"),
    AllinOnboardModel("assets/images/2.jpg", "", "Cloning your thoughts"),
    AllinOnboardModel("assets/images/3.jpg", "", "Enjoy with everyone"),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "DigiHuman",
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            itemCount: allinonboardlist.length,
            itemBuilder: (context, index) {
              return PageBuilderWidget(
                title: allinonboardlist[index].titlestr,
                description: allinonboardlist[index].description,
                imgurl: allinonboardlist[index].imgStr,
              );
            },
          ),
          const SizedBox(
            height: 140,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                allinonboardlist.length,
                (index) => buildDot(index: index),
              ),
            ),
          ),
          currentIndex < allinonboardlist.length - 1
              ? Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: currentIndex > 0
                            ? () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        child: const Text(
                          "Previous",
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 24, 30, 62)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightgreenshede1,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (currentIndex < allinonboardlist.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.2,
                  left: MediaQuery.of(context).size.width * 0.33,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) {
                          return Signup();
                        },
                      ));
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 24, 30, 62),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.black : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class PageBuilderWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imgurl;

  const PageBuilderWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imgurl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Image.asset(imgurl),
          ),
          const SizedBox(
            height: 20,
          ),
          // Title Text
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Description
          Text(
            description,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
