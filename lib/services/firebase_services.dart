import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendOTP(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,

      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto login (Android)
        await _auth.signInWithCredential(credential);
      },

      verificationFailed: (FirebaseAuthException e) {
        print("Error: ${e.message}");
      },

      codeSent: (String verificationId, int? resendToken) {
        print("OTP Sent");
        // save verificationId for next step (OTP screen)
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        print("Timeout");
      },
    );
  }
}