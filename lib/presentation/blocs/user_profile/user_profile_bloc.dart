import 'package:cinema_app/data/datasources/api_client.dart';
import 'package:cinema_app/data/datasources/storage.dart';
import 'package:cinema_app/presentation/blocs/user_profile/user_profile_event.dart';
import 'package:cinema_app/presentation/blocs/user_profile/user_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final ApiClient apiClient;

  UserProfileBloc({required this.apiClient}) : super(UserProfileInitial()) {
    on<LoadUserProfile>(_loadUserProfile);
    on<UpdateUserName>(_updateUserName);
  }

  Future<void> _loadUserProfile(
      LoadUserProfile event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final accessToken = await Storage.getAccessToken();
      final user = await apiClient.getCurrentUser(accessToken!);
      emit(UserProfileLoaded(user: user));
    } catch (e) {
      emit(UserProfileError(message: 'Помилка: $e'));
    }
  }

  Future<void> _updateUserName(
      UpdateUserName event, Emitter<UserProfileState> emit) async {
    try {
      final accessToken = await Storage.getAccessToken();
      final updatedUser =
      await apiClient.updateCurrentUser(accessToken!, event.newName);
      emit(UserProfileLoaded(user: updatedUser));
      emit(UserProfileUpdated());
    } catch (e) {
      emit(UserProfileError(message: 'Помилка оновлення інформації: $e'));
    }
  }
}
