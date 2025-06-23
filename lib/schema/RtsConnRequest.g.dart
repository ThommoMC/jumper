//GENERATED CODE - DO NOT MODIFY
//CREATED FROM jumper|lib/schema/RtsConnRequest.yaml
import "dart:typed_data";
class v1 {
final int publicKey;
v1(
this.publicKey, );
factory v1.fromBytes(Uint8List bytes) {
final byteViewer = ByteData.sublistView(bytes);
final publicKey = byteViewer.getUint8(0);
return v1(
publicKey, );}
}
