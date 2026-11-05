import 'package:navigation/navigation.dart';

class CyocPath extends PathInfo {
  const CyocPath(super.path, super.name);

  static const cyocSourceParam = 'cyocSourceParam';

  static const creationPath = CyocPath('/create-character', 'cyoc_create_character');
}
