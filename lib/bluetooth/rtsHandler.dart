int getVer(List<int> message) {
  if (message[1] == 1) {
    return 1;
  } else {return message[2];}
}

int getTag(List<int> message) {
  if (getVer(message) == 1) {
    return message[2];
  } else {return message[3];}
}