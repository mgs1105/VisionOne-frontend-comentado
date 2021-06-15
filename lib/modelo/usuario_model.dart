import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) => UsuarioModel.fromJson(json.decode(str));//ejecuta la funcion.fromjson

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());// ejecuta la funcion to.json

class UsuarioModel {

  String  rut;
  String  rol;
  String  password;

  UsuarioModel ({
    this.rut,
    this.rol,
    this.password,
  });

    factory UsuarioModel.fromJson(Map<String, dynamic> json) => new UsuarioModel(  // es una funcion que llamaremos cuando queremos generar una instancia de Usuario que viene de un mapa en formato json
      rut      : json["Rut"],
      rol      : json["Rol"],
      password : json["Password"],
    );

    Map<String, dynamic> toJson() => {//empareja los datos con los valores de las variables
      "Rut"      : rut,
      "Rol"      : rol,
      "Password" : password,
    };

}