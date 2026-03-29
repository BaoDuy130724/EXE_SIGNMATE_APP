class SignModel {
  final String id;
  final String word;
  final String videoUrl;
  final String thumbnailUrl;
  final String description;
  final int orderIndex;
  final String referenceKeypointData;

  SignModel({
    required this.id,
    required this.word,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.description,
    required this.orderIndex,
    required this.referenceKeypointData,
  });

  factory SignModel.fromJson(Map<String, dynamic> json) {
    return SignModel(
      id: json['id']?.toString() ?? '',
      word: json['word'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      description: json['description'] ?? '',
      orderIndex: json['orderIndex'] ?? 0,
      referenceKeypointData: json['referenceKeypointData'] ?? '[]',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'orderIndex': orderIndex,
      'referenceKeypointData': referenceKeypointData,
    };
  }
}
