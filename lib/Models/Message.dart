class Message {
  final String sender;
  final int type;
  final String text;
  final String imageUrl;
  final DateTime timeStamp;

  Message(
      {required this.sender,
      required this.type,
      required this.text,
      required this.imageUrl,
      required this.timeStamp});
}
