import 'dart:ui';

import 'package:flutter/material.dart';

import 'models/wallpaper.dart';

void main() {
  runApp(const ArtisanAiApp());
}

/// ARTISANAI — "Aurora Glass Gallery" UI (Phase 0.5).
///
/// Research, Nov 2026 — what the best wallpaper apps do, and what the
/// 2025-26 design trends say:
///   * Backdrops / Walli / Abstruct: design-first, one hero "Wall of the
///     Day", full-bleed art, clean minimal chrome — the art is the UI.
///   * Glassmorphism / Liquid Glass: frosted blur panels floating over
///     vivid art, thin light borders, layered depth.
///   * Aurora / mesh gradients: organic teal + gold glows instead of a
///     flat background colour.
///   * Bento grids: mixed-size tiles (one wide landscape + tall portraits)
///     instead of identical stacked cards.
///   * Material 3 Expressive: pillowy rounded shapes, bold gold accent,
///     purposeful micro-animation (press scale, fade/slide-in).
///   * Adaptive dark mode: deep teal-charcoal, never pure black.
///
/// This file uses only the Flutter SDK (dart:ui blur, no new packages).
class ArtisanAiApp extends StatelessWidget {
  const ArtisanAiApp({super.key});

  // --- Design tokens ---
  static const Color tealDeep = Color(0xFF04191E); // near-black teal
  static const Color tealMid = Color(0xFF0D4A52);
  static const Color tealSoft = Color(0xFF105A64);
  static const Color tealGlow = Color(0xFF1E8A8A);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldSoft = Color(0xFFF0CD6E);
  static const Color goldDeep = Color(0xFF9A7B1E);
  static const Color ink = Color(0xFFF2F4F4);
  static const Color muted = Color(0xFFA8C4C4);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldSoft, gold, goldDeep],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARTISANAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: tealDeep,
        colorScheme: const ColorScheme.dark(
          primary: gold,
          secondary: goldSoft,
          surface: tealMid,
          onSurface: ink,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

/// Aurora mesh background: three soft glowing blobs over deep teal.
class AuroraBackground extends StatelessWidget {
  const AuroraBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF04191E), Color(0xFF072A30), Color(0xFF04191E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        const Positioned(
          top: -80,
          right: -60,
          child: _GlowBlob(size: 260, color: ArtisanAiApp.tealGlow),
        ),
        const Positioned(
          top: 220,
          left: -90,
          child: _GlowBlob(size: 220, color: ArtisanAiApp.gold, opacity: 0.20),
        ),
        const Positioned(
          bottom: -40,
          right: 40,
          child: _GlowBlob(size: 200, color: ArtisanAiApp.tealSoft),
        ),
        child,
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.color, this.opacity = 0.35});

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(opacity),
        ),
      ),
    );
  }
}

