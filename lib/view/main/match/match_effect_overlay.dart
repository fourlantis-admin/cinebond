import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  MATCH EFFECT OVERLAY
//  Kullanım: MatchEffectOverlay(item: profile, onDismiss: ...)
//
//  Servis entegrasyonu için:
//  → onSendMessage callback'i ileride MatchService.openChat(item) ile bağla.
//  → onDismiss içinde SwipeCubit.dismissMatchEffect() çağrılır (match_view.dart).
// ─────────────────────────────────────────────────────────────────────────────

class MatchEffectOverlay<T> extends StatefulWidget {
  const MatchEffectOverlay({
    super.key,
    required this.item,
    required this.onDismiss,
    required this.getName,
    this.getAvatarWidget,
    // İleride: required this.onSendMessage,
  });

  final T item;
  final VoidCallback onDismiss;
  final String Function(T) getName;
  final Widget Function(T)? getAvatarWidget;

  @override
  State<MatchEffectOverlay<T>> createState() => _MatchEffectOverlayState<T>();
}

class _MatchEffectOverlayState<T> extends State<MatchEffectOverlay<T>>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _contentCtrl;
  late final AnimationController ParticleCtrl;

  late final Animation<double> _bgFade;
  late final Animation<double> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _avatarScale;
  late final Animation<double> _buttonFade;

  final List<Particle> Particles = [];

  @override
  void initState() {
    super.initState();

    // Partiküller
    final rng = Random();
    for (int i = 0; i < 28; i++) {
      Particles.add(Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble() * 0.6,
        size: rng.nextDouble() * 7 + 3,
        color: [
          const Color(0xFFFF4B6E),
          const Color(0xFFFF8C42),
          const Color(0xFF2979FF),
          const Color(0xFFFFD740),
          const Color(0xFF00E676),
          Colors.white,
        ][rng.nextInt(6)],
        speed: rng.nextDouble() * 0.4 + 0.2,
        angle: rng.nextDouble() * 2 * pi,
      ));
    }

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    ParticleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _bgFade = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeOut);
    _titleSlide = Tween<double>(begin: -40, end: 0).animate(
      CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutQuart),
    );
    _titleFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);
    _avatarScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _contentCtrl, curve: Curves.elasticOut),
    );
    _buttonFade = CurvedAnimation(
      parent: _contentCtrl,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _bgCtrl.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _contentCtrl.forward();
        ParticleCtrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _contentCtrl.dispose();
    ParticleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FadeTransition(
      opacity: _bgFade,
      child: Stack(
        children: [
          // ── Arka plan ──────────────────────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A0A2E),
                    const Color(0xFF0D0D1A),
                  ],
                ),
              ),
            ),
          ),

          // ── Partiküller ────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: ParticleCtrl,
              builder: (_, __) => CustomPaint(
                painter: ParticlePainter(
                  particles: Particles,
                  progress: ParticleCtrl.value,
                ),
              ),
            ),
          ),

          // ── İçerik ────────────────────────────
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Başlık
                AnimatedBuilder(
                  animation: _contentCtrl,
                  builder: (_, __) => Opacity(
                    opacity: _titleFade.value,
                    child: Transform.translate(
                      offset: Offset(0, _titleSlide.value),
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                const LinearGradient(
                              colors: [
                                Color(0xFFFF4B6E),
                                Color(0xFFFF8C42),
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              "IT'S A MATCH!",
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.getName(widget.item)} ile eşleştin',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Avatar
                AnimatedBuilder(
                  animation: _contentCtrl,
                  builder: (_, child) => Transform.scale(
                    scale: _avatarScale.value,
                    child: child,
                  ),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFF4B6E),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4B6E).withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: widget.getAvatarWidget != null
                          ? widget.getAvatarWidget!(widget.item)
                          : ColoredBox(
                              color: const Color(0xFF2A2A3A),
                              child: const Icon(
                                Icons.person,
                                size: 64,
                                color: Colors.white38,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Butonlar
                FadeTransition(
                  opacity: _buttonFade,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        // Mesaj gönder — ileride MatchService.openChat() bağlanacak
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: MatchService.openChat(widget.item)
                              widget.onDismiss();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF4B6E),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Mesaj Gönder',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: widget.onDismiss,
                          child: Text(
                            'Daha Sonra',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PARTİKÜL SİSTEMİ
// ─────────────────────────────────────────────

class Particle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double speed;
  final double angle;

  const Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.angle,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  const ParticlePainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress * p.speed).clamp(0.0, 1.0);
      final fade = (1.0 - t * 1.4).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = p.color.withOpacity(fade * 0.9)
        ..style = PaintingStyle.fill;

      final dx = p.x * size.width + cos(p.angle) * t * size.width * 0.4;
      final dy = p.y * size.height + t * size.height * 0.3 * p.speed;

      canvas.drawCircle(Offset(dx, dy), p.size * (1 - t * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) => old.progress != progress;
}