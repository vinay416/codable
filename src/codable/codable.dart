import 'decodable.dart';
import 'encodable.dart';

class Codable extends Decodable with Encodable {
  Codable.decode(super.json) : super.decode();
}
