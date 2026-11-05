enum CyocRelationshipType {
  strangers('👀'),
  friends('⚡'),
  friendsWithBenefits('🍸'),
  dating('🌶️'),
  affair('💋'),
  married('💍');

  const CyocRelationshipType(this.emoji);

  final String emoji;
}
