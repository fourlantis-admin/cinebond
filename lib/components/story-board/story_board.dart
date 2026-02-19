import 'package:flutter/material.dart';

class StoryBoard extends StatelessWidget {
  final int storyCount;

  const StoryBoard({
    super.key,
    required this.storyCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 60,
          child: StoryRow(length: storyCount),
        ),
      ],
    );
  }

}
class StoryRow extends StatelessWidget {
  final int length;

  const StoryRow({
    super.key,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        return StoryItem(
          borderColor: StoryColorGenerator.getColor(index),
        );
      },
    );
  }
}
class StoryItem extends StatelessWidget {
  final Color borderColor;

  const StoryItem({
    super.key,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: borderColor,
        
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(1),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black, // placeholder
        ),
      ),
    );
  }

}class StoryColorGenerator {
  static Color getColor(int index) {
    final group = index ~/ 1;   // her 10 kişi aynı aile
    final inner = index % 1;    // aile içi varyasyon

    // 🔥 Hue: her grup 40 derece kayıyor
    final double hue = (270 + (group * 40)) % 360;

    // 🔥 Saturation & brightness küçük farklar
    final double saturation = 0.75 + (inner * 0.015); // 0.75 → 0.9
    final double value = 0.85; // neon parlaklık

    return HSVColor.fromAHSV(
      1.0,
      hue,
      saturation.clamp(0.7, 1.0),
      value,
    ).toColor();
  }
}
