enum CharacterGender {
  male('male'),
  female('female'),
  other('other'),
  nonBinary('non-binary'),
  unspecified('unspecified');

  const CharacterGender(this.analyticsName);

  final String analyticsName;
}
