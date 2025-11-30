import 'package:flutter/material.dart';

class MoviePosterItem extends StatefulWidget {
  final int? index;

  final double posterWidth = 120;
  final double posterHeight = 180;
  final Duration animationDuration = const Duration(milliseconds: 450);
  const MoviePosterItem({super.key, required this.index});

  @override
  State<MoviePosterItem> createState() => _MoviePosterItemState(); // State sınıfı adı düzeltildi
}

class _MoviePosterItemState extends State<MoviePosterItem> {
  bool _isOverlayVisible = false;
  List<Color> activeGradientColors = [
    Color(0xFF8A2BE2), // Mor (Blue Violet)
    Color(0xFF1E90FF), // Mavi (Dodger Blue)
  ];
  // Pasif durumda şeffaf border için (Animasyon yumuşak olsun diye pasif renk tanımlanmalı)
  List<Color> inactiveGradientColors = [Colors.transparent, Colors.transparent];
  void _toggleOverlay() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
    });
  }

  static const double overlayHeightRatio = 0.48;
  double get _overlayHeight => widget.posterHeight * overlayHeightRatio;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleOverlay,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeIn,
        child: AnimatedOpacity(
          opacity: 1,
          duration: widget.animationDuration,
          child: Container(
            width: widget.posterWidth,
            height: widget.posterHeight,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(3),
              gradient: _isOverlayVisible
                  ? LinearGradient(
                      colors: activeGradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: inactiveGradientColors, // Şeffaf gradient
                    ),
              border:_isOverlayVisible ? Border.all(width: 2,color: const Color.fromARGB(255, 255, 255, 255)) : null,
              image: DecorationImage(
                image: NetworkImage(
                  'https://picsum.photos/id/${1018 + (widget.index as num)}/200/300',
                ),
                fit: BoxFit.cover,
              ),
            ),

            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    height: _isOverlayVisible ? _overlayHeight : 0,
                    duration: widget.animationDuration,
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: AnimatedOpacity(
                      opacity: _isOverlayVisible ? 1.0 : 0.0,
                      duration: widget.animationDuration,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite, size: 28),
                              color: Colors.red,
                              onPressed: () {
                                /* Like Aksiyonu */
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.bookmark_add, size: 28),
                              color: Colors.amber,
                              onPressed: () {
                                /* Watchlist Aksiyonu */
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_horiz, size: 28),
                              color: Colors.green,
                              onPressed: () {
                                /* Like Aksiyonu */
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
