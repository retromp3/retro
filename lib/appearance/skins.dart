import 'package:retro/blocs/theme/theme.dart';

String gen7SilverSkin = "assets/skins/gen7_silver.png";
String gen7BlackSkin = "assets/skins/gen7_black.png";
String customBeigeSkin = "assets/skins/custom_beige.png";

String getSkin(ThemeState state) {
  switch (state.skinTheme) {
    case SkinTheme.black:
      return gen7BlackSkin;
    case SkinTheme.silver:
      return gen7SilverSkin;
    case SkinTheme.beige:
      return customBeigeSkin;
    default:
      return gen7BlackSkin;
  }
}
