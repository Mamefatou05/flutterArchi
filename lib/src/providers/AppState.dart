import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/AppStateData.dart';
import '../models/TrasactionModel.dart';
import 'ServicesProvider.dart';




// App State Notifier
class AppState extends StateNotifier<AppStateData> {
  final ServicesProvider services;

  AppState(this.services) : super(AppStateData()) {
    initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      state = state.copyWith(isLoading: true);

      final user = await services.userService.getUserProfile();
      final transactions = await services.transactionService.getMyTransactions();

      state = AppStateData(
        currentUser: user,
        transactions: transactions,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> refreshTransactions() async {
    try {
      state = state.copyWith(isLoading: true);

      final newTransactions = await services.transactionService.getMyTransactions();

      state = state.copyWith(
        transactions: newTransactions,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<bool> performTransfer(TransferRequestDto transferRequest) async {
    try {
      state = state.copyWith(isLoading: true);

      // Effectuer le transfert
      await services.transactionService.transfer(transferRequest);

      // Rafraîchir les transactions
      await refreshTransactions();

      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}
