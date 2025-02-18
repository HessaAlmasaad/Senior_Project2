import '../database/db_helper.dart';
import '../model/user.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Register a new user
  Future<String?> registerUser(User user) async {
    // Check if email already exists
    User? existingUser = await _dbHelper.getUserByEmail(user.email);
    if (existingUser != null) {
      return '⚠️ Error: This email is already registered. Please log in or reset your password.';
    }

    // Insert new user into the database
    await _dbHelper.insertUser(user);
    return '✅ Registration successful! Please check your email to verify your account.';
  }

  // Login user
  Future<String> loginUser(String email, String password, String userType) async {
    User? user = await _dbHelper.getUserByEmail(email);

    if (user == null) {
      return '❌ Error: No account found with this email. Please register first.';
    }

    if (user.password != password) {
      return '⚠️ Error: Incorrect password. Please try again or reset your password.';
    }

    if (user.userType != userType) {
      return '⚠️ Error: Account type mismatch! You selected "$userType" but your registered account is a "${user.userType}".';
    }

    return '✅ Login successful! Redirecting to your dashboard...';
  }

  // Resend verification email (Placeholder function, implement actual email logic)
  Future<String> resendVerificationEmail(String email) async {
    User? user = await _dbHelper.getUserByEmail(email);
    if (user == null) {
      return '❌ Error: No account found with this email. Please register first.';
    }

    return '✅ Verification email has been resent to $email. Please check your inbox.';
  }

  // Reset Password
  Future<String> resetPassword(String email, String newPassword) async {
    User? user = await _dbHelper.getUserByEmail(email);

    if (user == null) {
      return '❌ Error: No account found with this email. Please register first.';
    }

    user.password = newPassword;
    await _dbHelper.updateUser(user);
    return '✅ Password reset successful! You can now log in with your new password.';
  }
}
