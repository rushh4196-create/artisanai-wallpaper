/// A single wallpaper drop item.
///
/// Phase 0: local-only model. No network, no accounts.
/// The daily pipeline (Phase 2) will fill these fields from the
/// catalogue; the app only reads them.
enum WallpaperOrientation { landscape, portrait }

class Wallpaper {
  const Wallpaper({
    required this.id,
    required this.date,
    required this.title,
    required this.category,
    required this.orientation,
    required this.isLive,
    this.assetPath,
    this.motionType,
  });

  /// Stable id, e.g. `2026-11-25-landscape`.
  final String id;

  /// Drop date, ISO `YYYY-MM-DD`.
  final String date;
  final String title;
  final String category;
  final WallpaperOrientation orientation;

  /// True for the daily live wallpaper (minor motion).
  final bool isLive;

  /// Bundled placeholder asset in Phase 0; remote URL from Phase 1.
  final String? assetPath;

  /// e.g. `drifting-mist`, `twinkling-stars`, `flowing-water`.
  final String? motionType;

  bool get isLandscape => orientation == WallpaperOrientation.landscape;
  bool get isPortrait => orientation == WallpaperOrientation.portrait;
}

/// Today's Drop — Phase 0 placeholder data.
/// Replaced by the catalogue in Phase 1; the shape stays the same.
const List<Wallpaper> todaysDrop = [
  Wallpaper(
    id: '2026-11-25-landscape',
    date: '2026-11-25',
    title: 'Golden Valley at Dawn',
    category: 'Nature',
    orientation: WallpaperOrientation.landscape,
    isLive: false,
    assetPath: 'assets/placeholders/landscape.jpg',
  ),
  Wallpaper(
    id: '2026-11-25-portrait',
    date: '2026-11-25',
    title: 'Golden Valley — Portrait',
    category: 'Nature',
    orientation: WallpaperOrientation.portrait,
    isLive: false,
    assetPath: 'assets/placeholders/portrait.jpg',
  ),
  Wallpaper(
    id: '2026-11-25-live',
    date: '2026-11-25',
    title: 'Mist Over the Valley',
    category: 'Nature',
    orientation: WallpaperOrientation.portrait,
    isLive: true,
    assetPath: 'assets/placeholders/live.jpg',
    motionType: 'drifting-mist',
  ),
];
