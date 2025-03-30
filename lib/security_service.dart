class SecurityService {
  bool isAuthenticated = false;

  Future<bool> login(String pin) async {
    // Example hardcoded PIN
    if (pin == "1234") {
      isAuthenticated = true;
      return true;
    }
    return false;
  }

  void logout() {
    isAuthenticated = false;
  }

  bool get isLoggedIn => isAuthenticated;
}
