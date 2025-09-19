import '../models/user_model.dart';

abstract class IUserRepository {
  Future<List<UserModel>> getUsers({bool forceRefresh = false});
  
  Future<UserModel> getUser(int id, {bool forceRefresh = false});
  
  Future<UserModel?> getUserFromLocal(int id);
  
  Future<void> cacheUsers(List<UserModel> users);
}