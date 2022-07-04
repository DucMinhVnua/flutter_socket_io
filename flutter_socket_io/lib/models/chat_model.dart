class ChatModel {
  final String message;
  final bool user;
  final bool source;

  ChatModel({required this.message, required this.user, this.source = false});
}
