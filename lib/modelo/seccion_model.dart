import 'dart:convert';

SeccionModel seccionModelFromJson(String str) => SeccionModel.fromJson(json.decode(str));//ejecuta la funcion.fromjson

String seccionModelToJson(SeccionModel data) => json.encode(data.toJson());// ejecuta la funcion to.json

class SeccionModel {

  int     id;
  String  nombre;

  SeccionModel ({
    this.id,
    this.nombre  = '',
  });

    factory SeccionModel.fromJson(Map<String, dynamic> json) => new SeccionModel(  // es una funcion que llamaremos cuando queremos generar una instancia de Seccion que viene de un mapa en formato json
      id       : json["Id"],
      nombre   : json["Nombre"],
    );

    Map<String, dynamic> toJson() => { //empareja los datos con los valores de las variables
      "Id"       : id,
      "Nombre"   : nombre,
    };

}