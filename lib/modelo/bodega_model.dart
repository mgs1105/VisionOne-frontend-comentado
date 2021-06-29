import 'dart:convert';

BodegaModel bodegaModelFromJson(String str) => BodegaModel.fromJson(json.decode(str)); //ejecuta la funcion.fromjson

String bodegaModelToJson(BodegaModel data) => json.encode(data.toJson()); // ejecuta la funcion to.json

class BodegaModel {

  int id;
  String nombre;


  BodegaModel ({
    this.id,
    this.nombre,
  });

    factory BodegaModel.fromJson(Map<String, dynamic> json) => new BodegaModel( // es una funcion que llamaremos cuando queremos generar una instancia de Producto que viene de un mapa en formato json
      id     : json["Id"],
      nombre : json["Nombre"],
    );

    Map<String, dynamic> toJson() => { //empareja los datos con los valores de las variables
      "Id"     : id,
      "Nombre" : nombre,
    };

}