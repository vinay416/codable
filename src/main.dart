
import 'codable/codable.dart';

void main() {
  final user = User.decode({
    "id": 5,
    "name": "vinay",
    "check": {"proof": "verified", "id": 6},
    "values": [
      {
        "value": 45,
        "id": 0,
        "check": {"proof": "verified", "id": 6},
      },
      {
        "value": 90,
        "id": 1,
        "check": {"proof": "verified", "id": 6}
      }
    ]
  });

  print("// from Json :");
  print(user.name);
  print(user.id);
  print(user.check.proof);
  print(user.check.id);
  print("// to Json :");
  print(user.encode());
}

class User extends Codable {
  late int id;
  late String name;
  late Proof check;
  List<Items> values = [];

  User.decode(super.json) : super.decode();
}

class Items extends Codable {
  late int value;
  late int id;
  late Proof check;

  Items.decode(super.json) : super.decode();
}

class Proof extends Codable {
  late String proof;
  late int id;

  Proof.decode(super.json) : super.decode();
}
