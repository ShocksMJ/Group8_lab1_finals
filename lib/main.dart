import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  static const Color darkGreen = Color(0xFF142606);
  static const Color midGreen = Color(0xFF2A4E0C);
  static const Color limeGreen = Color(0xFFC6FF63);
  static const Color cardDark = Color(0xFF132517);
  static const Color hintGrey = Color(0xFF9E9E9E);

  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkGreen, midGreen],
  );
}


class AppRoutes {
  static const login = '/';
  static const signUp = '/signup';
  static const home = '/home';
}


class HomeArguments {
  final String name;
  const HomeArguments(this.name);
}

class AppAccount {
  static String? _email;
  static String? _password;
  static String? name;

  static void register({
    required String name,
    required String email,
    required String password,
  }) {
    AppAccount.name = name;
    _email = email.toLowerCase();
    _password = password;
  }

  static bool matches({required String email, required String password}) {
    return _email == email.trim().toLowerCase() && _password == password;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      case AppRoutes.signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpPage(),
          settings: settings,
        );

      case AppRoutes.home:
        final args = settings.arguments;
        final homeArgs = args is HomeArguments
            ? args
            : const HomeArguments('music lover');
        return MaterialPageRoute(
          builder: (_) => HomePage(name: homeArgs.name),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

// =================================================================
// SIGN UP PAGE
// =================================================================
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirm = true;
  bool _agreed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // snackbar
  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // validates form
  void _handleSignUp() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('Please fill in all fields.');
      return;
    }
    if (!email.contains('@')) {
      _showMessage('Please enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters.');
      return;
    }
    if (password != confirm) {
      _showMessage('Passwords do not match.');
      return;
    }
    if (!_agreed) {
      _showMessage('Please agree to the Terms and Conditions.');
      return;
    }

    AppAccount.register(name: name, email: email.trim(), password: password);

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.home,
      arguments: HomeArguments(name),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.hintGrey),
            prefixIcon: Icon(icon, color: AppColors.hintGrey),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: onToggle,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.white70),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: AppColors.limeGreen,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({required String label, required String iconPath}) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 20, width: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.background),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                // LOGO
                Image.asset('assets/moozz-logo.png', height: 100),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to Moozz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),


                const SizedBox(height: 32),
                _buildField(
                  label: 'Full Name',
                  hint: 'your name',
                  icon: Icons.person,
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: 'Email',
                  hint: 'email@gmail.com',
                  icon: Icons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: 'Password',
                  hint: '******',
                  icon: Icons.lock,
                  controller: _passwordController,
                  isPassword: true,
                  obscure: _hidePassword,
                  onToggle: () =>
                      setState(() => _hidePassword = !_hidePassword),
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: 'Confirm Password',
                  hint: '******',
                  icon: Icons.lock,
                  controller: _confirmController,
                  isPassword: true,
                  obscure: _hideConfirm,
                  onToggle: () => setState(() => _hideConfirm = !_hideConfirm),
                ),
                const SizedBox(height: 16),

                // terms and conditions
                Row(
                  children: [
                    Checkbox(
                      value: _agreed,
                      activeColor: AppColors.limeGreen,
                      checkColor: Colors.black,
                      side: const BorderSide(color: Colors.white),
                      onChanged: (value) =>
                          setState(() => _agreed = value ?? false),
                    ),
                    const Text(
                      'Agree to ',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'Terms and Conditions',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // SIGN UP BUTT
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.limeGreen,
                      foregroundColor: Colors.black,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Divider and social buttons
                const Divider(color: Colors.white54),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildSocialButton(
                      label: 'Google',
                      iconPath: 'assets/google-icon.png',
                    ),
                    const SizedBox(width: 24),
                    _buildSocialButton(
                      label: 'Facebook',
                      iconPath: 'assets/facebook-icon.png',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // LOGIN LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =================================================================
//                    LOGIN PAGE
// =================================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    if (AppAccount.matches(
      email: _emailController.text,
      password: _passwordController.text,
    )) {
      final name = AppAccount.name ??
          _emailController.text.trim().split('@').first;

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
        arguments: HomeArguments(name),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong email or password.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Logo
                    Image.asset(
                      'assets/loginlogo.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email Field
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.email_outlined, color: Colors.white54),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: AppColors.limeGreen),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '******',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: AppColors.limeGreen),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.limeGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Signup Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.signUp);
                          },
                          child: const Text(
                            'Signup',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Center(
          child: SizedBox(
            width: 420,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/mooz.png',
                        width: 130,
                        height: 130,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Welcome,\n$name',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 54,
                      fontWeight: FontWeight.w800,
                      height: 0.95,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'We want to learn your music taste!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        genreCard('POP', 'assets/image 22.png'),
                        const SizedBox(width: 12),
                        genreCard('ROCK', 'assets/image 23.png'),
                        const SizedBox(width: 12),
                        genreCard('EMO', 'assets/image 24.png'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Show more',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 260,
                          height: 54,
                          child: OutlinedButton(

                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.login,
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.limeGreen,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                color: AppColors.limeGreen,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget genreCard(String label, String imagePath) {
    return Container(
      width: 100,
      height: 120,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 52,
            height: 52,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}