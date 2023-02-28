class HttpExpection implements Exception {
  final String message;
  HttpExpection(this.message);

  @override
  String toString() {
    return message;
    // TODO: implement toString
    // return super.toString();
  }
}
