part of 'nav_bar_root_cubit.dart';

sealed class NavBarRootState extends Equatable {
  const NavBarRootState(this.navBarItems);

  final List<NavBarItem> navBarItems;

  @override
  List<Object> get props => [navBarItems];
}

class NavBarRootData extends NavBarRootState {
  const NavBarRootData(super.navBarItems);
}
