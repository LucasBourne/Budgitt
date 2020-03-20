import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;
String userID;

void signUpEmailPassword(String em, String pw) async
{
  try
  {
    await _auth.createUserWithEmailAndPassword(email: em, password: pw);
  }
  catch (e)
  {
    print(e.toString());
  }
}

Future<String> signInEmailPassword(String em, String pw) async
{
  final AuthResult authResult = await _auth.signInWithEmailAndPassword(email: em, password: pw);
  final FirebaseUser user = authResult.user;

  assert(user.email != null);

  email = user.email;
  userID = user.uid;

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInEmailPassword succeeded: $user';
}

Future<String> signInWithGoogle() async 
{
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;
  userID = user.uid;

  if (name.contains(" ")) 
  {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async
{
  await googleSignIn.signOut();
  print("User Sign Out");
}