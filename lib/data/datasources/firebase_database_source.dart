import 'package:anirecord/domain/entities/album_entity.dart';
import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/domain/entities/serie_info_entity.dart';
import 'package:anirecord/domain/repositories/serie_repository_interface.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataBaseSource extends SerieRepositoryInterface {
  final FirebaseFirestore firebaseFirestore;

  FirebaseDataBaseSource(this.firebaseFirestore);

  @override
  Future<Map<String, List<Serie>>> getActivity() async {
    try {
      DateTime currentDate = DateTime.now();
      DateTime oneMonthAgo = currentDate.subtract(const Duration(days: 30));

      final snapshot = await FirebaseFirestore.instance
          .collection('series')
          .where('created', isGreaterThanOrEqualTo: oneMonthAgo)
          .orderBy('created', descending: true)
          .get();

      final result =
          snapshot.docs.map((e) => Serie.fromMap(e.data(), e.id)).toList();
      Map<String, List<Serie>> documentsByDay = {};
      DateTime now = DateTime.now();
      DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));

      for (var doc in result) {
        DateTime date = doc.created;
        String day = date.day.toString();
        String monthName = getMonthName(date.month);
        String formattedDate;

        if (date.year == now.year &&
            date.month == now.month &&
            date.day == now.day) {
          formattedDate = 'HOY';
        } else if (date.year == yesterday.year &&
            date.month == yesterday.month &&
            date.day == yesterday.day) {
          formattedDate = 'AYER';
        } else {
          formattedDate = '$day de $monthName';
        }

        if (!documentsByDay.containsKey(formattedDate)) {
          documentsByDay[formattedDate] = [];
        }
        documentsByDay[formattedDate]!.add(doc);
      }
      return documentsByDay;
    } catch (e) {
      // print(e.toString());
      return {};
    }
  }

  @override
  Future<SerieInfo> getSerieById(String id) async{
    final informationRef = firebaseFirestore.collection("details").doc(id);
    final snapt = await informationRef.get();
    final data = snapt.data() as Map<String, dynamic>;
    return SerieInfo.fromJson(data);
  }
  
  @override
  Future<Map<String, dynamic>> getAllAlbumsOfSerieById(String uid, String sid)async {
    Map<String, dynamic> result = {};
    CollectionReference albumesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('albumes');

    QuerySnapshot snapshot = await albumesRef.get();

    List<Album> allAlbums = snapshot.docs.map((e) {
      final data = e.data() as Map<String, dynamic>;

      return Album(
          id: e.id,
          iconCode: data['iconCode'] as int,
          title: data['title'],
          recuento: data['recuento'] as int,
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          );
    }).toList();

    // final test = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(uid)
    //     .collection('albumes')
    //     .get();
    // List<String> albumsIds = test.docs.map((e) => e.id).toList();
    // print(albumsIds);

    for (var element in allAlbums) {
      final snatRS = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('albumes')
          .doc(element.id)
          .collection('series')
          .where(FieldPath.documentId, isEqualTo: sid)
          .get();

      if (snatRS.docs.isNotEmpty) {
        result[element.id] = {
          'title': element.title,
          'status': true,
          'desc': element.description,
          'iconCode':element.iconCode,
          'recuento':element.recuento
        };
      } else {
        result[element.id] = {
          'title': element.title,
          "recuento":element.recuento,
          'status': false,
          'desc': element.description,
          'iconCode':element.iconCode
        };
      }
    }

    return result;
  }
  
  @override
  Future<void> addSerieToAlbum(String uid,String aid, Serie serie, bool action) async{
    try {
      DocumentReference albumRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('albumes')
          .doc(aid);
      //agregar
      if (action == true) {
        await albumRef.collection('series').doc(serie.id).set(serie.toMap());
        await albumRef.set(
            {'recuento': FieldValue.increment(1)}, SetOptions(merge: true));
      } else {
        await albumRef.collection('series').doc(serie.id).delete();
        await albumRef.set(
            {'recuento': FieldValue.increment(-1)}, SetOptions(merge: true));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<List<Serie>> getSeriesList({OrderOptions? orderBy = OrderOptions.season, int? limit, String? generoBy}) async{
    Query query = firebaseFirestore.collection('series');
    if (orderBy == OrderOptions.season) {
      query = query.orderBy('season');
    } else if (orderBy == OrderOptions.year) {
      query = query.orderBy('year', descending: true);
    } else if (orderBy == OrderOptions.created) {
      query = query.orderBy('created', descending: true);
    }
    if (generoBy != null) {
      query = query.where('generos', arrayContains: generoBy);
    }

    if (limit != null) {
      query = query.limit(limit);
    }
    final querySnapshot = await query.get();
    final series = querySnapshot.docs
        .map((doc) => Serie.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    return series;
  }
  
  @override
  Future<List<Album>> getAllAlbumes(String uid) async{
    try {
      CollectionReference albumes = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('albumes');

      final querySnapshot = await albumes.limit(6).get();
      print(querySnapshot.docs.length);
      final List<Album> albums = [];
      for (var e in querySnapshot.docs) {
        final Map<String, dynamic> albumData = e.data() as Map<String, dynamic>;
        final String albumId = e.id;

        final String titulo = albumData['title'] as String;
        final String? desc = albumData['description'] as String?;
        final int recuento = albumData['recuento'] as int;
        final int iconCode = albumData['iconCode'] as int;
        final DateTime tiemeStamp =
            (albumData['timestamp'] as Timestamp).toDate();

        
        final Album a = Album(
          iconCode: iconCode,
            id: albumId,
            description: desc,
            title: titulo,
            timestamp: tiemeStamp,
            
            recuento: recuento);

        albums.add(a);
      }
      return albums;
    } catch (e) {
      print('Error al obtener los albumes: $e');
      return [];
    }
  }
  
  @override
  Future<void> deleteAlbumById(String uid, String aid) async{
    CollectionReference albumesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('albumes');
albumesRef.doc(aid).collection("series").get().then(
  (querySnapshot) async{
    for (var element in querySnapshot.docs) {
      await element.reference.delete();
    }
    }
);

    albumesRef.doc(aid).delete().then((value) {
      // print('Álbum eliminado exitosamente');
    }).catchError((error) {
      // print('Error al eliminar el álbum: $error');
      throw Exception(error.toString());
    });
  }
  
  @override
  Future<void> createAlbum({required String uid, required String title,required int iconCode, String? description}) async{
    try {
      // Obtener la referencia al documento del usuario
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Crear un nuevo documento de álbum en la subcolección 'albumes'
      /*DocumentReference albumRef = */ await userRef.collection('albumes').add({
        'title': title,
        'description': description,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'series': [],
        'recuento': 0,
        'iconCode':iconCode
      });

      // print('Nuevo álbum creado con ID: ${albumRef.id}');
    } catch (error) {
      // print('Error al crear el nuevo álbum: $error');
    }
  }
  
  @override
  Future<List<Serie>> getSeriesOfAlbum(String uid, String aid)async {
    try {
      CollectionReference albumesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('albumes');

      final result = await albumesRef.doc(aid).collection('series').get();
      return result.docs
          .map((e) => Serie.fromMap(e.data(),e.id))
          .toList();
    } catch (e) {
      
      return [];
    }
  }
  
  @override
  Future<void> deleteSerieOfAlbum(String uid, String aid, String sid) async{
    try {
      final albumesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('albumes').doc(aid);
        await albumesRef.collection('series').doc(sid).delete();
        await albumesRef.set(
            {'recuento': FieldValue.increment(-1)}, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }

  }
}