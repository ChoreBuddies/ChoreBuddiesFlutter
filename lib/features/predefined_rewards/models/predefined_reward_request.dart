class PredefinedRewardRequest {
  final List<int> predefinedRewardIds;

  PredefinedRewardRequest({required this.predefinedRewardIds});

  Map<String, dynamic> toJson() {
    return {
      'PredefinedRewardIds': predefinedRewardIds,
    };
  }
}