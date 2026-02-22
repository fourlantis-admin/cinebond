
// -----------------------------------------------------------------------------
// Movie Attachment Card
// -----------------------------------------------------------------------------

import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/view/main/explore/explore_view.dart';
import 'package:flutter/material.dart';

class MovieAttachmentCard extends StatelessWidget {
  final String posterUrl;
  final String title;
  final PostModel model;

  MovieAttachmentCard({required this.posterUrl, required this.title,required this.model});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white10,
        ),
        child: Row(
          children: [
            // Poster thumbnail
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                posterUrl,
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  color: Colors.white12,
                  child: Icon(Icons.movie, color: Colors.white38),
                ),
              ),
            ),
            HorizontalSpacing(12),
            // Title + chip
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Color(0xFFF91880).withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color(0xFFF91880).withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        model.type,
                        style: TextStyle(
                          color: Color(0xFFF91880),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const VerticalSpacing(12),
          ],
        ),
      ),
    );
  }
}
