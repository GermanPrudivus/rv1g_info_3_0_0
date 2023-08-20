class Job {
  const Job({
    required this.id,
    required this.title,
    required this.description,
    required this.media,
    required this.startDate,
    required this.endDate,
  });

  final int id;
  final String title;
  final List<String> description;
  final List<String> media;
  final String startDate;
  final String endDate;
}