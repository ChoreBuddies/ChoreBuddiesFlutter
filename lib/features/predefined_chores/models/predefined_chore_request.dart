class PredefinedChoreRequest {
  final List<int> predefinedChoreIds;

  PredefinedChoreRequest({required this.predefinedChoreIds});

  Map<String, dynamic> toJson() {
    return {
      'predefinedChoreIds': predefinedChoreIds,
    };
  }
}