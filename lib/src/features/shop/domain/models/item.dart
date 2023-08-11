class Item {
  const Item({
    required this.id,
    required this.title,
    required this.shortText,
    required this.description,
    required this.media,
    required this.price,
  });

  final int id;
  final String title;
  final String shortText;
  final List<String> description;
  final List<String> media;
  final String price;
}