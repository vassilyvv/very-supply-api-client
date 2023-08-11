import 'dart:js' as js;
import 'dart:js_interop';
import 'dart:html';
import 'dart:convert';
import 'dart:js_util';

import 'api/client.dart';

@JS('Promise')
class Promise<T> {
  external Promise(void executor(void resolve(T result), Function reject));
  external Promise then(void onFulfilled(T result), [Function onRejected]);
}

Promise performRequest(String functionName, String jsonArgs) {
  return Promise(js.allowInterop((resolve, reject) {
    apiMethods[functionName]!(jsonDecode(jsonArgs)).then((value) {
      final jsonString = jsonEncode(value);
      resolve(jsonString);
    }).catchError((error) {
      reject(error);
    });
  }));
}

void main() {
  setProperty(window, 'perform', js.allowInterop(performRequest));
}
