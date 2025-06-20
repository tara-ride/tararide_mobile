import 'dart:convert';

class ChatInteractionData {
  List<ChatInteraction> chatInteraction;
  String rideId;
  String driverId;
  DateTime chatCreatedOn;
  String passengerId;
  String chatId;

  ChatInteractionData({
    required this.chatInteraction,
    required this.rideId,
    required this.driverId,
    required this.chatCreatedOn,
    required this.passengerId,
    required this.chatId,
  });

  factory ChatInteractionData.fromRawJson(String str) => ChatInteractionData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatInteractionData.fromJson(Map<String, dynamic> json) => ChatInteractionData(
        chatInteraction: List<ChatInteraction>.from(json["chat_interaction"].map((x) => ChatInteraction.fromJson(x))),
        rideId: json["ride_id"],
        driverId: json["driver_id"],
        chatCreatedOn: DateTime.parse(json["chat_created_on"].toDate().toString()),
        passengerId: json["passenger_id"],
        chatId: json["chat_id"],
      );

  Map<String, dynamic> toJson() => {
        "chat_interaction": List<dynamic>.from(chatInteraction.map((x) => x.toJson())),
        "ride_id": rideId,
        "driver_id": driverId,
        "chat_created_on": chatCreatedOn.toIso8601String(),
        "passenger_id": passengerId,
        "chat_id": chatId,
      };
}

class ChatInteraction {
  String messageText;
  String messagedBy;
  DateTime messagedOn;

  ChatInteraction({
    required this.messageText,
    required this.messagedBy,
    required this.messagedOn,
  });

  factory ChatInteraction.fromRawJson(String str) => ChatInteraction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatInteraction.fromJson(Map<String, dynamic> json) => ChatInteraction(
        messageText: json["message_text"],
        messagedBy: json["messaged_by"],
        messagedOn: DateTime.parse(json["messaged_on"].toDate().toString()),
      );

  Map<String, dynamic> toJson() => {
        "message_text": messageText,
        "messaged_by": messagedBy,
        "messaged_on": messagedOn.toIso8601String(),
      };
}
