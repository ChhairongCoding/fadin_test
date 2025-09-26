import 'dart:developer';

dynamic validate(String keyName, dynamic value) {
  if (value == null) {
    log("value for key '$keyName' is not available");
    return "";
    // throw "value for key '$keyName' is not available";
  } else {
    return value!;
  }
}

// bool isArrayAvailable(String keyName, dynamic? value) {
//   if (value == null||value=="") {

//     // throw "value for key '$keyName' is not available";
//   } else {
//     return value!;
//   }
// }
