class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "A new Digitl You",
    image: "assets/images/1.jpg",
    desc:
        "Start a new digital life with your own shape,personality and customize voice.",
  ),
  OnboardingContents(
    title: "Clone yourself",
    image: "assets/images/2.jpg",
    desc: "Clone your personality in the new world of technology.",
  ),
  OnboardingContents(
    title: "Control your digital twin",
    image: "assets/images/3.jpg",
    desc: "Take control of the digital twin of you by creating amazing ones.",
  ),
];
