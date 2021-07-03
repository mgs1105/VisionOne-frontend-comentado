import 'package:flutter/material.dart';
//import 'package:vision_one/modelo/bodega_model.dart';

//DropdownMenuItem => similar al combobox de html. lo definimos como una lista de String.
List<DropdownMenuItem<String>> opcionesRol(List roles) { //el metodo debe recibir la lista de roles

    List<DropdownMenuItem<String>> listarol = []; //creamos una lista vacia de tipo DropdownMenuItem("ComboBox")

    for (String rol in roles) { //recorremos la lista recibida en el metodo llamada roles con una nueva variable llamada rol
      listarol.add(DropdownMenuItem( //le añadimos a la lista creada anteriormente un DropdownMenuItem donde su texto visible sera el rol
        child: Text(rol),
        value: rol,
      ));
    }
    //asi continuamos con el ciclo for y vamos llenando la lista con opciones. luego regresamos la lista con las opciones encontradas de Rol.
    return listarol;  

}

SnackBar snackBar (String mensaje) { //Creamos un metodo que regresa un SnackBar y que debe recibir un string
  //SnackBar => alerta que aparece en la parte inferior de la pantalla por un periodo de tiempo.  
  return SnackBar( //el metodo regresa un SnackBar
  content: Text(mensaje), // definimos el texto que tendra aquella alerta. en este caso el String que recibe el metodo
  duration: Duration(seconds: 2), //definimos el tiempo que estara activo la alerta antes de que desaparezca
);
}



Widget boton(String rol, BuildContext context) { //definimos un metodo llamado boton que recibe el rol del usuario que se esta logeando.

  if(rol == 'ADMIN') { //condicion: si el rol es igual a ADMIN, sigue con las lineas de codigo, sino, retorna un container(contenedor) vacio
  return IconButton( //retorna un Icon como boton
    enableFeedback: false, //
    icon: Icon(Icons.group_add_outlined), //define el icono que tendra el boton 
    color: Colors.white, //define el color del icono
    iconSize: 35.0, //define el tamaño del icono
    onPressed: () { //definimos lo que pasara al presionar el iconButton
      Navigator.pushNamed(context, 'lista_users'); //navegamos a la pagina con el string de "lista_users" => para ver a que pagina nos envia debemos ver el archivo main.dart donde estan definidas las rutas
    }
  );
  } else {
    return Container(); //regresa un contenedor vacio.
  }


}

List<DropdownMenuItem<String>> opcionesBodega(List bodegas) {//el metodo debe recibir la lista de bodegas

  List<DropdownMenuItem<String>> listabodegas = []; //creamos lista vacia de tipo DropDownMenuItem

  for(String bodega in bodegas) {//recorremos la lista recibida en el metodo llamada "bodegas", con un string llamado "bodega"
    listabodegas.add(DropdownMenuItem( //le añadimos a la lista creada anteriormente un DropdownMenuItem donde su texto visible sera la bodega
      child: Text(bodega),
      value: bodega,
    ));
  }
//asi continuamos con el ciclo for y vamos llenando la lista con opciones. luego regresamos la lista con las opciones encontradas de bodegas.
  return listabodegas;
}