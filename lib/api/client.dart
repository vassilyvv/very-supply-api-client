import 'package:dio/dio.dart';

import 'responses.dart';

final Dio _dio = Dio();

const apiBaseUrl =
    String.fromEnvironment('apiBaseUrl', defaultValue: 'http://localhost:8000');


Map<String, Function> apiMethods = {
  'refreshAccessToken': (Map<String, dynamic> args) async {
    return TokenRefreshResponse.fromResponse(await _dio.post(
        "$apiBaseUrl/moses/token/refresh/",
        data: {'refresh': args['refreshToken']},
        options: Options(validateStatus: (status) => status! < 500)));
  },
  'authenticate': (Map<String, dynamic> args) async {
    Response response = await _dio.post(
      "$apiBaseUrl/moses/token/obtain/",
      data: {
        'phone_number': args['phoneNumber'],
        'password': args['password'],
        'otp': args['otp'] ?? ""
      },
      options: Options(validateStatus: (status) => status! < 500),
    );
    return LoginResponse.fromResponse(response);
  },
  'checkOtpStatus': (Map<String, dynamic> args) async {
    String phoneNumber = Uri.encodeQueryComponent(args['phoneNumber']);
    Response response = await _dio.get(
        "$apiBaseUrl/moses/is_mfa_enabled_for_phone_number/?phone_number.dart=$phoneNumber",
        options: Options(validateStatus: (status) => status! < 500));
    return OtpStatusResponse.fromResponse(response);
  },
  'register': (Map<String, dynamic> args) async {
    Response response = await _dio.post(
      "$apiBaseUrl/moses/users/",
      data: {
        'phone_number': args['phoneNumber'],
        'password': args['password'],
        'first_name': args['firstName'],
        'last_name': args['lastName'],
        'email': args['email']
      },
      options: Options(validateStatus: (status) => status! < 500),
    );
    return RegisterResponse.fromResponse(response);
  },
  'resetPassword': (Map<String, dynamic> args) async {
    Response response = await _dio.post(
      "$apiBaseUrl/moses/password/reset/",
      data: args['email'] == null
          ? {'phone_number.dart': args['phoneNumber']}
          : {'email': args['email']},
      options: Options(validateStatus: (status) => status! < 500),
    );
    return PasswordResetResponse.fromResponse(response);
  },
  'getAuthenticatedUserData': (Map<String, dynamic> args) async {
    return UserDataResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/moses/users/me/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer ${args['accessToken']}'}),
    ));
  },
  'getProfileByPhoneOrEmail': (Map<String, dynamic> args) async {
    return UserDataResponse.fromResponse(await _dio.get(
        "$apiBaseUrl/moses/get_by_phone_or_email/?value=${Uri.encodeComponent(args['value'])}",
        options: Options(
            validateStatus: (status) => status! < 500,
            headers: {'Authorization': 'Bearer ${args["accessToken"]}'})));
  },
  'updateProfile': (Map<String, dynamic> args) async {
    return UserDataResponse.fromResponse(await _dio.patch(
      "$apiBaseUrl/moses/users/me/",
      data: {"phone_number.dart": args['phoneNumber'], "email": args['email']},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer ${args['accessToken']}'}),
    ));
  },
  'confirmEmail': (Map<String, dynamic> args) async {
    return ConfirmEmailResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/moses/confirm_email/",
      data: {
        "pin": args['emailPin'],
        "candidate_pin": args['emailCandidatePin']
      },
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer ${args['accessToken']}'}),
    ));
  },
  'addMenuSectionEntryToFavorites': (Map<String, dynamic> args) async {
    return AddMenuSectionEntryToFavoritesResponse.fromResponse(
        await _dio.post("$apiBaseUrl/catalogue/menusectionentrieslistentry/",
            data: {
              "menu_section_entry_id": args['menuSectionEntryId'],
              "menu_section_entries_list": args['menuSectionEntriesListId']
            },
            options: Options(
              validateStatus: (status) => status! < 500,
              headers: {'Authorization': 'Bearer ${args['accessToken']}'},
            )));
  },
  'removeFavoritesEntry': (Map<String, dynamic> args) async {
    return RemoveMenuSectionEntryFromFavoritesResponse.fromResponse(
        await _dio.delete(
            "$apiBaseUrl/catalogue/menusectionentrieslistentry/${args['menuSectionEntriesListEntryId']}/",
            options: Options(
              validateStatus: (status) => status! < 500,
              headers: {'Authorization': 'Bearer ${args['accessToken']}'},
            )));
  },
  'confirmPhoneNumber': (Map<String, dynamic> args) async {
    return ConfirmPhoneNumberResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/moses/confirm_phone_number/",
      data: {
        "pin": args['emailPin'],
        "candidate_pin": args['emailCandidatePin']
      },
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer ${args['accessToken']}'}),
    ));
  },
  'updatePassword': (Map<String, dynamic> args) async {
    return UpdatePasswordResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/moses/password/",
      data: {
        "current_password": args['oldPassword'],
        "new_password": args['newPassword']
      },
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer ${args['accessToken']}'}),
    ));
  },
  'setMFAEnabled': (Map<String, dynamic> args) async {
    return MFASwitchResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/moses/mfa/",
      data: {"action": args['action'], "mfa_secret_key": args['secretKey']},
      options: Options(validateStatus: (status) => status! < 500, headers: {
        'Authorization': 'Bearer ${args['accessToken']}',
        'OTP': args['otp']
      }),
    ));
  },
  'getCompany': (Map<String, dynamic> args) async {
    return CompanyResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/company/company/${args['companyId']}",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer ${args['accessToken']}'}),
    ));
  },
  'getMarketplaceRootMenuSection': (Map<String, dynamic> args) async {
    String url =
        "$apiBaseUrl/catalogue/menusection/for_marketplace/?marketplace=${args['marketplaceId']}";
    if (args['companyId'] != null) {
      url += "&company=${args['companyId']}";
    }
    return MenuSectionResponse.fromResponse(await _dio.get(
      url,
      options: Options(validateStatus: (status) => status! < 500),
    ));
  },
  'getOrders': (Map<String, dynamic> args) async {
    return OrdersListResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/trade/order/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer ${args['accessToken']}'}),
    ));
  },
  'createOrder': (Map<String, dynamic> args) async {
    return OrderCreateResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/trade/order/",
      data: {
        "order_entries": args['entries'],
        "promocodes": args['promocodes'],
      },
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer ${args['accessToken']}'}),
    ));
  },
  'rateOfferMap': (Map<String, dynamic> args) async {
    return OrderCreateResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/trade/offerrating/",
      data: {"offer": args['offerId'], "value": args['value']},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer ${args['accessToken']}'}),
    ));
  },
  'getTransactions': (Map<String, dynamic> args) async {
    return TransactionsResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/logistics/transaction/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer ${args['accessToken']}'}),
    ));
  },
  'createTransaction': (Map<String, dynamic> args) async {
    Map<String, dynamic> data = {
      "source": args['sourceNode'],
      "target": args['targetNode'],
      if (args['orderEntry'] != null) "order_entry": args['orderEntry'],
      if (args['orderEntryToPayFor'] != null)
        "order_entry_to_pay_for": args['orderEntryToPayFor'],
      if (args['orderEntryToCompensateFor'] != null)
        "order_entry_to_compensate_for": args['orderEntryToCompensateFor'],
      "entries": args['transactionEntries'],
      "extra_data": args['extraData'],
      "external_ledger_transactions": args['externalLedgerTransactions'],
      "pipelines": args['pipelineIds'],
    };

    return TransactionCreateResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/logistics/transaction/",
      data: data,
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer ${args['accessToken']}'}),
    ));
  },
  'getNodes': (Map<String, dynamic> args) async {
    return NodesListResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/logistics/transactionnode/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer ${args['accessToken']}'}),
    ));
  },
  'getMenuSectionEntries': (Map<String, dynamic> args) async {
    Map<String, String> queryParams = {};
    if (args['menuSectionEntriesListId'] != null) {
      queryParams['menu_section_entries_list'] =
          args['menuSectionEntriesListId'];
    }
    if (args['menuSectionId'] != null) {
      queryParams['menu_section'] = args['menuSectionId'];
    }
    if (args['searchQuery'] != null) {
      queryParams['q'] = args['searchQuery'];
    }
    Map<String, String> headers = {};
    if (args['accessToken'] != null) {
      headers['Authorization'] = 'Bearer ${args['accessToken']}';
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
