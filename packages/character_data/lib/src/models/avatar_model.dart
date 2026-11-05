import 'package:equatable/equatable.dart';

class AvatarModel extends Equatable {
  const AvatarModel({this.image});

  final String? image;

  @override
  List<Object?> get props => [image];
}
