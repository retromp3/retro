import 'package:json_annotation/json_annotation.dart';

part 'spotify_image_model.g.dart';

@JsonSerializable()
class SpotifyImageModel {
  final String? url;
  final int? height;
  final int? width;

  SpotifyImageModel(this.url, this.height, this.width);

  factory SpotifyImageModel.fromJson(Map<String, dynamic> json) =>
      _$SpotifyImageModelFromJson(json);

  @override
  String toString() {
    return 'SpotifyImageModel{url: $url, height: $height, width: $width}';
  }
}
