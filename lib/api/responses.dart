
import 'dart:collection';

import 'package:dio/dio.dart';

import '../models/auth/user.dart';
import '../models/catalogue/menu_section.dart';
import '../models/catalogue/menu_section_entry.dart';
import '../models/company/company.dart';
import '../models/logistics/node.dart';
import '../models/logistics/transaction.dart';
import '../models/trade/order.dart';

class GenericResponse {
  late int statusCode;

  GenericResponse(this.statusCode);

  GenericResponse.fromResponse(Response response) {
    statusCode = response.statusCode!;
  }
}

class TokenRefreshResponse extends GenericResponse {
  late final String? refreshedAccessToken;

  TokenRefreshResponse(statusCode, this.refreshedAccessToken)
      : super(statusCode);

  TokenRefreshResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! == 200) {
      refreshedAccessToken = response.data['access'];
    }
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
}

class RegisterResponse extends GenericResponse {
  late HashMap<String, String> validationErrors;

  RegisterResponse(statusCode, this.validationErrors) : super(statusCode);

  RegisterResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! >= 400) {
      validationErrors = HashMap.from(response.data
          .map((key, value) => MapEntry(key.toString(), value?[0].toString())));
    }
  }
}

class PasswordResetResponse extends GenericResponse {
  late String? validationError;

  PasswordResetResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! >= 400) {
      validationError = response.data["non_field_errors"][0];
    }
  }
}

class ConfirmEmailResponse extends GenericResponse {
  late final String? validationError;

  ConfirmEmailResponse(statusCode, this.validationError) : super(statusCode);

  ConfirmEmailResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! >= 400) {
      validationError = "Invalid Pin";
    }
  }
}

class OtpStatusResponse extends GenericResponse {
  late final bool isOtpEnabled;

  OtpStatusResponse(statusCode, this.isOtpEnabled) : super(statusCode);

  OtpStatusResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    isOtpEnabled = response.data['result'];
  }
}

class ConfirmPhoneNumberResponse extends GenericResponse {
  late final String? validationError;

  ConfirmPhoneNumberResponse(statusCode, this.validationError)
      : super(statusCode);

  ConfirmPhoneNumberResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! >= 400) {
      validationError = "Invalid Pin";
    }
  }
}

class UpdatePasswordResponse extends GenericResponse {
  late final String? validationError;

  UpdatePasswordResponse(statusCode, this.validationError) : super(statusCode);

  UpdatePasswordResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! >= 400) {
      validationError = "Invalid password";
    }
  }
}

class UserDataResponse extends GenericResponse {
  late User? user;
  String? validationError;

  UserDataResponse(statusCode, this.user) : super(statusCode);

  UserDataResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! < 300) {
      user = User.fromJson(response.data);
    } else {
      validationError = response.toString();
    }
  }
}

class NodesListResponse extends GenericResponse {
  List<Node> nodes = [];

  NodesListResponse(statusCode, this.nodes) : super(statusCode);

  NodesListResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    List<Node> nodes = [];
    if (response.statusCode == 200) {
      response.data.forEach((entry) => nodes.add(Node.fromJson(entry)));
    }
    this.nodes = nodes;
  }
}

class MenuSectionEntriesResponse extends GenericResponse {
  List<MenuSectionEntry> menuSectionEntries = [];

  MenuSectionEntriesResponse(statusCode, this.menuSectionEntries)
      : super(statusCode);

  MenuSectionEntriesResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    List<MenuSectionEntry> menuSectionEntries = [];
    if (response.statusCode == 200) {
      response.data['results'].forEach(
          (entry) => menuSectionEntries.add(MenuSectionEntry.fromJson(entry)));
    }
    this.menuSectionEntries = menuSectionEntries;
  }
}

class OrdersListResponse extends GenericResponse {
  List<Order> orders = [];

  OrdersListResponse(statusCode, this.orders) : super(statusCode);

  OrdersListResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    List<Order> orders = [];
    if (response.statusCode == 200) {
      response.data.forEach((order) => orders.add(Order.fromJson(order)));
    }
    this.orders = orders;
  }
}

class AddMenuSectionEntryToFavoritesResponse extends GenericResponse {
  String? menuSectionEntriesListEntryId;
  Map<String, dynamic>? validationError;

  AddMenuSectionEntryToFavoritesResponse(
      statusCode, this.menuSectionEntriesListEntryId, this.validationError)
      : super(statusCode);

  AddMenuSectionEntryToFavoritesResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode == 201) {
      menuSectionEntriesListEntryId = response.data['id'];
    } else {
      validationError = response.data;
    }
  }
}

class RemoveMenuSectionEntryFromFavoritesResponse extends GenericResponse {
  Map<String, dynamic>? validationError;

  RemoveMenuSectionEntryFromFavoritesResponse(statusCode, this.validationError) : super(statusCode);

  RemoveMenuSectionEntryFromFavoritesResponse.fromResponse(Response response)
      : super.fromResponse(response);
}

class OrderCreateResponse extends GenericResponse {
  Order? order;
  Map<String, dynamic>? validationError;

  OrderCreateResponse(statusCode, this.order, this.validationError)
      : super(statusCode);

  OrderCreateResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode == 201) {
      order = Order.fromJson(response.data);
    } else {
      validationError = response.data;
    }
  }
}

class MFASwitchResponse extends GenericResponse {
  late final String? validationError;
  late final String? mfaUrl;
  late final String? secretKey;

  MFASwitchResponse(statusCode, this.validationError) : super(statusCode);

  MFASwitchResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! >= 400) {
      validationError = "some error";
    }
    mfaUrl = response.data['mfa_url'];
    secretKey = response.data['mfa_secret_key'];
  }
}

class CompanyResponse extends GenericResponse {
  Company? company;

  CompanyResponse(statusCode, this.company) : super(statusCode);

  CompanyResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode == 200) {
      company = Company.fromJson(response.data);
    }
  }
}

class TransactionsResponse extends GenericResponse {
  List<Transaction>? transactions;
  String? validationError;

  TransactionsResponse(statusCode, this.transactions, this.validationError)
      : super(statusCode);

  TransactionsResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode == 200) {
      transactions = (response.data as List<dynamic>)
          .map((offer) => Transaction.fromJson(offer))
          .toList();
    } else {
      validationError = response.data.toString();
    }
  }
}

class TransactionCreateResponse extends GenericResponse {
  Transaction? transaction;
  Map<String, dynamic>? validationError;

  TransactionCreateResponse(statusCode, this.transaction, this.validationError)
      : super(statusCode);

  TransactionCreateResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode == 201) {
      transaction = Transaction.fromJson(response.data);
    } else {
      validationError = response.data;
    }
  }
}

class MenuSectionResponse extends GenericResponse {
  late MenuSection menuSection;
  String? validationError;

  MenuSectionResponse(statusCode, this.menuSection, this.validationError)
      : super(statusCode);

  MenuSectionResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    menuSection = MenuSection.fromJson(response.data, parent: null);
  }
}