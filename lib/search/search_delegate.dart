import 'package:flutter/material.dart';
import 'package:vision_one/modelo/producto_model.dart';
import 'package:vision_one/provider/producto_provider.dart';
import 'package:vision_one/provider/seccion_provider.dart';

class DataProd extends SearchDelegate { // creamos una clase para manejar el buscador de productos

  ProductoModel producto = new ProductoModel(); // creamos una nueva instancia de productoModel
  ProductoProvider productoProvider = new ProductoProvider();// creamos una nueva instancia de productoProvider
  SeccionProvider seccionProvider = new SeccionProvider();

  @override

  List<Widget> buildActions(BuildContext context) {// Acciones de nuestro appBar. EJ: un icono que elimine el texto
      return [
        IconButton(// boton en forma de icono
          icon: Icon(Icons.clear),  //icono
          onPressed: () { // instruccion que ejecuta el icono
            query = ''; // query hace referencia al campo donde escribimos para buscar. en este caso cuando presionamos el boton limpa todo lo escrito y lo deja vacio
          },
        )
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) { // Muestra un widget a su izquierda
      return IconButton(// Icono a la izquierda del AppBar
        icon: AnimatedIcon( //tipo de icono animado
          icon: AnimatedIcons.menu_arrow,//icono
          progress: transitionAnimation, //es el tiempo en el cual se animara el icono. 
        ),
        onPressed: (){ //accion que se hara al presionar el icono
          close(context, null); //quita la busqueda y vuelve a la pantalla donde estabamos antes 
        },
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {// Crea los resultados que se mostraran
      return Container();
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {// Son las sugerencias que aparecen cuando la persona escribe
      
      if(query.isEmpty) { // si el campo donde escribimos esta vacio mandara un contenedor vacio
        return Container();
      } 

      return FutureBuilder( // widget para ir mostrando las sugerencias
        future: productoProvider.buscarProducto(query), // definimos el future que leeremos y le mandamos el query para que filtre la busqueda
        builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) { // el builder es el encargado de dibujar lo que deseamos. recibe dos variables, el context y una que por defecto se llama "snapshot" y tendra toda la informacion del stream

          if(snapshot.hasData) {// "si el snapshot tiene informacion"... hara lo siguiente.
            final productos = snapshot.data;// guardamos la "Data" (informacion) en la variable productos
            TextStyle color = TextStyle(color: Colors.black, fontSize: 15.0);

          return ListView(// Widget que se dibujara en la pantalla para mantener una estructura
            children: productos.map((producto) { //recorremos la lista de productos con una variable "producto"
              return ListTile( // widget que se dibujara en pantalla para ver los resultados obtenidos
                title: Text(producto.nombre, style: TextStyle(fontSize: 18.0, color: Colors.black)), //Texto en pantalla con el nombre del producto
                subtitle: Column( //los subtitulos se almacenaran el columnas
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [ 
                    SizedBox(height: 15.0),
                    nombreSeccion(producto.idseccion),
                    SizedBox(height: 5.0),
                    Text('2AN1: Arrendadora  ${producto.arrendador}', style: color),//Texto en pantalla con datos del producto
                    Text('2AN2: Servicio Liviano  ${producto.servicioliviano}', style: color),//Texto en pantalla con datos del producto
                    Text('2AN3 Servicio Pesado  ${producto.serviciopesado}', style: color),//Texto en pantalla con datos del producto
                    SizedBox(height: 10.0),
                    Text('Numero de parte: ${producto.nParte}', style: TextStyle(color: Colors.red)),
                    SizedBox(height: 20.0),
                  ],
                ),
              );
            }).toList() //pasamos el mapa a una lista
          );
          } else {
            return Center(child: CircularProgressIndicator()); //si no encontramos nada manda un ciruclo de carga

          }
        }
      );

  }
  
  Widget nombreSeccion(int id) {

  return FutureBuilder(
    future: seccionProvider.buscarSeccion(id),
    builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
      
      if(snapshot.hasData) {
      final secciones = snapshot.data;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Seccion: ', style: TextStyle(fontSize: 16.0, color: Colors.black)),
          secciones,
        ],
      );
      } else {
        return Text('Cargando...');
      }
    }
  );

}  

}