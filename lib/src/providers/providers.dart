// Provider pour les services
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di/ServiceLocator.dart';
import '../models/AppStateData.dart';
import '../repositories/ApiRepository.dart';
import 'AppState.dart';
import 'ServicesProvider.dart';

final servicesProvider = Provider<ServicesProvider>((ref) {
  return ServicesProvider(apiRepository: sl<ApiRepository>());
});

// Provider pour l'état de l'application
final appStateProvider = StateNotifierProvider<AppState, AppStateData>((ref) {
  final services = ref.watch(servicesProvider);
  return AppState(services);
});
