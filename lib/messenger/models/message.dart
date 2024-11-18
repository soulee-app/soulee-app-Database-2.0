class Message {
  Message(
      {required this.toId,
      required this.msg,
      required this.read,
      required this.type,
      required this.fromId,
      required this.sent,
      this.fileName});

  late final String toId;
  late final String msg;
  late final String read;
  late final String fromId;
  late final String sent;
  late final Type type;
  String? fileName;
  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
    fileName = json['fileName'].toString();

    // Handle multiple message types
    switch (json['type'].toString()) {
      case 'image':
        type = Type.image;
        break;
      case 'voice':
        type = Type.voice;
        break;
      case 'attachment':
        type = Type.attachment; // Handle attachment type
        break;
      case 'audio':
        type = Type.audioCall; // Handle audio call type
        break;
      case 'video':
        type = Type.videoCall; // Handle video call type
        break;
      default:
        type = Type.text; // Default to text if no type matches
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type.name;
    data['fromId'] = fromId;
    data['sent'] = sent;
    data['fileName'] = fileName;
    return data;
  }
}

enum Type { text, image, attachment, voice, audioCall, videoCall }

// ai message
class AiMessage {
  String msg;
  final MessageType msgType;

  AiMessage({required this.msg, required this.msgType});
}

enum MessageType { user, bot }
