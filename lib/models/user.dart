class User {
  const User(this.uid, this.name, this.email, this.imageUrl, this.isLogin);

  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final bool isLogin;

  toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "imageUrl": imageUrl,
    };
  }
}
