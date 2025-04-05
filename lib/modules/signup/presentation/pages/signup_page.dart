import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:online_training_template/app/utils/errors.dart';
import 'package:online_training_template/modules/home/presentation/pages/home_page.dart';
import 'package:online_training_template/ui/color_helper.dart';
import 'package:online_training_template/ui/controllers/theme_controller.dart';
import 'package:online_training_template/ui/routes/app_pages.dart';
import 'package:online_training_template/ui/text_styles.dart';
import 'package:online_training_template/viewmodel/auth_viewmodel.dart';
import 'package:online_training_template/widgets/custom_elevated_button.dart';
import 'package:online_training_template/widgets/custom_text_filed.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Get.find<ThemeController>().setThemeData(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));

    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
          data: (data) {
            showSnackBar(
              context,
              'Account created successfully!',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {},
        );
      },
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorHelper.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            /// **🔹 Top Bar (Theme Toggle Button)**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Get.find<ThemeController>().toggleTheme(),
                  child: Obx(
                    () => Icon(
                      Get.find<ThemeController>().currentThemeMode.value ==
                              ThemeMode.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

            /// **🔹 Signup Form (Scrollable)**
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: ColorHelper.bgColor,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// **🔹 Title**
                        Text(
                          "Create Account",
                          style: AppTextStyles.display1.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// **🔹 Name Field**
                        CustomTextFormField(
                          controller: _nameController,
                          hintText: "Enter your Name",
                          labelText: "Name",
                          textInputAction: TextInputAction.next,
                          validator: (value) => value == null || value.isEmpty
                              ? "Name is required"
                              : null,
                        ),
                        const SizedBox(height: 20),

                        /// **🔹 Phone Field**
                        CustomTextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          hintText: "Enter your Phone No",
                          labelText: "Phone",
                          textInputAction: TextInputAction.next,
                          validator: (value) => value == null || value.isEmpty
                              ? "Phone Number is required"
                              : null,
                        ),
                        const SizedBox(height: 20),

                        /// **🔹 Password Field**
                        CustomTextFormField(
                          controller: _passwordController,
                          hintText: "Enter your password",
                          labelText: "Password",
                          obscureText: true,
                          validator: (value) => value == null || value.isEmpty
                              ? "Password is required"
                              : value.length < 6
                                  ? "Password must be at least 6 characters"
                                  : null,
                        ),
                        const SizedBox(height: 20),

                        /// **🔹 Confirm Password Field**
                        CustomTextFormField(
                          controller: _confirmPasswordController,
                          hintText: "Confirm your password",
                          labelText: "Confirm Password",
                          obscureText: true,
                          validator: (value) =>
                              value != _passwordController.text
                                  ? "Passwords do not match"
                                  : null,
                        ),
                        const SizedBox(height: 30),

                        /// **🔹 Sign Up Button**
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomElevatedButton(
                                label: "Sign Up",
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await ref
                                        .read(authViewModelProvider.notifier)
                                        .signUpUser(
                                            name: _nameController.text.trim(),
                                            phone: _phoneController.text.trim(),
                                            password:
                                                _passwordController.text.trim(),
                                            confirmPassword:
                                                _confirmPasswordController.text
                                                    .trim());
                                  } else {
                                    showSnackBar(context, 'Missing fields!');
                                  }
                                },
                              ),
                        const SizedBox(height: 20),

                        /// **🔹 Already have an account? (Login Button)**
                        Center(
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.loginPage),
                            child: RichText(
                              text: TextSpan(
                                style: AppTextStyles.body1,
                                children: [
                                  const TextSpan(
                                      text: "Already have an account? "),
                                  TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                      color: ColorHelper.secondaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
