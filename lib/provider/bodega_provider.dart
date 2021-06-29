import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vision_one/modelo/bodega_model.dart';

class BodegaProvider {

  final String _dominio = 'http://192.168.1.86:5000';
  final bodega = new BodegaModel();

  Future<List<String>> cargarBodega() async {

    final url = '$_dominio/bodega';
    final resp = await http.get(Uri.parse(url));
    final data = json.decode(resp.body);

    final List<String> lista = [];
    lista.add('No aplica');
    
    if(data == null) return null;

    data.forEach((value) {

      final bodega = BodegaModel.fromJson(value);
      lista.add(bodega.nombre);

    });
    
    return lista;

  }

  void crearBodega(BodegaModel bodega) async {

    final url = '$_dominio/bodega';
    final url2 = '$_dominio/crearColumn';
    
    Map<String,String> header = {"Content-type" : "application/json"};

    await http.post(Uri.parse(url), headers: header, body: bodegaModelToJson(bodega));
    await http.post(Uri.parse(url2), headers: header, body: bodegaModelToJson(bodega));

  }

}