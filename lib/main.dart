import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


//*********************************************************FireBase Sign In/Authorization***********************************************************
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth - Firebase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: MyHomePage(),
    );
  }
}



late String photoUrl;
late String name;


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Board"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  googleLogin();
                },
                child: Text("Google-Sign In"),
            ),
            ElevatedButton(
                onPressed:() => logout(),
                child: Text("Log Out")
            ),
            ElevatedButton(
                onPressed: () {},
                child: Text("Create Account")
            )
          ],
        ),
      ),
    );
  }





  googleLogin() async {
    print("googleLogin method Called");
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var result = await _googleSignIn.signIn();
      if (result == null) {
        return;
      }

      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult = await FirebaseAuth.instance.signInWithCredential(credential);
      print("Result $result");
      print(result.displayName);
      print(result.email);
      print(result.photoUrl);
      setState(() {
        photoUrl = result.photoUrl!;
        name = result.displayName!;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) =>display(photoUrl,name)));

    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }

}


class display extends StatelessWidget {
  String photoUrl;
  String name;

  display(this.photoUrl,this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Welcome",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green,
                ),
            ),
            const SizedBox(height: 20,),
            Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.greenAccent,
                ),
            ),
            const SizedBox(height: 18,),
            Divider(thickness: 2.3,),
            InkWell(
              child: Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(150.0)),
                  image:DecorationImage(image: NetworkImage(photoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            Divider(thickness: 2.3,),
          ],
        ),
      ),
    );
  }
}






















