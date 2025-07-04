import 'package:flutter/services.dart';
import 'package:jumper/bluetooth/rtsHandler.dart';

const maxMessageSize = 19;

// stuff 
int getBit(int value, int n) {
  return (value >> n) & 1;
}

class FragmentedMessage {
  final List<List<int>> message;

  FragmentedMessage(this.message);

  factory FragmentedMessage.fromMessage(List<int> message) {
    
    final List<List<int>> messageChunks = [[0]];

    final int chunksNeeded = (message.length / maxMessageSize).toInt();

    for (var chunkPosition = 0; chunkPosition < chunksNeeded; chunkPosition++) {
      if (chunksNeeded == 1) {
        messageChunks[0][0];
      }
    }

    return FragmentedMessage(messageChunks);

  }
}

class ReassmembledMessage {
  List<int> message;
  bool finished;
  final int cladID;

  ReassmembledMessage(this.message, this.finished, this.cladID);

  factory ReassmembledMessage.fromMessages(List<int> message) {
    final isEnd = getBit(message[0], 6) == 1 ? true : false;

    var messageCopy = List<int>.from(message, growable: true);

    messageCopy.removeAt(0);


    if (getVer(message) == 1) {
      messageCopy.removeAt(0);
      messageCopy.removeAt(0);
    } else {messageCopy.removeAt(0); messageCopy.removeAt(0); messageCopy.removeAt(0);}

    return ReassmembledMessage(messageCopy, isEnd, getTag(message));
  }

  bool addMessage(List<int> message) {
    var messageCopy = List<int>.from(message, growable: true);
    if (finished) {return false;}

    finished = getBit(message[0], 6) == 1 ? true : false;
    messageCopy.removeAt(0);

    this.message.addAll(messageCopy);
    return true;
  }

}