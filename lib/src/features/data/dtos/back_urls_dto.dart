class MPBackURLSDTO {
  final String? success;
  final String? failure;
  final String? pending;

  const MPBackURLSDTO({this.success, this.failure, this.pending});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};

    if (success != null) json["success"] = success;
    if (failure != null) json["failure"] = failure;
    if (pending != null) json["pending"] = pending;

    return json;
  }
}
