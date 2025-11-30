import 'package:cinebond/components/items/movie_poster_item.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140026),
      extendBody: true,
      body: _buildBody()
    );
  }
  
  Widget? _buildBody() {
    return Column(
      children: [
        VerticalSpacing(10),
        Expanded(flex:3,child: _buildFilmFinderRow()),
        VerticalSpacing(20),
        Expanded(flex:12,child: _buildFilmExploreRow()),
      ],
    );
  }
  
  Widget _buildFilmFinderRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidgetFinder(),
        VerticalSpacing(13),
        _buildListWidgetFinder(),
      ],
    );
  }

  Widget _buildFilmExploreRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidgetFeed(),
        VerticalSpacing(13),
        _buildListWidgetFeed(),
      ],
    );
  }
  
  Widget _buildTitleWidgetFinder() {
    return Text("Bugün ne izlesem?",style: Theme.of(context).textTheme.titleMedium);
  }
  
  Widget _buildListWidgetFinder() {
    return Expanded(
      child: ListView.separated(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            height:60,
            width:170,
            color: Colors.white,
          );
        },
        separatorBuilder: (context, index) {
          return HorizontalSpacing(10);
        },
      ),
    );
  }
  
  Widget _buildTitleWidgetFeed() {
    return Text("Keşfet",style: Theme.of(context).textTheme.titleMedium);
  }
  
  Widget _buildListWidgetFeed() {
    return Expanded(
      child: GridView.builder(
        itemCount: 100,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.all(8.0),
          child: MoviePosterItem(index: index,),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
      )
    );
  }
  
}




