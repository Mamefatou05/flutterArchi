import 'TrasactionModel.dart';
import 'UserModel.dart';

class AppStateData {
  final UserModel? currentUser;
  final List<TransactionListDto> transactions;
  final bool isLoading;

  AppStateData({
    this.currentUser,
    this.transactions = const [],
    this.isLoading = false,
  });

  AppStateData copyWith({
    UserModel? currentUser,
    List<TransactionListDto>? transactions,
    bool? isLoading,
  }) {
    return AppStateData(
      currentUser: currentUser ?? this.currentUser,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
