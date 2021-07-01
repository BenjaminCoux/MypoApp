import 'package:mypo/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // ignore: unused_field
  static late SharedPreferences _preferences;

  // ignore: unused_field
  static const _keyUser = 'user';

  static User myUser = User(
    imagePath: "https://picsum.photos/id/1005/200/300",
    name: "Bryan",
    email: 'bryan.test@gmail.com',
    phoneNumber: '0606060606',
    about:
        " my info : Incenderat autem audaces usque ad insaniam homines ad haec, quae nefariis egere conatibus, Luscus quidam curator urbis subito visus: eosque ut heiulans baiolorum praecentor ad expediendum quod orsi sunt incitans vocibus crebris. qui haut longe postea ideo vivus exustus est. regionem praestitutis celebritati diebus invadere parans dux ante edictus per solitudines Aboraeque amnis herbidas ripas, suorum indicio proditus, qui admissi flagitii metu exagitati ad praesidia descivere Romana. absque ullo egressus effectu deinde tabescebat immobilis.",
    //isDarkMode: false,
  );
/*
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    init();
    final userDataJson = jsonEncode(user.toJson());
    await _preferences.setString(_keyUser, userDataJson);
  }

  static User getUser() {
    final json = _preferences.getString(_keyUser);
    // if json is null we return the current user
    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
  */
}
