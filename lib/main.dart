import 'package:flutter/material.dart';

import 'models/wallpaper.dart';

void main() {
  runApp(const ArtisanAiApp());
}

/// ARTISANAI — Phase 0 skeleton.
/// Dark design system: deep teal-blue + warm gold (cloudyx_art /
/// cinematic teal-and-gold art direction from the plan).
class ArtisanAiApp extends StatelessWidget {
  const ArtisanAiApp({super.key});

  // --- Design tokens (single source of truth for Phase 0) ---
  static const Color tealDeep = Color(0xFF072A30); // app background
  static const Color tealMid = Color(0xFF0D4A52); // cards / surfaces
  static const Color tealSoft = Color(0xFF105A64); // selected / accents
  static const Color gold = Color(0xFFD4AF37); // primary accent
  static const Color goldSoft = Color(0xFFF0CD6E); // gold highlights
  static const Color ink = Color(0xFFF2F4F4); // primary text
  static const Color muted = Color(0xFF9DB8B8); // secondary text

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
        appBarTheme: const AppBarTheme(
          backgroundColor: tealDeep,
          foregroundColor: ink,
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: tealMid,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: tealDeep,
          selectedItemColor: gold,
          unselectedItemColor: muted,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gold,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      home: const HomeScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ARTISANAI',
          style: TextStyle(
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            color: ArtisanAiApp.gold,
          ),
        ),
      ),
      body: _tab == 0
          ? const TodaysDropScreen()
          : _tab == 1
              ? const PlaceholderScreen(
                  title: 'Browse',
                  subtitle: 'Categories, search and tags — coming in Phase 1.',
                )
              : const PlaceholderScreen(
                  title: 'Favourites',
                  subtitle:
                      'Favourites stay on this device — coming in Phase 1.',
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourites'),
        ],
      ),
    );
  }
}

/// Today's Drop — the home screen. Phase 0: bundled placeholders only.
class TodaysDropScreen extends StatelessWidget {
  const TodaysDropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Today's Drop",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Fresh AI wallpapers every morning — 05:30 IST.',
          style: TextStyle(color: ArtisanAiApp.muted),
        ),
        const SizedBox(height: 16),
        for (final w in todaysDrop) ...[
          WallpaperCard(wallpaper: w),
          const SizedBox(height: 16),
        ],
        const Text(
          'Phase 0 — placeholder art only. Real daily drops arrive with the Phase 2 pipeline.',
          style: TextStyle(color: ArtisanAiApp.muted, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class WallpaperCard extends StatelessWidget {
  const WallpaperCard({super.key, required this.wallpaper});

  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: wallpaper.isLandscape ? 16 / 9 : 9 / 16,
            child: wallpaper.assetPath != null
                ? Image.asset(wallpaper.assetPath!, fit: BoxFit.cover)
                : Container(color: ArtisanAiApp.tealSoft),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wallpaper.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${wallpaper.category} • '
                        '${wallpaper.isLandscape ? 'Landscape' : 'Portrait'}'
                        '${wallpaper.isLive ? ' • LIVE — ${wallpaper.motionType ?? 'minor motion'}' : ''}',
                        style: const TextStyle(
                          color: ArtisanAiApp.muted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Apply & Download — coming in Phase 1.',
                        ),
                      ),
                    );
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image, size: 56, color: ArtisanAiApp.gold),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: ArtisanAiApp.muted),
            ),
          ],
        ),
      ),
    );
  }
}
