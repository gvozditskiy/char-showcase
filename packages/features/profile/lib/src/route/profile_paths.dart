import 'package:navigation/navigation.dart';

class ProfilePath extends PathInfo {
  const ProfilePath(super.path, super.name);

  static const generalAppearance = ProfilePath('/settings', 'profile_general_appearance');
}
