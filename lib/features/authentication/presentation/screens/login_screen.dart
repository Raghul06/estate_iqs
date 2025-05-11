import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';

import '../providers/login_notifier.dart';

/// A production-ready Login Screen that integrates Firebase Auth via LoginNotifier.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Use Future.microtask to safely access ref in initState.
    Future.microtask(() {

    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Trigger email/password login via LoginNotifier.
  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      ref.read(loginNotifierProvider.notifier)
          .loginWithEmail(email, password);
    }
  }

  /// (Optional) Trigger Google Sign-In flow.
  void _onGoogleSignInPressed() {
    ref.read(loginNotifierProvider.notifier).loginWithGoogle();
  }

  /// Navigate to Forgot Password Screen.
  void _onForgotPassword() {
    context.go('/forgot_password');
  }

  /// Navigate to Sign Up Screen.
  void _onSignUp() {
    context.go('/signup');
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifierProvider);
    ref.listen<LoginState>(loginNotifierProvider, (previous, state) {
      if (state.status == LoginStatus.success) {
        // Navigate to home/dashboard upon successful login.
        context.go('/home');
      } else if (state.status == LoginStatus.error) {
        // Show error message via SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage)),
        );
      }
    });
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 5.h),
                // App Title
                Center(
                  child: Image.asset("assets/icons/Fade_Blade_logo.png",width: 75.w,height: 30.w,),
                ),
                SizedBox(height: 3.h),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _onForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.sp,
                          color: const Color(0xFF8B4513)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 7.h,
                  child: ElevatedButton(
                    onPressed: loginState.status == LoginStatus.loading
                        ? null
                        : _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: loginState.status == LoginStatus.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                // Google Sign-In Button (Optional)
                SizedBox(
                  width: double.infinity,
                  height: 7.h,
                  child: OutlinedButton(
                    onPressed: loginState.status == LoginStatus.loading
                        ? null
                        : _onGoogleSignInPressed,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF8B4513)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16.sp,
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: _onSignUp,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14.sp,
                          color: const Color(0xFF8B4513),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
