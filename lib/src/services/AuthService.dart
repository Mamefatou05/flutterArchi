import '../core/storage/TokenStorageInterface.dart';
import '../models/LoginModel.dart';
import '../models/JwtModel.dart';
import '../repositories/ApiRepository.dart';

class AuthService {
  final ApiRepository _apiRepository;
  final TokenStorageInterface _tokenStorage;

  AuthService({
    required ApiRepository apiRepository,
    required TokenStorageInterface tokenStorage,
  })  : _apiRepository = apiRepository,
        _tokenStorage = tokenStorage;

  Future<JwtModel?> login(LoginModel loginRequest) async {
    final response = await _apiRepository.post('/auth/login', loginRequest.toJson());

    if (response.status == 'SUCCESS' && response.data != null) {
      final jwtResponse = JwtModel.fromJson(response.data);
      await _tokenStorage.saveToken(jwtResponse.token);
      return jwtResponse;
    }
    return null;
  }

  Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }
}