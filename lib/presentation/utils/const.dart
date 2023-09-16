import 'package:flutter/material.dart';

String imageCover(String id) =>
    "https://storage.googleapis.com/anirecord-955d7.appspot.com/480x720/$id.jpg";


String getMonthName(int month) {
  switch (month) {
    case 1: return 'Enero';
    case 2: return 'Febrero';
    case 3: return 'Marzo';
    case 4: return 'Abril';
    case 5: return 'Mayo';
    case 6: return 'Junio';
    case 7: return 'Julio';
    case 8: return 'Agosto';
    case 9: return 'Septiembre';
    case 10: return 'Octubre';
    case 11: return 'Noviembre';
    case 12: return 'Diciembre';
    default: return '';
  }
}

String seasonConvert(String season){
  switch (season) {
    case "summer":
      return "Verano";
    case "fall":
      return "Otoño";
    case "spring":
      return "Primavera";
    default:
      return "Invierno";
  }
}

String statusConvert(String status){
  switch (status) {
    case "issue":
      return "En emisión";
    case "canceled":
      return "Cancelado";  
    default:
      return "Finalizado";
  }
}

const colorAppBar =   Color(0xffffffff);
const colorPrimary =  Color(0xffd28b11);
const colorPrimaryInverted = Color(0xff2d74ee);