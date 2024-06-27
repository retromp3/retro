import 'package:retro/blocs/theme/theme.dart';

String gen7SilverSkin = "assets/skins/gen7_silver.png";
String gen7BlackSkin = "assets/skins/gen7_black.png";
String customBeigeSkin = "assets/skins/custom_beige.png";
String baySkin = "assets/skins/pixel_bay.png";
String pinkSkin = "assets/skins/iphone_pink.png";
String orangeSkin = "assets/skins/rabbit_orange.png";
String coralSkin = "assets/skins/pixel_coral.png";
String arcPinkSkin = "assets/skins/arc_pink.png";
String red3dsSkin = "assets/skins/3ds_red.png";
String catFrapSkin = "assets/skins/catppuccin_frappe.png";
String catLattSkin = "assets/skins/catppuccin_latte.png";
String catMaccSkin = "assets/skins/catppuccin_macchiato.png";
String catMochaSkin = "assets/skins/catppuccin_mocha.png";
String comfySkin = "assets/skins/comfy.png";
String iphGreeSkin = "assets/skins/iphone_green.png";
String iphYellSkin = "assets/skins/iphone_yellow.png";
String nordSkin = "assets/skins/nord.png";
String mintSkin = "assets/skins/pixel_mint.png";
String yellowSkin = "assets/skins/switch_yellow.png";
String oledBlackSkin = "assets/skins/oled_black.png";
String teenSkin = "assets/skins/teenage_inspired.png";

String getSkin(ThemeState state) {
  switch (state.skinTheme) {
    case SkinTheme.black:
      return gen7BlackSkin;
    case SkinTheme.silver:
      return gen7SilverSkin;
    case SkinTheme.beige:
      return customBeigeSkin;
    case SkinTheme.bay:
      return baySkin;
    case SkinTheme.pink:
      return pinkSkin;
    case SkinTheme.orange:
      return orangeSkin;
    case SkinTheme.coral:
      return coralSkin;
    case SkinTheme.arcPink:
      return arcPinkSkin;
    case SkinTheme.red3ds:
      return red3dsSkin;
    case SkinTheme.catFrap:
      return catFrapSkin;
    case SkinTheme.catLatt:
      return catLattSkin;
    case SkinTheme.catMacc:
      return catMaccSkin;
    case SkinTheme.catMocha:
      return catMochaSkin;
    case SkinTheme.comfy:
      return comfySkin;
    case SkinTheme.iphGree:
      return iphGreeSkin;
    case SkinTheme.iphYell:
      return iphYellSkin;
    case SkinTheme.nord:
      return nordSkin;
    case SkinTheme.mint:
      return mintSkin;
    case SkinTheme.yellow:
      return yellowSkin;
    case SkinTheme.oledBlack:
      return oledBlackSkin;
    case SkinTheme.teen:
      return teenSkin;
    default:
      return gen7BlackSkin;
  }
}