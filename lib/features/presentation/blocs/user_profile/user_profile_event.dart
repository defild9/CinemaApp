abstract class UserProfileEvent {}

class LoadUserProfile extends UserProfileEvent {}

class UpdateUserName extends UserProfileEvent {
  final String newName;

  UpdateUserName({required this.newName});
}