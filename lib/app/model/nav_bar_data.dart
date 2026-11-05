import 'package:common_ui/common_ui.dart';
import 'package:equatable/equatable.dart';

class NavBarData extends Equatable {
  const NavBarData({required this.items, required this.selectedItem});

  final List<NavBarItem> items;
  final NavBarItem selectedItem;

  @override
  List<Object?> get props => [items, selectedItem];
}
