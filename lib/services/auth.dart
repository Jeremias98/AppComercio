import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vivero/models/usuario.dart';

class AuthService {
  // Dependencies
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  // Shared State for Widgets
  Observable<FirebaseUser> user; // firebase user
  Observable<Usuario> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();
  bool sesionIniciada = false;

  // constructor
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        sesionIniciada = true;
        return _db
            .collection('usuarios')
            .document(u.uid)
            .snapshots()
            .map((snap) => Usuario.fromMap(snap.data));
      } else {
        sesionIniciada = false;
        return Observable.just(new Usuario());
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async {
    // Start
    loading.add(true);

    // Step 1
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    // Step 2
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    // Step 3
    updateUserData(user);

    // Done
    loading.add(false);

    return user;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('usuarios').document(user.uid);

    Usuario usuario = new Usuario(
        uid: user.uid,
        nombre: user.displayName,
        email: user.email,
        fotoUrl: user.photoUrl,
        ultimaVez: DateTime.now());

    return ref.setData({
      'uid': usuario.uid,
      'nombre': usuario.nombre,
      'email': usuario.email,
      'fotoUrl': usuario.fotoUrl,
      'ultimaVez': usuario.ultimaVez
    }, merge: true);
  }

  void signOut() {
    _auth.signOut();
  }

}

final AuthService authService = AuthService();
