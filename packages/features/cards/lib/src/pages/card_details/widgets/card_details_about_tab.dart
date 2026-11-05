part of '../card_details_page.dart';

class _CardDetailsAboutTab extends StatelessWidget {
  const _CardDetailsAboutTab({required this.character, required this.bottomInset});

  final CharacterModel character;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final styles = context.appStyle.text;
    final strings = local_strings.AppLocalizations.of(context);
    final interests = character.tags.where((tag) => tag.isNotEmpty).toList();
    final attributes = (character.attributes ?? const <String, String>{}).values
        .where((value) => value.isNotEmpty)
        .toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (character.publicBio.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SectionItem(
                strings.detailsBioSectionTitle,
                Text(
                  character.publicBio,
                  style: styles.p1.copyWith(color: palette.textOnSurfacePrimary),
                ),
              ),
            ),
          if (interests.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SectionItem(strings.detailsInterestsSectionTitle, _Chips(titles: interests)),
            ),
          if (attributes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SectionItem(strings.detailsAttributesSectionTitle, _Chips(titles: attributes)),
            ),
        ],
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips({required this.titles});

  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: titles.map((title) => RoundedInterestItem(title: title)).toList(),
    );
  }
}
