import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;

Future<String> signInWithGoogle() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;

  prefs.setString('username', name);
  prefs.setString('useremail', email);
  prefs.setString('userimage', imageUrl);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await googleSignIn.signOut();

  prefs.setString('username', null);
  prefs.setString('useremail', null);
  prefs.setString('userimage', null);

  print("User Sign Out");
}
