import 'dart:developer';
import 'dart:mirrors';

abstract class Decodable {
  Decodable.decode(Map<String, dynamic> json) {
    try {
      var mirror = reflect(this);

      json.forEach((key, value) {
        final Symbol sKey = Symbol(key);
        final bool isKeyExist = mirror.type.declarations.containsKey(sKey);
        if (!isKeyExist) {
          throw "json key '$key' not matched with declarations in $this class";
        }

        VariableMirror field =
            mirror.type.declarations[Symbol(key)] as VariableMirror;

        if (field.type.simpleName == Symbol("List")) {
          ClassMirror listGeneric =
              field.type.typeArguments.first as ClassMirror;

          final list = _listTypeGenerator(field);
          // log("list type ${list.runtimeType}");
          final itemsInJson = value as List<Map<String, dynamic>>;
          itemsInJson.forEach((element) {
            final item =
                listGeneric.newInstance(Symbol("decode"), [element]).reflectee;
            list.add(item);
          });
          mirror.setField(Symbol(key), list);
        } else if (field.type
            .isSubtypeOf(mirror.type.superclass as TypeMirror)) {
          ClassMirror fieldType = mirror
              .type.instanceMembers[Symbol(key)]?.returnType as ClassMirror;
          mirror.setField(Symbol(key),
              fieldType.newInstance(Symbol("decode"), [value]).reflectee);
        } else {
          mirror.setField(sKey, value);
        }
      });
    } catch (e) {
      log("error parsing : $e");
    }
  }

  List _listTypeGenerator(VariableMirror field) {
    final generic = reflect(field.type.typeArguments.first as ClassMirror)
        .reflectee as ClassMirror;
    final listType = reflectType(List, [generic.reflectedType]) as ClassMirror;
    final listInstance = listType.newInstance(Symbol.empty, []).reflectee;
    // log("instance ${listInstance.runtimeType}");
    return listInstance;
  }
}
