import 'package:json_annotation/json_annotation.dart';

part 'playlist_model.g.dart';

@JsonSerializable()
class PlaylistModel {
  final String? id;
  final String? name;

  PlaylistModel({
    this.id,
    this.name,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);

  @override
  String toString() {
    return 'PlaylistModel{id: $id, name: $name}';
  }
}
