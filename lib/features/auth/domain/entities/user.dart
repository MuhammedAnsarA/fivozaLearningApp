import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  final String uid;
  final String email;
  final String? profilePic;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groupIds;
  final List<String> enrolledCourseIds;
  final List<String> following;
  final List<String> followers;

  const LocalUser({
    required this.uid,
    required this.email,
    required this.points,
    required this.fullName,
    this.profilePic,
    this.bio,
    this.groupIds = const [],
    this.enrolledCourseIds = const [],
    this.following = const [],
    this.followers = const [],
  });

  const LocalUser.empty()
      : this(
          uid: "",
          email: "",
          points: 0,
          enrolledCourseIds: const [],
          followers: const [],
          following: const [],
          fullName: "",
          groupIds: const [],
          bio: "",
          profilePic: "",
        );

  @override
  List<Object?> get props => [uid, email];

  @override
  String toString() {
    return 'LocalUser{uid:$uid,email:$email,bio: '
        '$bio,points:$points,fullName:$fullName}';
  }
}
