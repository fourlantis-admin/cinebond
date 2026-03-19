
import 'package:cinebond/components/feed/post/action_button.dart';
import 'package:cinebond/components/feed/post/movie_attachment_card.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/view/main/explore/explore_view.dart';
import 'package:flutter/material.dart';

class PostModelCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onRepost;

  PostModelCard({
    required this.post,
    required this.onLike,
    required this.onRepost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 19,
            backgroundImage: NetworkImage(post.avatarUrl),
            backgroundColor: Colors.white12,
          ),
          HorizontalSpacing(12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + handle + time
                Row(
                  children: [
                    Text(
                      post.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const VerticalSpacing(6),
                    Text(
                      post.handle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 13,
                      ),
                    ),
                    Spacer(),
                    Text(
                      post.timeAgo,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                VerticalSpacing( 6),
                // Post text
                Text(
                  post.content,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                // Movie card (optional)
                if (post.moviePosterUrl != null) ...[
                  VerticalSpacing( 10),
                  MovieAttachmentCard(
                    posterUrl: post.moviePosterUrl!,
                    title: post.movieTitle ?? "",
                    model: post,
                  ),
                ],
                VerticalSpacing( 12),
                // Action row
                Row(
                  children: [
                    ActionButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      count: post.comments,
                      active: false,
                      activeColor: Color(0xFF1DA1F2),
                      onTap: () {},
                    ),
                    HorizontalSpacing(7),
                    ActionButton(
                      icon: Icons.repeat_rounded,
                      count: post.reposts + (post.isReposted ? 1 : 0),
                      active: post.isReposted,
                      activeColor: Color(0xFF00BA7C),
                      onTap: onRepost,
                    ),
                    HorizontalSpacing(7),
                    ActionButton(
                      icon: post.isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      count: post.likes + (post.isLiked ? 1 : 0),
                      active: post.isLiked,
                      activeColor: Color(0xFFF91880),
                      onTap: onLike,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
