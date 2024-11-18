class Call {
  String toId;
  String fromId;
  String callId;
  String callType; // 'video' or 'audio'
  String callStatus; // 'initiated', 'accepted', 'ended'
  String startedAt;

  Call({
    required this.toId,
    required this.fromId,
    required this.callId,
    required this.callType,
    required this.callStatus,
    required this.startedAt,
  });

  // Convert Call to JSON format for Firestore
  Map<String, dynamic> toJson() {
    return {
      'toId': toId,
      'fromId': fromId,
      'callId': callId,
      'callType': callType,
      'callStatus': callStatus,
      'startedAt': startedAt,
    };
  }
}
