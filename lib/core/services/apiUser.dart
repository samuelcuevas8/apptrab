
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/core/services/apiPublicacionTrabajo.dart';
import 'dart:async';

import '../../locator.dart';

class ApiUser{
  ApiPublicacionTrabajo _apiPublicaconTrabajo= locator<ApiPublicacionTrabajo>();
//  ApiPublicacionTrabajo _apiPublicaconTrabajo= new ApiPublicacionTrabajo(path);

  final Firestore _db= Firestore.instance;
  final String path;
  CollectionReference ref;

  ApiUser( this.path){
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection()  {
    return ref.getDocuments() ;
  }
//  Future<QuerySnapshot> getDataSubCollection(String idDocCollection, String nameSubCollection){
//    return ref.document(idDocCollection).collection(nameSubCollection).getDocuments();
//  }
  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots() ;
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }
  Future<void> removeDocument(String id){
    return ref.document(id).delete();
  }
//  Future<DocumentReference> addDocument(Map data, String uid) {
  Future<void> addDocument(Map data, String uid) {
//    return ref.add(data);
    return ref.document(uid).setData(data);
  }

  Future<void> updateDocument(Map data , String id) {
    return ref.document(id).updateData(data) ;
  }

  Stream<QuerySnapshot> streamDataSubCollection(String idDocCollection,String nameSubCollection){
    return ref.document(idDocCollection).collection(nameSubCollection).snapshots();
  }
  Future<QuerySnapshot> getDataSubCollection(String idDocCollection, String nameSubCollection) {
    return ref.document(idDocCollection).collection(nameSubCollection).orderBy('fechaCreacion',descending: true).getDocuments() ;
  }
  Future<DocumentSnapshot> getDocumentFromSubCollectionById(String idDocCollection,String nameSubCollection, String idDocSubCollection) {
    return ref.document(idDocCollection).collection(nameSubCollection).document(idDocSubCollection).get();
  }
  Future<DocumentReference> addDocumentInSubCollection(String idDocCollection, String nameSubCollection, Map data) {
    return ref.document(idDocCollection).collection(nameSubCollection).add(data);
  }
  Future<void> updateDocumentInSubCollection(String idDocCollection, String nameSubCollection , String idDocSubCollection,Map data ) {
    return ref.document(idDocCollection).collection(nameSubCollection).document(idDocSubCollection).updateData(data) ;
  }
  Future<void> removeDocumentFromSubCollectionById(String idDocCollection, String nameSubCollection,String idDocSubCollection){
    return ref.document(idDocCollection).collection(nameSubCollection).document(idDocSubCollection).delete();
  }
//--------------------------------------------------------------------------------------------------------------
  //esta funcion es solo para publicaciones de usuarios que a la vez insertan en otra coleccion llamada "publicaciones"
  Future<void> addDocumentInSubCollectionPublication(String idDocCollection, String nameSubCollection, Map data) {
    DocumentReference refDocumentPublicacionUser=ref.document(idDocCollection).collection(nameSubCollection).document();
    String idPublicacionUser=refDocumentPublicacionUser.documentID+Timestamp.now().nanoseconds.toString();
    data['idUser']=idDocCollection;
    _apiPublicaconTrabajo.addDocumentPublicacion(data, idPublicacionUser);
    return ref.document(idDocCollection).collection(nameSubCollection).document(idPublicacionUser).setData(data);
  }

  Future<void> updateDocumentInSubCollectionPublication(String idDocCollection, String nameSubCollection , String idDocSubCollection,Map data ) {
    data['idUser']=idDocCollection;
    _apiPublicaconTrabajo.updateDocumentPublicacion(data, idDocSubCollection);
    return ref.document(idDocCollection).collection(nameSubCollection).document(idDocSubCollection).updateData(data) ;
  }

  Future<void> removeDocumentFromSubCollectionByIdPublication(String idDocCollection, String nameSubCollection,String idDocSubCollection){
    _apiPublicaconTrabajo.removeDocumentPublicacion(idDocSubCollection);
    return ref.document(idDocCollection).collection(nameSubCollection).document(idDocSubCollection).delete();
  }
// ---------------------------------------------------------------------------------------------------------------------------------
  Future<DocumentReference> addDocumentInSubCollection2(
      String idDocCollection,
      String nameSubCollection,
      String idDocSubCollection,
      String nameSubCollection2,
      Map data) {
    return
      ref.document(idDocCollection)
        .collection(nameSubCollection)
        .document(idDocSubCollection)
        .collection(nameSubCollection2)
        .add(data);
  }
// ---------------------------------------------------------------------------------------------------------------------------------
  Future<void> updateDocumentInSubCollection2(
      String idDocCollection,
      String nameSubCollection,
      String idDocSubCollection,
      String nameSubCollection2,
      String idDocSubCollection2,
      Map data ) {
    return
      ref.document(idDocCollection)
          .collection(nameSubCollection)
          .document(idDocSubCollection)
          .collection(nameSubCollection2)
          .document(idDocSubCollection2)
          .updateData(data) ;
  }
// ---------------------------------------------------------------------------------------------------------------------------------

  Future<void> removeDocumentFromSubCollection2ById(
      String idDocCollection,
      String nameSubCollection,
      String idDocSubCollection,
      String nameSubCollection2,
      String idDocSubCollection2
      ) {
    return ref.document(idDocCollection)
        .collection(nameSubCollection)
        .document(idDocSubCollection)
        .collection(nameSubCollection2)
        .document(idDocSubCollection2)
        .delete();
  }
// ---------------------------------------------------------------------------------------------------------------------------------

}