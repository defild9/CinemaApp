class Movie {
  final int? id;
  final String? name;
  final String? image;
  final int? age;
  final String? trailer;
  final String? smallImage;
  final String? originalName;
  final int? duration;
  final String? language;
  final String? rating;
  final int? year;
  final String? country;
  final String? genre;
  final String? plot;
  final String? starring;
  final String? director;
  final String? screenwriter;
  final String? studio;

  Movie({
    required this.id,
    required this.name,
    required this.image,
    required this.age,
    required this.trailer,
    required this.smallImage,
    required this.originalName,
    required this.duration,
    required this.language,
    required this.rating,
    required this.year,
    required this.country,
    required this.genre,
    required this.plot,
    required this.starring,
    required this.director,
    required this.screenwriter,
    required this.studio,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      age: json['age'],
      trailer: json['trailer'],
      smallImage: json['smallImage'],
      originalName: json['originalName'],
      duration: json['duration'],
      language: json['language'],
      rating: json['rating'],
      year: json['year'],
      country: json['country'],
      genre: json['genre'],
      plot: json['plot'],
      starring: json['starring'],
      director: json['director'],
      screenwriter: json['screenwriter'],
      studio: json['studio'],
    );
  }
}