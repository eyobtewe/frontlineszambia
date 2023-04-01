///
/// Class for creating custom colors
/// This is a port of: https://github.com/lzyzsd/AndroidRandomColor to dart
///
/// Some things are changed/added to better fit in the game
///

part of random_color;

///
/// Generate random colors that are visually appealing
///
class RandomColor {
  /// Constructor for random generator
  /// [seed] Random seed to use for generating colors
  RandomColor([int? seed]) {
    if (seed != null) {
      _random = Random(seed);
    } else {
      _random = Random();
    }
  }

  bool debug = false;

  final int minBrightness = 16;
  final int maxBrightness = 84;
  late Random _random;

  ///
  /// Get random color
  ///
  /// Optional arguments:
  /// [colorHue] Random color hue [Range] to use
  /// [colorSaturation] Random color saturation [Range]
  /// [colorBrightness] Random color brightness [Range]
  /// [debug] debug color creation. defaults to false
  ///
  Color randomColor({
    ColorHue colorHue = ColorHue.random,
    ColorSaturation colorSaturation = ColorSaturation.random,
    ColorBrightness colorBrightness = ColorBrightness.random,
    bool debug = false,
  }) {
    this.debug = debug;

    int s;
    int h;
    int b;

    h = colorHue.returnHue(_random);
    s = colorSaturation.returnSaturation(_random);
    b = colorBrightness.returnBrightness(_random);

    _log('Color hue: $h');
    _log('Color saturation: $s');
    _log('Color brightness: $b');

    return _getColor(h, s, b);
  }

  MaterialColor randomMaterialColor({
    ColorHue colorHue = ColorHue.random,
    ColorSaturation colorSaturation = ColorSaturation.random,
    bool debug = false,
  }) {
    int saturation;
    int hue;
    int brightness;

    hue = colorHue.returnHue(_random);
    saturation = colorSaturation.returnSaturation(_random);
    brightness =
        const ColorBrightness.custom(Range(45, 55)).returnBrightness(_random);

    /// Middle color
    final baseColor = _getColor(hue, saturation, brightness);

    Color getLighterColor(int lighterShade) {
      return _getColor(hue, saturation, brightness + (lighterShade * 5));
    }

    Color getDarkerColor(int darkerShade) {
      return _getColor(hue, saturation, brightness - (darkerShade * 5));
    }

    final finishedColor = MaterialColor(baseColor.value, <int, Color>{
      50: getLighterColor(5),
      100: getLighterColor(4),
      200: getLighterColor(3),
      300: getLighterColor(2),
      400: getLighterColor(1),
      500: baseColor,
      600: getDarkerColor(1),
      700: getDarkerColor(2),
      800: getDarkerColor(3),
      900: getDarkerColor(4),
    });

    return finishedColor;
  }

  /// Get list of random colors
  /// Calls [randomColor] for [count] number of times.
  /// [count] Number of colors
  List<Color> randomColors({
    required int count,
    ColorHue colorHue = ColorHue.random,
    ColorSaturation colorSaturation = ColorSaturation.random,
    ColorBrightness colorBrightness = ColorBrightness.random,
    bool debug = false,
  }) {
    final colors = <Color>[];

    for (var i = 0; i < count; i++) {
      colors.add(randomColor(
        colorHue: colorHue,
        colorSaturation: colorSaturation,
        colorBrightness: colorBrightness,
        debug: debug,
      ));
    }

    return colors;
  }

  /// Need to get RGB from hsv values and make new color from them.
  /// Ported to dart from: https://stackoverflow.com/a/25964657/3700909
  Color _getColor(int hue, int saturation, int brightness) {
    final s = saturation / 100;
    final v = brightness / 100;

    final color = HSLColor.fromAHSL(1.0, hue.toDouble(), s, v).toColor();

    return color;
  }

  void _log(String s) {
    if (debug) {
      debugPrint('Random color: $s');
    }
  }
}
