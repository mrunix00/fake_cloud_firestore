import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/src/mock_document_change.dart';

import 'mock_query_document_snapshot.dart';

class MockQuerySnapshot<T extends Object?> implements QuerySnapshot<T> {
  final List<DocumentSnapshot<T>> _documents;

  final List<DocumentChange<T>> _documentChanges = <DocumentChange<T>>[];

  MockQuerySnapshot(this._documents) {
    // TODO: support another change type (removed, modified).
    // ref: https://pub.dev/documentation/cloud_firestore_platform_interface/latest/cloud_firestore_platform_interface/DocumentChangeType-class.html
    _documents.asMap().forEach((index, document) {
      _documentChanges.add(MockDocumentChange<T>(
        document,
        DocumentChangeType.added,
        oldIndex:
            -1, // See: https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/DocumentChange/oldIndex.html
        newIndex: index,
      ));
    });
  }

  @override
  List<QueryDocumentSnapshot<T>> get docs => _documents
      .map(
        (doc) => MockQueryDocumentSnapshot(doc.reference, doc.id, doc.data()),
      )
      .toList();

  @override
  List<DocumentChange<T>> get docChanges => _documentChanges;

  @override
  // TODO: implement metadata
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  int get size => _documents.length;
}
