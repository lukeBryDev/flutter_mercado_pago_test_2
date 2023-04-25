enum MPPaymentResultType {
  canceled,

  /// undefined
  undefined,
}

extension FromMPPaymentResultType on MPPaymentResultType {
  String? get message {
    Map<MPPaymentResultType, String> fromMPPaymentResult = {
      MPPaymentResultType.canceled: "Cancelaste tu pago",
      MPPaymentResultType.undefined: "$this",
    };
    if (fromMPPaymentResult[this] != null) {
      return fromMPPaymentResult[this];
    } else {
      return '';
    }
  }
}

extension ToMPPaymentResultType on String {
  MPPaymentResultType? get toMPPaymentResult {
    Map<String, MPPaymentResultType> fromString = {
      "canceled": MPPaymentResultType.canceled,
    };
    if (fromString[this] != null) {
      if (fromString.containsKey(this)) {
        return fromString[this];
      } else {
        return MPPaymentResultType.undefined;
      }
    } else {
      return null;
    }
  }
}