/// Frosted glass panel (Liquid Glass style): blur + translucent fill +
/// thin light border.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 24,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.22),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Press-scale micro-animation: card shrinks to 0.97 while pressed.
class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1),
      onTapCancel: () => setState(() => _scale = 1),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  int _category = 0;

  static const List<String> _categories = [
    'For you',
    'Nature',
    'Anime',
    'Abstract',
    'Live',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: _tab == 0
              ? TodaysDropScreen(
                  category: _category,
                  onCategory: (i) => setState(() => _category = i),
                  categories: _categories,
                )
              : _tab == 1
                  ? const BrowseScreen()
                  : const FavouritesScreen(),
        ),
      ),
      // Floating glass bottom nav.
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: GlassPanel(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          borderRadius: 28,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.auto_awesome,
                label: 'Today',
                active: _tab == 0,
                onTap: () => setState(() => _tab = 0),
              ),
              _NavItem(
                icon: Icons.grid_view_rounded,
                label: 'Browse',
                active: _tab == 1,
                onTap: () => setState(() => _tab = 1),
              ),
              _NavItem(
                icon: Icons.favorite_rounded,
                label: 'Saved',
                active: _tab == 2,
                onTap: () => setState(() => _tab = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: active ? ArtisanAiApp.goldGradient : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? Colors.black : ArtisanAiApp.muted,
            ),
            if (active) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Today's Drop — hero + bento grid. Phase 0: bundled placeholders only.
class TodaysDropScreen extends StatelessWidget {
  const TodaysDropScreen({
    super.key,
    required this.category,
    required this.onCategory,
    required this.categories,
  });

  final int category;
  final ValueChanged<int> onCategory;
  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    final hero = todaysDrop[2]; // live portrait — the hero
    final rest = [todaysDrop[0], todaysDrop[1]];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
      children: [
        // Header: greeting + gold wordmark, no flat AppBar.
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning',
                  style: TextStyle(
                    color: ArtisanAiApp.goldSoft,
                    fontSize: 13,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'ARTISANAI',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: ArtisanAiApp.ink,
                  ),
                ),
              ],
            ),
            GlassPanel(
              padding: EdgeInsets.all(10),
              borderRadius: 20,
              child: Icon(
                Icons.notifications_outlined,
                color: ArtisanAiApp.ink,
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Glass search pill.
        const GlassPanel(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          borderRadius: 20,
          child: Row(
            children: [
              Icon(Icons.search, color: ArtisanAiApp.muted, size: 20),
              SizedBox(width: 10),
              Text(
                'Search wallpapers, moods, colours…',
                style: TextStyle(color: ArtisanAiApp.muted, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Hero: Wall of the Day, full-bleed art + glass info panel.
        _FadeIn(
          child: PressScale(
            onTap: () => _showComingSoon(context, hero),
            child: _HeroCard(wallpaper: hero),
          ),
        ),
        const SizedBox(height: 20),
        // Category chips — glass pills, gold when selected.
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final selected = i == category;
              return GestureDetector(
                onTap: () => onCategory(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient:
                        selected ? ArtisanAiApp.goldGradient : null,
                    color: selected
                        ? null
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(19),
                    border: selected
                        ? null
                        : Border.all(
                            color: Colors.white.withOpacity(0.18),
                          ),
                  ),
                  child: Text(
                    categories[i],
                    style: TextStyle(
                      color: selected ? Colors.black : ArtisanAiApp.ink,
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Drop",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '05:30 IST  •  Daily',
              style: TextStyle(color: ArtisanAiApp.muted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Bento grid: wide landscape tile + tall portrait tile.
        _FadeIn(
          delay: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _BentoTile(wallpaper: rest[0], height: 190),
                    const SizedBox(height: 12),
                    _BentoTile(wallpaper: rest[1], height: 240),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Phase 0 — placeholder art only. Real daily drops arrive with the Phase 2 pipeline.',
          style: TextStyle(color: ArtisanAiApp.muted, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  static void _showComingSoon(BuildContext context, Wallpaper w) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${w.title} — Apply & Download, coming in Phase 1.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ArtisanAiApp.tealMid,
      ),
    );
  }
}

/// Hero card: tall portrait art, gradient scrim, glass panel at bottom,
/// pulsing LIVE badge, gold gradient Apply button.
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.wallpaper});

  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: ArtisanAiApp.gold.withOpacity(0.12),
            blurRadius: 32,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (wallpaper.assetPath != null)
              Image.asset(wallpaper.assetPath!, fit: BoxFit.cover)
            else
              Container(color: ArtisanAiApp.tealSoft),
            // Gradient scrim so text stays readable over any art.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.transparent, Color(0xCC04191E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.4, 0.65, 1.0],
                ),
              ),
            ),
            // LIVE badge — top left, pulsing gold dot.
            Positioned(
              top: 14,
              left: 14,
              child: GlassPanel(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                borderRadius: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PulsingDot(),
                    const SizedBox(width: 7),
                    Text(
                      wallpaper.isLive
                          ? 'LIVE  •  ${wallpaper.motionType ?? 'minor motion'}'
                          : 'WALL OF THE DAY',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Favourite heart — top right glass circle.
            const Positioned(
              top: 14,
              right: 14,
              child: GlassPanel(
                padding: EdgeInsets.all(9),
                borderRadius: 20,
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            // Glass info panel at the bottom.
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: GlassPanel(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            wallpaper.title,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${wallpaper.category}  •  Portrait  •  4K',
                            style: const TextStyle(
                              color: ArtisanAiApp.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: ArtisanAiApp.goldGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: ArtisanAiApp.gold.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
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
    );
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(_c),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ArtisanAiApp.gold,
        ),
      ),
    );
  }
}

/// Bento tile: image + gradient scrim + glass label chip.
class _BentoTile extends StatelessWidget {
  const _BentoTile({required this.wallpaper, required this.height});

  final Wallpaper wallpaper;
  final double height;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: () => TodaysDropScreen._showComingSoon(context, wallpaper),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (wallpaper.assetPath != null)
                Image.asset(wallpaper.assetPath!, fit: BoxFit.cover)
              else
                Container(color: ArtisanAiApp.tealSoft),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xB304191E)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      wallpaper.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${wallpaper.category}  •  '
                      '${wallpaper.isLandscape ? 'Landscape' : 'Portrait'}',
                      style: const TextStyle(
                        color: ArtisanAiApp.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fade + slide-in on first build.
class _FadeIn extends StatefulWidget {
  const _FadeIn({required this.child, this.delay = 0});

  final Widget child;
  final int delay;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    Future.delayed(
      Duration(milliseconds: widget.delay),
      () => mounted ? _c.forward() : null,
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut)),
        child: widget.child,
      ),
    );
  }
}

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
      children: const [
        Text(
          'Browse',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 8),
        Text(
          'Categories, search and tags — coming in Phase 1.',
          style: TextStyle(color: ArtisanAiApp.muted),
        ),
      ],
    );
  }
}

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
      children: const [
        Text(
          'Saved',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 8),
        Text(
          'Favourites stay on this device — coming in Phase 1.',
          style: TextStyle(color: ArtisanAiApp.muted),
        ),
      ],
    );
  }
}
