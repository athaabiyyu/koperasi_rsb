import 'package:flutter/material.dart';
import '../models/token_usage_model.dart';
import '../services/token_service.dart';

class TokenProvider extends ChangeNotifier {
  final TokenService _tokenService = TokenService();

  // Token usage details state
  List<TokenUsageDetail> _tokenUsageList = [];
  bool _isLoadingUsage = false;
  String? _usageError;

  // Buy token state
  bool _isBuyingToken = false;
  String? _buyTokenError;
  String? _buyTokenSuccess;

  // Getters
  List<TokenUsageDetail> get tokenUsageList => _tokenUsageList;
  bool get isLoadingUsage => _isLoadingUsage;
  String? get usageError => _usageError;
  bool get isBuyingToken => _isBuyingToken;
  String? get buyTokenError => _buyTokenError;
  String? get buyTokenSuccess => _buyTokenSuccess;

  /// Load token usage details for authenticated user
  Future<void> loadTokenUsageDetails(String token) async {
    try {
      _isLoadingUsage = true;
      _usageError = null;
      notifyListeners();

      print('\n📊 === LOADING TOKEN USAGE DETAILS ===');

      _tokenUsageList = await _tokenService.getTokenUsageDetails(token);

      _isLoadingUsage = false;
      notifyListeners();

      print('✅ Loaded ${_tokenUsageList.length} token usage details');
    } catch (e) {
      _isLoadingUsage = false;
      _usageError = e.toString().replaceAll('Exception: ', '');
      _tokenUsageList = [];
      notifyListeners();

      print('❌ Failed to load token usage: $_usageError');
    }
  }

  /// Clear token usage cache
  void clearTokenUsage() {
    _tokenUsageList = [];
    _isLoadingUsage = false;
    _usageError = null;
    notifyListeners();
  }

  /// Get top 3 recent token usage
  List<TokenUsageDetail> getTopTokenUsage({int limit = 3}) {
    if (_tokenUsageList.length <= limit) {
      return _tokenUsageList;
    }
    return _tokenUsageList.take(limit).toList();
  }

  /// Get token usage by status
  List<TokenUsageDetail> getTokenUsageByStatus(String status) {
    return _tokenUsageList
        .where((usage) => usage.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  /// Get total tokens used
  int getTotalTokensUsed() {
    return _tokenUsageList.fold<int>(
      0,
      (sum, usage) => sum + usage.tokenCountInt,
    );
  }

  /// Get total nominal invested
  int getTotalNominalInvested() {
    return _tokenUsageList.fold<int>(
      0,
      (sum, usage) => sum + usage.totalNominalInt,
    );
  }

  /// Buy token for a project
  Future<bool> buyToken({
    required String token,
    required String projectId,
    required int jumlahToken,
  }) async {
    try {
      _isBuyingToken = true;
      _buyTokenError = null;
      _buyTokenSuccess = null;
      notifyListeners();

      print('\n💰 === BUYING TOKEN ===');
      print('Project ID: $projectId');
      print('Amount: $jumlahToken');

      final result = await _tokenService.buyToken(
        token: token,
        projectId: projectId,
        jumlahToken: jumlahToken,
      );

      _isBuyingToken = false;

      if (result['success'] == true) {
        _buyTokenSuccess = result['message'];
        notifyListeners();

        // Refresh token usage list
        await loadTokenUsageDetails(token);

        print('✅ Token purchased successfully');
        return true;
      } else {
        _buyTokenError = result['message'];
        notifyListeners();

        print('❌ Failed to buy token: $_buyTokenError');
        return false;
      }
    } catch (e) {
      _isBuyingToken = false;
      _buyTokenError = 'Terjadi kesalahan: ${e.toString()}';
      notifyListeners();

      print('❌ Exception in buyToken: $_buyTokenError');
      return false;
    }
  }

  /// Clear buy token messages
  void clearBuyTokenMessages() {
    _buyTokenError = null;
    _buyTokenSuccess = null;
    notifyListeners();
  }
}