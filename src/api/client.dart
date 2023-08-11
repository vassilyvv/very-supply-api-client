import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/catalogue/menu_section_entry.dart';
import '../models/logistics/transaction_entry.dart';
import '../models/trade/order_entry.dart';
import 'responses.dart';

final Dio _dio = Dio();

const apiBaseUrl =
    String.fromEnvironment('apiBaseUrl', defaultValue: 'http://localhost:8000');

class GenericResponse {
  late int statusCode;
  String? validationError;

  GenericResponse(this.statusCode, [this.validationError]);

  GenericResponse.fromResponse(Response response) {
    statusCode = response.statusCode!;
  }
}

class LoginResponse extends GenericResponse {
  String? accessToken;
  String? refreshToken;

  LoginResponse(statusCode, this.accessToken, this.refreshToken)
      : super(statusCode);

  LoginResponse.fromResponse(Response response) : super.fromResponse(response) {
    accessToken = response.data['access'];
    refreshToken = response.data['refresh'];
  }

  String toJson() {
    return jsonEncode({
      'response_status': this.statusCode,
      'access_token': this.accessToken,
      'refresh_token': this.refreshToken
    });
  }
}

Map<String, Function> apiMethods = {
  'refreshAccessToken': (String refreshToken) async {
    return TokenRefreshResponse.fromResponse(await _dio.post(
        "$apiBaseUrl/moses/token/refresh/",
        data: {'refresh': refreshToken},
        options: Options(validateStatus: (status) => status! < 500)));
  },
  'authenticate': (String phoneNumber, String password, String? otp) async {
    Response response = await _dio.post(
      "$apiBaseUrl/moses/token/obtain/",
      data: {
        'phone_number': phoneNumber,
        'password': password,
        'otp': otp ?? ""
      },
      options: Options(validateStatus: (status) => status! < 500),
    );
    return LoginResponse.fromResponse(response);
  },
  'checkOtpStatus': (String phoneNumber) async {
    phoneNumber = Uri.encodeQueryComponent(phoneNumber);
    Response response = await _dio.get(
        "$apiBaseUrl/moses/is_mfa_enabled_for_phone_number/?phone_number.dart=$phoneNumber",
        options: Options(validateStatus: (status) => status! < 500));
    return OtpStatusResponse.fromResponse(response);
  },
  'register': (
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String password,
  ) async {
    Response response = await _dio.post(
      "$apiBaseUrl/moses/users/",
      data: {
        'phone_number': phoneNumber,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'email': email
      },
      options: Options(validateStatus: (status) => status! < 500),
    );
    return RegisterResponse.fromResponse(response);
  },
  'resetPassword': (String? phoneNumber, String? email) async {
    Response response = await _dio.post(
      "$apiBaseUrl/moses/password/reset/",
      data:
          email == null ? {'phone_number.dart': phoneNumber} : {'email': email},
      options: Options(validateStatus: (status) => status! < 500),
    );
    return PasswordResetResponse.fromResponse(response);
  },
  'getAuthenticatedUserData': (String accessToken) async {
    return UserDataResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/moses/users/me/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'getProfileByPhoneOrEmail': (String accessToken, String value) async {
    return UserDataResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/moses/get_by_phone_or_email/?value=${Uri.encodeComponent(value)}",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'updateProfile':
      (String accessToken, String phoneNumber, String email) async {
    return UserDataResponse.fromResponse(await _dio.patch(
      "$apiBaseUrl/moses/users/me/",
      data: {"phone_number.dart": phoneNumber, "email": email},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'confirmEmail':
      (String accessToken, String emailPin, String emailCandidatePin) async {
    return ConfirmEmailResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/moses/confirm_email/",
      data: {"pin": emailPin, "candidate_pin": emailCandidatePin},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'addMenuSectionEntryToFavorites':
      (String accessToken, MenuSectionEntry menuSectionEntry) async {
    return AddMenuSectionEntryToFavoritesResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/catalogue/menusectionentrieslistentry/",
      data: {
        "menu_section_entry_id": menuSectionEntry.id,
        "menu_section_entries_list": "00000000-0000-0000-0000-000000000001"
      },
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'removeFavoritesEntry':
      (String accessToken, String menuSectionEntriesListEntryId) async {
    return RemoveMenuSectionEntryFromFavoritesResponse.fromResponse(
        await _dio.delete(
      "$apiBaseUrl/catalogue/menusectionentrieslistentry/$menuSectionEntriesListEntryId/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'confirmPhoneNumber':
      (String accessToken, String emailPin, String emailCandidatePin) async {
    return ConfirmPhoneNumberResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/moses/confirm_phone_number/",
      data: {"pin": emailPin, "candidate_pin": emailCandidatePin},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'updatePassword':
      (String accessToken, String oldPassword, String newPassword) async {
    return UpdatePasswordResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/moses/password/",
      data: {"current_password": oldPassword, "new_password": newPassword},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'setMFAEnabled': (String accessToken, String action, String? secretKey,
      String? otp) async {
    return MFASwitchResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/moses/mfa/",
      data: {"action": action, "mfa_secret_key": secretKey},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken', 'OTP': otp}),
    ));
  },
  'getCompany': ({
    required String accessToken,
    required String companyId,
  }) async {
    return CompanyResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/company/company/$companyId",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'getMarketplaceRootMenuSection':
      (String marketplaceId, String? companyId) async {
    String url =
        "$apiBaseUrl/catalogue/menusection/for_marketplace/?marketplace=$marketplaceId";
    if (companyId != null) {
      url += "&company=$companyId";
    }
    return MenuSectionResponse.fromResponse(await _dio.get(
      url,
      options: Options(validateStatus: (status) => status! < 500),
    ));
  },
  'getOrders': (String accessToken) async {
    return OrdersListResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/trade/order/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'createOrder': ({
    required String? accessToken,
    required List<OrderEntry> entries,
    required List<String> promocodes,
  }) async {
    return OrderCreateResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/trade/order/",
      data: {
        "order_entries": entries,
        "promocodes": promocodes,
      },
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'rateOffer': (
    String accessToken,
    String offerId,
    int value,
  ) async {
    return OrderCreateResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/trade/offerrating/",
      data: {"offer": offerId, "value": value},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'getTransactions': (String accessToken, int companyId) async {
    return TransactionsResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/logistics/transaction/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'createTransaction': ({
    required String accessToken,
    required int sourceNode,
    required int targetNode,
    int? orderEntryToPayFor,
    int? orderEntryToCompensateFor,
    int? orderEntry,
    required List<TransactionEntry> transactionEntries,
    List<String> externalLedgerTransactions = const [],
    Map<String, dynamic> extraData = const {},
    List<int> pipelineIds = const [],
  }) async {
    Map<String, dynamic> data = {
      "source": sourceNode,
      "target": targetNode,
      if (orderEntry != null) "order_entry": orderEntry,
      if (orderEntryToPayFor != null)
        "order_entry_to_pay_for": orderEntryToPayFor,
      if (orderEntryToCompensateFor != null)
        "order_entry_to_compensate_for": orderEntryToCompensateFor,
      "entries": transactionEntries,
      "extra_data": extraData,
      "external_ledger_transactions": externalLedgerTransactions,
      "pipelines": pipelineIds,
    };

    return TransactionCreateResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/logistics/transaction/",
      data: data,
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'getNodes': (String accessToken) async {
    return NodesListResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/logistics/transactionnode/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  },
  'getMenuSectionEntries': (String? accessToken,
      String? menuSectionEntriesListId,
      String? menuSectionId,
      String? searchQuery) async {
    Map<String, String> queryParams = {};
    if (menuSectionEntriesListId != null) {
      queryParams['menu_section_entries_list'] = menuSectionEntriesListId;
    }
    if (menuSectionId != null) {
      queryParams['menu_section'] = menuSectionId;
    }
    if (searchQuery != null) {
      queryParams['q'] = searchQuery;
    }
    Map<String, String> headers = {};
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    String queryParamsString = queryParams.entries
        .map((entry) => "${entry.key}=${entry.value}")
        .join("&");
    return MenuSectionEntriesResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/catalogue/menusectionentry/?$queryParamsString",
      options:
          Options(validateStatus: (status) => status! < 500, headers: headers),
    ));
  }
};
