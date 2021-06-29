import 'package:flutter/material.dart';
import 'package:vision_one/modelo/bodega_model.dart';
import 'package:vision_one/provider/bodega_provider.dart';

import 'package:vision_one/utils/utils.dart' as utils;

class CrearBodegaPage extends StatefulWidget {

  @override
  _CrearBodegaPageState createState() => _CrearBodegaPageState();
}

class _CrearBodegaPageState extends State<CrearBodegaPage> {

  BodegaModel bodegaModel = new BodegaModel();
  BodegaProvider bodegaProvider = new BodegaProvider();

  final keyformulario = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final tamano = MediaQuery.of(context).size;    

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Crear Bodega'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: keyformulario,
            child: _body(tamano),
          ),
        ),
      ),
    );

  }

  Widget _body(Size tamano) {

    return Column(
      children: [
        Container(
          width: tamano.width * 0.7,
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Nombre de la bodega'
            ),
            onSaved: (value) => bodegaModel.nombre = value,
          ),
        ),
        SizedBox(height: tamano.height * 0.09),
        TextButton( 
          child: Text('Crear', style: TextStyle(fontSize: 15.0),),
          style: TextButton.styleFrom( 
            backgroundColor: Colors.blue, 
            primary: Colors.white, 
            padding: EdgeInsets.symmetric(horizontal: 50.0)
          ),
          onPressed: () {
            if(!keyformulario.currentState.validate()) return; 

            keyformulario.currentState.save();

            bodegaProvider.crearBodega(bodegaModel); 

            final snack = utils.snackBar('Bodega creada con exito'); 
            ScaffoldMessenger.of(context).showSnackBar(snack); 

          }, 
        ),
      ],
    );

  }
}