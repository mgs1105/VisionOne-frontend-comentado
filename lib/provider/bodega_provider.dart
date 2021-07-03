import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vision_one/modelo/bodega_model.dart';

class BodegaProvider {

  final String _dominio = 'http://192.168.1.86:5000';//  //definimos parte de la url donde se haran las consultas
  final bodega = new BodegaModel();//  //creamos una instancia del modelo del bodega

  Future<List<String>> cargarBodega() async {//metodo que cargara las bodegas

    final url = '$_dominio/bodega';//creamos una variable que tendra todo el url donde hacer la peticion
    final resp = await http.get(Uri.parse(url));//creamos una variable que ESPERARA(await) la respuesta de la peticion. En la funcion get debemos mandar un Uri (Uniform Resource Locator)
    //(Localizador de recursos uniforme). la variable "url" al no ser un Uri debemos "parsearlo" usando el ".parse". 
    // parsear: Proceso de analizar una secuencia de símbolos a fin de determinar su estructura gramatical definida    
    final data = json.decode(resp.body);//creamos una variable que tendra la informacion de la peticion. esta informacion sera en un formato json

    final List<String> lista = [];//una variable de tipo lista de secciones.
    lista.add('No aplica');// añadimos un String a la lista
    
    if(data == null) return null;//si la data es nula, regresamos nulo.

    data.forEach((value) {//recorremos toda la informacion del "data" y cada bodega es almacenado en la variable "value".

      final bodega = BodegaModel.fromJson(value);//guaradmos un Map de la seccion en la variable "bodega"
      lista.add(bodega.nombre);// añadimos el nombre de las bodega a la lista

    });
    
    return lista; //regreamos la lista

  }

}