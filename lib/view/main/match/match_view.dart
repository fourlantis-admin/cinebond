import 'package:cinebond/components/buttons/tinder_button.dart';
import 'package:cinebond/components/swipe/tinder_environment.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MatchView extends StatefulWidget {
  const MatchView({super.key});

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  
  List<Profile> _profiles = [];
  @override
  void initState() {
   _profiles = [
    Profile(
      nameAge: "Brit, 22",
      occupation: "Senior Developer",
      interests: "Godfather II, LOTR, Harry Potter",
      color: const Color(0xFF6C63FF),
      picture: Image.network(
  'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
  fit: BoxFit.fill,
)
    ),
    Profile(
      nameAge: "Alex, 25",
      occupation: "UX Designer",
      interests: "Hiking, Coffee, Indie Music",
      color: const Color(0xFFFF6384),
           picture: Image.network(
  'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
  fit: BoxFit.fill,
)
    ),
    Profile(
      nameAge: "Elara, 28",
      occupation: "Data Scientist",
      interests: "Astronomy, Cats, 80s Movies",
      color: const Color(0xFF4BC0C0),
           picture: Image.network(
  'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
  fit: BoxFit.fill,
)
    ),
    Profile(
      nameAge: "Kai, 31",
      occupation: "Architect",
      interests: "Sketching, Jazz, Minimalism",
      color: const Color(0xFFFF9F40),
           picture: Image.network(
  'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
  fit: BoxFit.fill,
)
    ),
  ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(child: _buildBody());
  }

  Widget? _buildBody() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned(left: 0, right: 0, top: 0, child: _buildProfileCard()),
              Positioned(bottom: 150, left: 20, child: _buildReturnButton()),
              Positioned(bottom: 150, left: 160, child: _buildCancelButton()),
              Positioned(bottom: 150, right: 20, child: _buildLikeButton()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        VerticalSpacing(50),
        TinderButton(
          onClickBtnFunc: () {},
          icon: SvgPicture.asset(ImagesIcons.LIKE_ICON, height: 10),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      child: TinderEnvironment(profiles: _profiles),
    );
  }

  Widget _buildReturnButton() {
    return TinderButton(
      onClickBtnFunc: () {},
      icon: SvgPicture.asset(ImagesIcons.RETURN_ICON),
    );
  }

  Widget _buildCancelButton() {
    return TinderButton(
      onClickBtnFunc: () {},
      icon: SvgPicture.asset(ImagesIcons.DISLIKE_ICON),
    );
  }

  Widget _buildLikeButton() {
    return TinderButton(
      onClickBtnFunc: () {},
      icon: SvgPicture.asset(ImagesIcons.LIKE_ICON, height: 10, width: 10),
    );
  }
}
