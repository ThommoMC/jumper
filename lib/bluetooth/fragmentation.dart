const maxMessageSize = 19;

class FragmentedMessage {
  final List<int> message;

  bool isFinished = false;

  FragmentedMessage(this.message);

  static int getBit(int value, int n) {
    return (value >> n) & 1;
  }

  factory FragmentedMessage.fromMessage(List<int> messageChunk) {

    // First determine if start of new message

    if (getBit(messageChunk[0], 7) != 1) {
      throw "FragmentedMessage.fromMessage: Got chunk that is not start";
    }

    messageChunk.removeAt(0);

    return FragmentedMessage(messageChunk);
  }

}