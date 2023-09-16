
class Album {
  final String id;
  final String? description;
  final String title;
  final int iconCode;
  final DateTime timestamp;
  
  final int recuento;

  Album({
    required this.id,
   this.description,
    required this.title,
    required this.timestamp,

    required this.recuento,
    required this.iconCode
  });


}