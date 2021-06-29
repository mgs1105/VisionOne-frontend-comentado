import 'package:flutter/material.dart';
import 'package:vision_one/bloc/producto_bloc.dart';
import 'package:vision_one/modelo/producto_model.dart';
//import 'package:vision_one/modelo/seccion_model.dart';
import 'package:vision_one/modelo/usuario_model.dart';
import 'package:vision_one/provider/producto_provider.dart';
import 'package:vision_one/provider/seccion_provider.dart';

class StockCriticoPage extends StatefulWidget {

  @override
  _StockCriticoPageState createState() => _StockCriticoPageState();
}

class _StockCriticoPageState extends State<StockCriticoPage> {

  ProductoModel productoModel = new ProductoModel();
  ProductoBloc productoBloc = new ProductoBloc();
  ProductoProvider productoProvider = new ProductoProvider();

  SeccionProvider seccion = new SeccionProvider();

  @override
  Widget build(BuildContext context) {
    
    final UsuarioModel usuario = ModalRoute.of(context).settings.arguments;
    productoBloc.stockCritico(usuario.bodega);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Stock Critico'),
      ),
      body: _listaProductos(usuario.bodega),
    );
  }

  Widget _listaProductos(String usuarioBodega) {

    return StreamBuilder(
      stream: productoBloc.stockCriticoStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {

        if(snapshot.hasData) {
          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (BuildContext context, int i)
            =>_productos(context, productos[i]) 
          );

        
        } else {

          return Center(child: Text('No se encontro informacion'));
        
        }
      }
    );

  }

  Widget _productos(BuildContext context, ProductoModel producto) {

    final estilo = TextStyle(color: Colors.black, fontSize: 15.0);
    int stock;
    String bodega;

    if(producto.arrendador != null) {
      stock = producto.arrendador;
      bodega = "Arrendador";
    }
    if(producto.servicioliviano != null){
      stock = producto.servicioliviano;
      bodega = "Servicio Liviano";
    } 

    if(producto.serviciopesado != null) {
      stock = producto.serviciopesado;
      bodega = "Servicio Pesado";
    }

    //return FutureBuilder(
    //  future: seccion.buscarSeccion(producto.idseccion),
    //  builder: (BuildContext context, AsyncSnapshot<List<SeccionModel>> snapshot) {
    //    final info = snapshot.data;
        return Card(
          elevation: 10.0,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              Text('${producto.nombre}', style: estilo),
              ],
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //SizedBox(height: 10.0),
                //Text('Seccion: ${info[0].nombre}'),
                SizedBox(height: 10.0),
                Text('N° de parte: ${producto.nParte}', style: TextStyle(color: Colors.red, fontSize: 15.0)),
                SizedBox(height: 10.0),
                Text('Bodega: $bodega', style: estilo),
                SizedBox(height: 10.0),
                Text('Stock actual: $stock', style: estilo),
                SizedBox(height: 10.0),
                Text('Stock critico: ${producto.stockCritico}', style: estilo),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        );
      
    //  },
    //);


  }


}