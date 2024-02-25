import 'package:equatable/equatable.dart';
import 'package:fivoza_learning/core/res/media_res.dart';

class PageContent extends Equatable {
  final String image;
  final String title;
  final String description;

  const PageContent({
    required this.image,
    required this.title,
    required this.description,
  });

  const PageContent.first()
      : this(
          image: MediaRes.casualReading,
          title: "Brand new curriculum",
          description:
              'This is the first online education platform designed by the '
              "world's top proffesers",
        );

  const PageContent.second()
      : this(
          image: MediaRes.casualLife,
          title: "Brand a fun atmosphere",
          description:
              'This is the first online education platform designed by the '
              "world's top proffesers",
        );

  const PageContent.third()
      : this(
          image: MediaRes.casualMeditationScience,
          title: "Easy to join the lesson",
          description:
              'This is the first online education platform designed by the '
              "world's top proffesers",
        );
  @override
  List<Object?> get props => [image, title, description];
}
