import 'package:equatable/equatable.dart';

class TrackAudioFeaturesModel extends Equatable {
  final String trackId;
  final double danceability;
  final double energy;
  final double valence;
  final double tempo;

  const TrackAudioFeaturesModel(
      {required this.trackId,
      required this.danceability,
      required this.energy,
      required this.valence,
      required this.tempo});

  factory TrackAudioFeaturesModel.fromJson(Map<String, dynamic> json) {
    return TrackAudioFeaturesModel(
        trackId: json['id'],
        danceability: json['danceability'],
        energy: json['energy'],
        valence: json['valence'],
        tempo: json['tempo']);
  }

  @override
  List<Object?> get props => [
        trackId,
        danceability,
        energy,
        valence,
        tempo,
      ];
}
