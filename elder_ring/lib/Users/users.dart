import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Users {
  static String _elderlyUsername = '';
  static String _careProviderUsername = '';
  static bool elderSet = false;
  static bool careProviderSet = false;
  static String _loginUser = '';
  static bool loginUserSet = false;

  static void setElderlyUsername(String username) {
    if (!elderSet) {
      _elderlyUsername = username;
      elderSet = true;
    }
  }

  static void setCareProviderUsername(String username) {
    if (!careProviderSet) {
      _careProviderUsername = username;
      careProviderSet = true;
    }
  }

  static void setLoginUser(String username) {
    if (!loginUserSet) {
      _loginUser = username;
      loginUserSet = true;
    }
  }

  static String getElderlyUsername() {
    return _elderlyUsername;
  }

  static String getCareProviderUsername() {
    return _careProviderUsername;
  }

  static String getLoginUser() {
    return _loginUser;
  }

  static void clear() {
    _elderlyUsername = '';
    _careProviderUsername = '';
    _loginUser = "";
    elderSet = false;
    careProviderSet = false;
    loginUserSet = false;
  }

  static Future<void> fetchAssociatedElder() async {
    if (!elderSet) {
      try {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('user_db')
            .where('username', isEqualTo: _careProviderUsername)
            .get();
        final documents = result.docs;
        if (documents.isNotEmpty) {
          _elderlyUsername = documents[0]['associated_elder'];
          elderSet = true;
        } else {
          Fluttertoast.showToast(msg: 'Error: User not found');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error: $e');
      }
    } else {
      throw Exception('Elder is already set');
    }
  }

  static Future<void> fetchAssociatedCareProvider() async {
    if (!careProviderSet) {
      try {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('user_db')
            .where('associated_elder', isEqualTo: _elderlyUsername)
            .get();
        final documents = result.docs;
        if (documents.isNotEmpty) {
          _careProviderUsername = documents[0]['username'];
          careProviderSet = true;
        } else {
          Fluttertoast.showToast(msg: 'Error: User not found');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error: $e');
      }
    } else {
      throw Exception('Care Provider is already set');
    }
  }
}
