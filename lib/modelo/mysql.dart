//importamos el paquete de mysql para realizar la conexion
import 'package:mysql1/mysql1.dart';
//En flutter cuando queremo importar paquetes al proyecto debemos hacerlo en el archivo "pubspec.yaml"
//lo mismo debemos hacerlo para importar imagenes o archivos que estan en la carpeta del proyecto.
//en este caso tenemos una carpeta llamada "imagenes". esta carpeta tambien debemos importarla en el "pubspec.yaml"

class Mysql {
  //creamos varias variables string y una int para dar los datos de conexion.
  static String host = 'localhost',
                user = 'root',
                password = '1234',
                db = 'company';

  static int port = 3306;
  //inicializamos la clase Mysql
  Mysql();

  //Creamos un metodo de tipo Future que debe regresar un "MySqlConnection". el metodo se llama "getConnection".
  //los metodos de tipo Future son de un tipo que entregaran su informacion en un futuro determinado.
  //Se usan mucho en peticiones http donde la consulta no es inmediata, sino que toma unos segundos.
  //Para que el programa no se detenga ni cause algun error esperando la respuesta que queremos, por eso se usan los Future
  //que deben ir acompañados siempre de un "async". 

  Future<MySqlConnection> getConnection() async {
    //Creamos la variable "settings" que tendra toda la informacion de la conexion usando el new "ConnectionSettings" (ajustes de conexion).
    var settings = new ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db
    );
    //el metodo creado retorna un tipo valido, "MySqlConnection" que a su vez le ejecutamos la funcion ".connect" y le mandamos la variable
    //settings que es dueña de los parametros de conexion.
    //se usa la palabra await ya que es un proceso que toma algunos segundos. en este caso el programa esperar a que se realice la conexion y regresara el resultado.    
    return await MySqlConnection.connect(settings);
  } 
}