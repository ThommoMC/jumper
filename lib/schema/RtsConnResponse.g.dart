//GENERATED CODE - DO NOT MODIFY
//CREATED FROM jumper|lib/schema/RtsConnResponse.yaml
import "dart:typed_data";
enum RtsConnType {
FirstTimePair,
Reconnection,
}
class v1 {
final  connectionType;
final int publicKey;
v1(
this.connectionType, this.publicKey, );
factory v1.fromBytes(Uint8List bytes) {
final byteViewer = ByteData.sublistView(bytes);
final connectionType = RtsConnType.values[byteViewer.getUint8(0)];
final publicKey = bytes.sublist(1, 33);
return v1(
connectionType, publicKey, );}
}
