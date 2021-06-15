import 'package:flutter/material.dart';
import 'package:vision_one/modelo/producto_model.dart';
import 'package:vision_one/provider/producto_provider.dart';

class DataProd extends SearchDelegate { // creamos una clase para manejar el buscador de productos

  ProductoModel producto = new ProductoModel(); // creamos una nueva instancia de productoModel
  ProductoProvider productoProvider = new ProductoProvider();// creamos una nueva instancia de productoProvider

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
          
          return ListView(// Widget que se dibujara en la pantalla para mantener una estructura
            children: productos.map((producto) { //recorremos la lista de productos con una variable "producto"
              return ListTile( // widget que se dibujara en pantalla para ver los resultados obtenidos
                title: Text(producto.nombre), //Texto en pantalla con el nombre del producto
                subtitle: Column( //los subtitulos se almacenaran el columnas
                  children: [ 
                    Text('2AN1: Arrendadora  ${producto.stockA}'), //Texto en pantalla con datos del producto
                    Text('2AN2: Servicio Liviano  ${producto.stockB}'),//Texto en pantalla con datos del producto
                    Text('2AN3 Servicio Pesado  ${producto.stockC}'),//Texto en pantalla con datos del producto
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

  

}