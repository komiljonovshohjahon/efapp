// ignore_for_file: empty_catches

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class FirestoreDep {
  //create singleton
  static final FirestoreDep _firestoreDep = FirestoreDep._internal();

  FirestoreDep._internal();

  factory FirestoreDep() => _firestoreDep;

  //create instance
  static FirestoreDep get instance => _firestoreDep;

  final deps = DependencyManager.instance;

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  static String booksCn = 'books';
  late final booksQuery = fire.collection(booksCn).withConverter(
      fromFirestore: (snapshot, options) {
        final data = snapshot.data()!;
        return BookMd.fromJson(data);
      },
      toFirestore: (value, options) => value.toJson());
  static String blogsCn = 'blogs';
  late final blogsQuery = fire.collection(blogsCn).withConverter(
      fromFirestore: (snapshot, options) {
        final data = snapshot.data()!;
        return BlogMd.fromMap(data);
      },
      toFirestore: (value, options) => value.toMap());
  static String galleryCn = 'gallery';
  late final galleryQuery = fire.collection(galleryCn).withConverter(
      fromFirestore: (snapshot, options) {
        final data = snapshot.data()!;
        return GalleryMd.fromMap(data);
      },
      toFirestore: (value, options) => value.toMap());
  static String galleryImagesCn = 'gallery_images';
  late final galleryImagesQuery =
      fire.collection(galleryImagesCn).withConverter(
          fromFirestore: (snapshot, options) {
            final data = snapshot.data()!;
            return GalleryImageMd.fromMap(data);
          },
          toFirestore: (value, options) => value.toMap());
  static String ytVideosCn = 'youtube_videos';
  late final ytVideosQuery = fire.collection(ytVideosCn).withConverter(
      fromFirestore: (snapshot, options) {
        final data = snapshot.data()!;
        return YtVideoMd.fromMap(data);
      },
      toFirestore: (value, options) => value.toMap());
  static String pillarOfCloud = 'pillar_of_cloud';
  late final pillarOfCloudQuery = fire.collection(pillarOfCloud).withConverter(
      fromFirestore: (snapshot, options) {
        final data = snapshot.data()!;
        return PillarMd.fromMap(data);
      },
      toFirestore: (value, options) => value.toMap());
  static String pillarOfFire = 'pillar_of_fire';
  late final pillarOfFireQuery = fire.collection(pillarOfFire).withConverter(
      fromFirestore: (snapshot, options) {
        final data = snapshot.data()!;
        return PillarMd.fromMap(data);
      },
      toFirestore: (value, options) => value.toMap());

  static String pillarOfFireForm = 'fire_form_data';
  late final pillarOfFireFormQuery =
      fire.collection(pillarOfFireForm).withConverter(
          fromFirestore: (snapshot, options) {
            final data = snapshot.data()!;
            return PillarMdForm.fromMap(data);
          },
          toFirestore: (value, options) => value.toMap());
  static String pillarOfCloudForm = 'cloud_form_data';
  late final pillarOfCloudFormQuery =
      fire.collection(pillarOfCloudForm).withConverter(
          fromFirestore: (snapshot, options) {
            final data = snapshot.data()!;
            return PillarMdForm.fromMap(data);
          },
          toFirestore: (value, options) => value.toMap());
  static String contactedFormsCn = 'contacted_forms';

  static String prayerRequestCn = 'prayer_request';

  final FirebaseFirestore _fire = FirebaseFirestore.instance;

  FirebaseFirestore get fire => _fire;

  User? get currentUser => FirebaseAuth.instance.currentUser;

  static const String messagingTopic =
      "send-scheduled-notifications-evans-francis";

  Map<String, String> _makePayload(
      {required String route,
      required String collection,
      required String documentId,
      required String title,
      String? type}) {
    return {
      "route": route,
      "collection": collection,
      "documentId": documentId,
      "title": title,
      "type": type ?? "",
    };
  }

  Future<Either<bool, String>> sendNotification(
      Map<String, String> payload) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAA7NueD3k:APA91bF-zVehMTyVZvyfzv8VAtNpscUm3nAZRwwtVjTTGIhID7YIgxzkEIIOZwXk6mL03HVr8WB9W1_8j7PZSkhsEO97K_yC27WxMZV59aIuuT-6BxWt2T1mmwOTGntOT8xCB7_O7BSM',
      };
      final res = await Dio(BaseOptions(
        baseUrl: "https://fcm.googleapis.com/fcm",
        headers: headers,
      )).post('/send', data: {
        "to": "/topics/$messagingTopic",
        "data": payload,
      });
      Logger.i("Notification sent ${res.statusCode}", tag: "sendNotification");
      return Left(res.statusCode == 200);
    } on DioException catch (e) {
      Logger.e(e.error.toString(), tag: "sendNotification DioException");
      return Right(e.toString());
    } catch (e) {
      Logger.e(e.toString(), tag: "sendNotification");
      return Right(e.toString());
    }
  }

  //Get collectionBasedListStream
  Stream<List<T>> getCollectionBasedListStream<T>({
    required String collection,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    String? orderByKey,
    dynamic orderByValue,
  }) {
    if (orderByKey != null) {
      return _fire
          .collection(collection)
          .withConverter<T>(
              fromFirestore: (snapshot, _) => fromJson(snapshot.data()!),
              toFirestore: (dev, _) => toJson(dev))
          .where(orderByKey, isEqualTo: orderByValue)
          .snapshots()
          .map((event) => event.docs.map((e) => e.data()).toList());
    }
    return _fire
        .collection(collection)
        .withConverter<T>(
            fromFirestore: (snapshot, _) => fromJson(snapshot.data()!),
            toFirestore: (dev, _) => toJson(dev))
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  //Get collectionBasedListFuture
  Future<Either<List<T>, String>> getCollectionBasedListFuture<T>({
    required String collection,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final res = await _fire.collection(collection).get();
      final list = res.docs.map((e) => fromJson(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //findByCollectionAndDocumentId<T>
  Future<T?> findByCollectionAndDocumentId<T>({
    required String collection,
    required String documentId,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final res = await _fire.collection(collection).doc(documentId).get();
      if (res.data() == null) return null;
      return fromJson(res.data()!);
    } catch (e) {
      return null;
    }
  }

  //GET books
  Future<Either<List<BookMd>, String>> getBooks() async {
    try {
      final res = await _fire.collection(booksCn).get();
      final list = res.docs.map((e) => BookMd.fromJson(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //CREATE OR UPDATE Book
  Future<Either<String, void>> createOrUpdateBook(
      {required BookMd model, required List<Uint8List?> images}) async {
    final docs =
        await _fire.collection(booksCn).where("id", isEqualTo: model.id).get();

    if (docs.docs.isEmpty) {
      //create
      var m = BookMd.init();
      m = model.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdDate: DateTime.now().toString(),
      );

      //upload image
      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          if (images[i] == null) continue;
          try {
            final imageData = images[i];
            final res = await DependencyManager.instance.fireStorage
                .uploadImage(data: imageData!, path: "$booksCn/${m.id}/$i");
            if (res.isLeft) {
              //error
              Logger.e("Error uploading image: ${res.left}");
            }
          } catch (e) {}
        }
      }

      return firestoreHandler(_fire.collection(booksCn).add(m.toJson()));
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(booksCn)
          .doc(docs.docs.first.id)
          .update(model.toJson()));
    }
  }

  //DELETE BOOK
  Future<Either<String, void>> deleteBook(String id) async {
    Logger.d('deleteBook: $id');
    final docs =
        await _fire.collection(booksCn).where("id", isEqualTo: id).get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    try {
      //delete recursively
      await DependencyManager.instance.fireStorage
          .deleteFolder("${FirestoreDep.booksCn}/$id");
    } catch (e) {
      Logger.e(e.toString());
    }
    return firestoreHandler(
        _fire.collection(booksCn).doc(docs.docs.first.id).delete());
  }

  //CREATE OR UPDATE Pillar
  Future<Either<String, void>> createOrUpdatePillarForm(
      {required PillarMdForm model, required bool isCloud}) async {
    final docs = await _fire
        .collection(isCloud ? pillarOfCloudForm : pillarOfFireForm)
        .where("id", isEqualTo: model.id)
        .get();

    if (docs.docs.isEmpty) {
      //create
      var m = PillarMdForm.init();
      m = model.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now().toString(),
      );

      return firestoreHandler(_fire
          .collection(isCloud ? pillarOfCloudForm : pillarOfFireForm)
          .add(m.toMap()));
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(isCloud ? pillarOfCloudForm : pillarOfFireForm)
          .doc(docs.docs.first.id)
          .update(model.toMap()));
    }
  }

  //GET Pillar of Cloud
  Future<Either<List<PillarMdForm>, String>> getPillarForms(
      {required bool isCloud}) async {
    try {
      final res = await _fire
          .collection(isCloud ? pillarOfCloudForm : pillarOfFireForm)
          .get();
      final list = res.docs.map((e) => PillarMdForm.fromMap(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //GET Blogs
  Future<Either<List<BlogMd>, String>> getBlogs() async {
    try {
      final res = await _fire.collection(blogsCn).get();
      final list = res.docs.map((e) => BlogMd.fromMap(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //CREATE OR UPDATE Blog
  Future<Either<String, void>> createOrUpdateBlog(
      {required BlogMd model,
      required List<Uint8List?> images,
      bool sendNotification = true}) async {
    final docs =
        await _fire.collection(blogsCn).where("id", isEqualTo: model.id).get();

    payload(String id) {
      return _makePayload(
        route: "blogs",
        collection: blogsCn,
        documentId: id,
        title: "Blog",
      );
    }

    //upload image
    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        if (images[i] == null) continue;
        try {
          final imageData = images[i];
          final imgPath = "$blogsCn/${model.id}/$i";
          final res = await DependencyManager.instance.fireStorage
              .uploadImage(data: imageData!, path: imgPath);
          model = model.copyWith(imagePath: imgPath);
          if (res.isLeft) {
            //error
            Logger.e("Error uploading image: ${res.left}");
          }
        } catch (e) {}
      }
    }

    if (docs.docs.isEmpty) {
      //create
      return firestoreHandler(_fire.collection(blogsCn).add(model.toMap()))
          .then((value) {
        if (sendNotification) {
          this.sendNotification(payload(value.right.id));
        }
        return value;
      });
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(blogsCn)
          .doc(docs.docs.first.id)
          .update(model.toMap()));
    }
  }

  //DELETE Blog
  Future<Either<String, void>> deleteBlog(String id) async {
    Logger.d('deleteBlog: $id');
    final docs =
        await _fire.collection(blogsCn).where("id", isEqualTo: id).get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    try {
      //delete recursively
      await DependencyManager.instance.fireStorage
          .deleteFolder("${FirestoreDep.blogsCn}/$id");
    } catch (e) {
      Logger.e(e.toString());
    }
    return firestoreHandler(
        _fire.collection(blogsCn).doc(docs.docs.first.id).delete());
  }

  //GET YOUTUBE VIDEOS
  Future<Either<List<YtVideoMd>, String>> getYtVideos() async {
    try {
      final res = await _fire.collection(ytVideosCn).get();
      final list = res.docs.map((e) => YtVideoMd.fromMap(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //CREATE OR UPDATE YtVideo
  Future<Either<String, void>> createOrUpdateVideo(
      {required YtVideoMd model, bool sendNotification = true}) async {
    final docs = await _fire
        .collection(ytVideosCn)
        .where("id", isEqualTo: model.id)
        .get();

    payload(String id) {
      return _makePayload(
          route: "yt", collection: ytVideosCn, documentId: id, title: "Video");
    }

    if (docs.docs.isEmpty) {
      //create
      return firestoreHandler(_fire.collection(ytVideosCn).add(model.toMap()))
          .then((value) {
        if (sendNotification) {
          this.sendNotification(payload(value.right.id));
        }
        return value;
      });
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(ytVideosCn)
          .doc(docs.docs.first.id)
          .update(model.toMap()));
    }
  }

  //DELETE Blog
  Future<Either<String, void>> deleteVideo(String id) async {
    Logger.d('deleteVideo: $id');
    final docs =
        await _fire.collection(ytVideosCn).where("id", isEqualTo: id).get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    try {
      //delete recursively
      await DependencyManager.instance.fireStorage
          .deleteFolder("${FirestoreDep.ytVideosCn}/$id");
    } catch (e) {
      Logger.e(e.toString());
    }
    return firestoreHandler(
        _fire.collection(ytVideosCn).doc(docs.docs.first.id).delete());
  }

  //GET Pillar of fire forms
  Future<Either<List<PillarMdForm>, String>> getPillarOfFireForms() async {
    try {
      final res = await _fire.collection(pillarOfFireForm).get();
      final list = res.docs
          .map<PillarMdForm>((e) => PillarMdForm.fromMap(e.data()))
          .toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //GET Pillar of cloud forms
  Future<Either<List<PillarMdForm>, String>> getPillarOfCloudForms() async {
    try {
      final res = await _fire.collection(pillarOfCloudForm).get();
      final list = res.docs
          .map<PillarMdForm>((e) => PillarMdForm.fromMap(e.data()))
          .toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //delete pillar of fire form
  Future<Either<String, void>> deletePillarOfFireForm(String id) async {
    Logger.d('deletePillarOfFireForm: $id');
    final docs = await _fire
        .collection(pillarOfFireForm)
        .where("id", isEqualTo: id)
        .get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    return firestoreHandler(
        _fire.collection(pillarOfFireForm).doc(docs.docs.first.id).delete());
  }

  //delete pillar of cloud form
  Future<Either<String, void>> deletePillarOfCloudForm(String id) async {
    Logger.d('deletePillarOfCloudForm: $id');
    final docs = await _fire
        .collection(pillarOfCloudForm)
        .where("id", isEqualTo: id)
        .get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    return firestoreHandler(
        _fire.collection(pillarOfCloudForm).doc(docs.docs.first.id).delete());
  }

  //GET ALBUMS
  Future<Either<List<GalleryMd>, String>> getAlbums() async {
    try {
      final res = await _fire
          .collection(galleryCn)
          .orderBy("created_at", descending: true)
          .get();
      final list = res.docs.map((e) => GalleryMd.fromMap(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  Future<Either<String, void>> createOrUpdateGallery(
      {required GalleryMd model, required List<Uint8List?> images}) async {
    final docs = await _fire
        .collection(galleryCn)
        .where("id", isEqualTo: model.id)
        .get();

    //upload image
    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        if (images[i] == null) continue;
        try {
          final imageData = images[i];
          final imgPath = "$galleryCn/${model.id}/$i";
          final res = await DependencyManager.instance.fireStorage
              .uploadImage(data: imageData!, path: imgPath);
          model = model.copyWith(image: imgPath);
          if (res.isLeft) {
            //error
            Logger.e("Error uploading image: ${res.left}");
          }
        } catch (e) {}
      }
    }

    if (docs.docs.isEmpty) {
      //create
      return firestoreHandler(_fire.collection(galleryCn).add(model.toMap()));
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(galleryCn)
          .doc(docs.docs.first.id)
          .update(model.toMap()));
    }
  }

  //delete gallery
  Future<Either<String, void>> deleteGallery(String id) async {
    Logger.d('deleteGallery: $id');
    final docs =
        await _fire.collection(galleryCn).where("id", isEqualTo: id).get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    try {
      //delete recursively
      await DependencyManager.instance.fireStorage
          .deleteFolder("${FirestoreDep.galleryCn}/$id");
    } catch (e) {
      Logger.e(e.toString());
    }
    return firestoreHandler(
        _fire.collection(galleryCn).doc(docs.docs.first.id).delete());
  }

  //CREATE OR UPDATE Gallery images
  Future<Either<String, void>> createOrUpdateGalleryImage(
      {required GalleryImageMd model, required Uint8List? image}) async {
    final docs = await _fire
        .collection(galleryImagesCn)
        .where("id", isEqualTo: model.id)
        .get();

    //upload image
    if (image != null) {
      try {
        final imageData = image;
        final imgPath = "$galleryCn/${model.id}";
        final res = await DependencyManager.instance.fireStorage
            .uploadImage(data: imageData, path: imgPath);
        model = model.copyWith(imagePath: imgPath);
        if (res.isLeft) {
          //error
          Logger.e("Error uploading image: ${res.left}");
        }
      } catch (e) {}
    }

    if (docs.docs.isEmpty) {
      //create
      return firestoreHandler(
          _fire.collection(galleryImagesCn).add(model.toMap()));
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(galleryImagesCn)
          .doc(docs.docs.first.id)
          .update(model.toMap()));
    }
  }

  //delete gallery image
  Future<Either<String, void>> deleteGalleryImage(String id) async {
    Logger.d('deleteGalleryImage: $id');
    final docs = await _fire
        .collection(galleryImagesCn)
        .where("id", isEqualTo: id)
        .get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    try {
      //delete recursively
      await DependencyManager.instance.fireStorage
          .deleteFolder("${FirestoreDep.galleryCn}/$id");
    } catch (e) {
      Logger.e(e.toString());
    }
    return firestoreHandler(
        _fire.collection(galleryImagesCn).doc(docs.docs.first.id).delete());
  }

  //get contacted forms
  Future<Either<List<ContactMd>, String>> getContactedForms() async {
    try {
      final res = await _fire
          .collection(contactedFormsCn)
          .orderBy("created_at", descending: true)
          .get();
      final list = res.docs.map((e) => ContactMd.fromMap(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //CREATE OR UPDATE Contacted form
  Future<Either<String, void>> createOrUpdateContactedForm(
      {required ContactMd model}) async {
    final docs = await _fire
        .collection(contactedFormsCn)
        .where("id", isEqualTo: model.id)
        .get();

    if (docs.docs.isEmpty) {
      //create
      return firestoreHandler(
          _fire.collection(contactedFormsCn).add(model.toMap()));
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(contactedFormsCn)
          .doc(docs.docs.first.id)
          .update(model.toMap()));
    }
  }

  //delete contacted form
  Future<Either<String, void>> deleteContactedForm(String id) async {
    Logger.d('deleteContactedForm: $id');
    final docs = await _fire
        .collection(contactedFormsCn)
        .where("id", isEqualTo: id)
        .get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    return firestoreHandler(
        _fire.collection(contactedFormsCn).doc(docs.docs.first.id).delete());
  }

  Future<Either<List<PrayerRequestMd>, String>> getPrayerRequests() async {
    try {
      final res = await _fire.collection(prayerRequestCn).get();
      final list =
          res.docs.map((e) => PrayerRequestMd.fromJson(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  Future<Either<String, void>> createOrUpdatePrayerRequest(
      {required PrayerRequestMd model}) async {
    final docs = await _fire
        .collection(prayerRequestCn)
        .where("id", isEqualTo: model.id)
        .get();

    if (docs.docs.isEmpty) {
      //create
      return firestoreHandler(
          _fire.collection(prayerRequestCn).add(model.toJson()));
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(prayerRequestCn)
          .doc(docs.docs.first.id)
          .update(model.toJson()));
    }
  }

  //delete prayer request
  Future<Either<String, void>> deletePrayerRequest(String id) async {
    Logger.d('deletePrayerRequest: $id');
    final docs = await _fire
        .collection(prayerRequestCn)
        .where("id", isEqualTo: id)
        .get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    return firestoreHandler(
        _fire.collection(prayerRequestCn).doc(docs.docs.first.id).delete());
  }
}

Future<Either<String, T>> firestoreHandler<T>(Future callback) async {
  try {
    final res = await callback;
    Logger.i("Firestore Success");
    return Right(res as T);
  } on FirebaseException catch (e) {
    Logger.e("Firestore Error FException: ${e.message}");
    Logger.e("Firestore Error FException stack trace: ${e.stackTrace}");
    return Left(e.message ?? 'Error occurred');
  } catch (e) {
    Logger.e("Firestore Error catch: ${e.toString()}");
    return Left(e.toString());
  }
}

String prepareLinkForUpload(String link) {
  final int? firstIndexOfWhiteSpace =
      !link.contains(" ") ? null : link.indexOf(" ");
  //remove all after first whitespace
  if (firstIndexOfWhiteSpace != null) {
    return link.substring(0, firstIndexOfWhiteSpace);
  } else {
    return link;
  }
}
