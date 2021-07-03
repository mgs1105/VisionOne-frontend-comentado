// paquete que contiene todo el "material" de widgets para desarrollar la app
import 'package:flutter/material.dart';

//Importamos las paginas que tendra nuestra aplicacion
import 'package:vision_one/paginas/iniciar_sesion.dart';
import 'package:vision_one/paginas/home.dart';
import 'package:vision_one/paginas/crear_usuario.dart';
import 'package:vision_one/paginas/admin_usuarios.dart';
import 'package:vision_one/paginas/admin_seccion.dart';
import 'package:vision_one/paginas/lista_usuarios.dart';
import 'package:vision_one/paginas/producto_detalle.dart';
import 'package:vision_one/paginas/productos_de_seccion.dart';
import 'package:vision_one/paginas/crear_producto.dart';
import 'package:vision_one/paginas/stock_critico.dart';

//Un proyecto de flutter SIEMPRE buscara el archivo "main.dart" para correr la aplicacion
//Dentro de el buscara el metodo "main" y lo ejecutara.
//Este metodo a su vez buscara ejecutar otro metodo llamado "runApp" que correra la aplicacion,
//Al metodo RunApp debemos importarle una clase que sera la pagina principal de la app
// en este caso la clase se llama "MyApp" (Esta clase puede tener cualquier otro nombre pero se recomienda que no se cambie)
//Si notamos el metodo runApp debe recibir un Widget, por ende, a la clase MyApp le añadimos la propiedad de "extends SatatelessWidget"
void main() => runApp(MyApp());

//En Flutter existen 2 tipos de widgets principales
//StatelessWidget y StateFulWidget
//1 StatelessWidget: Es un tipo de widget que no cambia su estado, por ende, no la podemos usar para ir actualizando la pantalla.
//util para paginas como formularios, o en paginas donde solo debemos cargar una vez la informacion
//2 StatefullWidget: Si cambia su estado, podemos ir actualizandola constantemente y los cambios se van visualizando al instante. Ej: instagram, carrito de compra

class MyApp extends StatelessWidget {
  
  @override//sirve para sobre escribir el metodo con el que ya viene por defecto un "StatelessWidget". en otras palabras, para crearlo uno mismo.
  Widget build(BuildContext context) {//el metodo build es el encargado de dibujar los widgets en la pantalla, por eso debe regresar un widget a fuerza
  //el context contiene la informacion del arbol de widget. 
  
    return MaterialApp(//configura el nivel superior del navegador para buscar rutas, entre otras cosas.
      debugShowCheckedModeBanner: false, //esta propiedad cuando esta el false, quita un pequeño marcador en la esquina superior derecha. este maracador avisa que la app esta en desarrollo.
 title: 'VisionOne', // titulo de la aplicacion
      initialRoute: 'iniciarSesion', //ruta iniciar que desplegara el proyecto
      routes: { //definimos un Map con todas la rutas que tendra nuestra aplicacion.
        // definimos el nombre de como llegar a la ruta -> llamamos a la pagina. 
        'iniciarSesion' : (BuildContext context) => IniciarSesion(), 
        'home'          : (BuildContext context) => HomePage(),
        'lista_users'   : (BuildContext context) => ListaUserPage(),
        'stock_critico' : (BuildContext context) => StockCriticoPage(),
        'admin_users'   : (BuildContext context) => AdminUsuarioPage(),
        'crear_users'   : (BuildContext context) => CrearUsuarioPage(),
        'admin_seccion' : (BuildContext context) => AdminSeccionPage(),
        'productos'     : (BuildContext context) => ProductosPage(),
        'crearProd'     : (BuildContext context) => CrearProdPage(),
        'prodDetalle'   : (BuildContext context) => ProdDetallePage()
      },
    );
  }
}
