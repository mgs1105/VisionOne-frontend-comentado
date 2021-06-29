import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str)); //ejecuta la funcion.fromjson

String productoModelToJson(ProductoModel data) => json.encode(data.toJson()); // ejecuta la funcion to.json

class ProductoModel {

  int     id;
  String  nombre;
  int     arrendador;
  int     servicioliviano;
  int     serviciopesado;
  int     idseccion;
  String  fotoURL;
  int     stockCritico;
  String  nParte;
  int     diferencia;


  ProductoModel ({
    this.id,
    this.nombre  = '',
    this.arrendador,
    this.servicioliviano,
    this.serviciopesado,
    this.idseccion,
    this.fotoURL,
    this.stockCritico,
    this.nParte,
    this.diferencia,
  });

    factory ProductoModel.fromJson(Map<String, dynamic> json) => new ProductoModel( // es una funcion que llamaremos cuando queremos generar una instancia de Producto que viene de un mapa en formato json
      id               : json["Id"],
      nombre           : json["nombre"],
      arrendador       : json["Arrendador"],
      servicioliviano  : json["ServicioLiviano"],
      serviciopesado   : json["ServicioPesado"],
      idseccion        : json["Idseccion"],
      fotoURL          : json["fotoURL"],
      stockCritico     : json["StockCritico"],
      nParte           : json["NParte"]
    );

    factory ProductoModel.jsonBodegaA(Map<String, dynamic> json) => new ProductoModel( // es una funcion que llamaremos cuando queremos generar una instancia de Producto que viene de un mapa en formato json
      id               : json["Id"],
      nombre           : json["nombre"],
      arrendador       : json["Arrendador"],
      stockCritico     : json["StockCritico"],
      nParte           : json["NParte"],
      diferencia       : json["Diferencia"]
    );

    factory ProductoModel.jsonBodegaB(Map<String, dynamic> json) => new ProductoModel( // es una funcion que llamaremos cuando queremos generar una instancia de Producto que viene de un mapa en formato json
      id               : json["Id"],
      nombre           : json["nombre"],
      servicioliviano  : json["ServicioLiviano"],
      stockCritico     : json["StockCritico"],
      nParte           : json["NParte"],
      diferencia       : json["Diferencia"]
    );

    factory ProductoModel.jsonBodegaC(Map<String, dynamic> json) => new ProductoModel( // es una funcion que llamaremos cuando queremos generar una instancia de Producto que viene de un mapa en formato json
      id               : json["Id"],
      nombre           : json["nombre"],
      serviciopesado   : json["ServicioPesado"],
      stockCritico     : json["StockCritico"],
      nParte           : json["NParte"],
      diferencia       : json["Diferencia"]
    );        

    Map<String, dynamic> toJson() => { //empareja los datos con los valores de las variables
      "Id"               : id,
      "nombre"           : nombre,
      "Arrendador"       : arrendador,
      "ServicioLiviano"  : servicioliviano,
      "ServicioPesado"   : serviciopesado,
      "Idseccion"        : idseccion,
      "fotoURL"          : fotoURL,
      "StockCritico"     : stockCritico,
      "NParte"           : nParte,
    };

}