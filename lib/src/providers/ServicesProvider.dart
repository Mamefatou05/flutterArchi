import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../repositories/ApiRepository.dart';
import '../services/TransactionService.dart';
import '../services/UserService.dart';
import '../services/PlanificationTransfertService.dart';
import '../services/NumeroFavoriService.dart';

// Service Provider
class ServicesProvider extends ChangeNotifier {
  final ApiRepository _apiRepository;
  late final TransactionService transactionService;
  late final UserService userService;
  late final PlanificationTransfertService planificationService;
  late final NumeroFavoriService numeroFavoriService;

  ServicesProvider({required ApiRepository apiRepository}) : _apiRepository = apiRepository {
    _initializeServices();
  }

  void _initializeServices() {
    transactionService = TransactionService(apiRepository: _apiRepository);
    userService = UserService(apiRepository: _apiRepository);
    planificationService = PlanificationTransfertService(apiRepository: _apiRepository);
    numeroFavoriService = NumeroFavoriService(apiRepository: _apiRepository);
  }
}