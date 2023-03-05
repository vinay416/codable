import 'dart:developer';
import 'dart:mirrors';

abstract class Encodable {
  Map<String, dynamic> encode() {
    try {
      InstanceMirror mirror = reflect(this);
      Map<String, dynamic> encoded = Map<String, dynamic>();

      for (var v in mirror.type.declarations.values) {
        var name = MirrorSystem.getName(v.simpleName);

        if (v is VariableMirror && !v.isPrivate) {
          if (v.type.simpleName == Symbol("List")) {
            final List<Map<String, dynamic>> listMap = [];
            final list = mirror.getField(v.simpleName).reflectee as List;
            list.forEach((element) {
              final mirror = reflect(element);
              final encoded = mirror.invoke(Symbol("encode"), []).reflectee
                  as Map<String, dynamic>;
              listMap.add(encoded);
            });
            encoded[name] = listMap;
            // log(listMap);
          } else if (v.type.isSubtypeOf(mirror.type.superclass as TypeMirror)) {
            encoded[name] = mirror
                .getField(Symbol(name))
                .invoke(Symbol("encode"), []).reflectee;
          } else {
            encoded[name] = mirror.getField(Symbol(name)).reflectee;
          }
        }
      }
      return encoded;
    } catch (e) {
      log("Error to json : $e");
      return {};
    }
  }
}
