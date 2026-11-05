enum CyocNavigationSource {
  navBar('navBar'),
  feedPromoCard('feedPromo');

  const CyocNavigationSource(this.analyticsName);
  final String analyticsName;

  static CyocNavigationSource safeValueOf(String? name) {
    return CyocNavigationSource.values
            .where((element) => element.analyticsName == name)
            .firstOrNull ??
        CyocNavigationSource.navBar;
  }
}
