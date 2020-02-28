import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journal_project/notifier/user_notifier.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final UserModel _userModel = new UserModel();

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

  _userModel.registerUser(user.getIdToken().toString(), user.displayName,
      user.email, user.photoUrl, true);

  prefs.setString('user_uid', user.getIdToken().toString());
  prefs.setString('user_name', user.displayName);
  prefs.setString('user_email', user.email);
  prefs.setString('user_image', user.photoUrl);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await googleSignIn.signOut();

  prefs.setString('user_uid', null);
  prefs.setString('user_name', null);
  prefs.setString('user_email', null);
  prefs.setString('user_image', null);

  print("User Sign Out");
}
