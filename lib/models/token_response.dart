

 class TokenResponse {
  String status;
  String message;
  String cftoken;
  TokenResponse({this.status,this.message,this.cftoken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
        status: json['status'],
        message: json['message'],
        cftoken:json['cftoken']
    );
  }
}