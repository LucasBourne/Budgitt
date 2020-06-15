import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;
String userID;

Future<String> signUpEmailPassword(String em, String pw) async
{
  try
  {
    await _auth.createUserWithEmailAndPassword(email: em, password: pw);
    return "Account successfully created. You may now sign in";
  }
  catch (e)
  {
    if(e.code == "ERROR_WEAK_PASSWORD")
    {
      return "ERROR: Password is too weak";
    }
    else
    {
      return(e.message);
    }
  }
}

Future<String> signInEmailPassword(String em, String pw) async
{
  try
  {
    final AuthResult authResult = await _auth.signInWithEmailAndPassword(email: em.trim(), password: pw);
    final FirebaseUser user = authResult.user;
  
    assert(user.email != null);

    name = "Email User";
    email = user.email;
    userID = user.uid;

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInEmailPassword succeeded: $user';
  }
  catch(PlatformException)
  {
    return "invalid login credentials";
  }
}

Future<String> signInWithGoogle() async 
{
  try
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

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'success';
  }
  catch (e)
  {
    return "Google sign in error";
  }
}

void signOutUser() async
{
  await _auth.signOut();
  await googleSignIn.signOut();
  print("User Sign Out");
}