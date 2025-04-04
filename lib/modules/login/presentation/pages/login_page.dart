import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:online_training_template/app/utils/errors.dart';
import 'package:online_training_template/modules/home/presentation/pages/home_page.dart';
import 'package:online_training_template/ui/color_helper.dart';
import 'package:online_training_template/ui/controllers/theme_controller.dart';
import 'package:online_training_template/ui/routes/app_pages.dart';
import 'package:online_training_template/ui/styles.dart';
import 'package:online_training_template/ui/text_styles.dart';
import 'package:online_training_template/viewmodel/auth_viewmodel.dart';
import 'package:online_training_template/widgets/custom_text_filed.dart';

import '../../../../generated/l10n.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Get.find<ThemeController>().setThemeData(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));

    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
          data: (data) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
              (_) => false,
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
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorHelper.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top space and theme toggle button
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(Insets.l),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Get.find<ThemeController>().toggleTheme();
                      setState(() {});
                    },
                    child: Obx(
                      () => Icon(
                          Get.find<ThemeController>().currentThemeMode.value ==
                                  ThemeMode.dark
                              ? Icons.light_mode
                              : Icons.dark_mode),
                    ),
                  ),
                ),
              ),
            ),

            // Main content
            Expanded(
              flex: 9,
              child: buildCard(size),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        color: ColorHelper.bgColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              S.of(context).loginAccount,
              style: AppTextStyles.headline,
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              S.of(context).discoverYourSocialTryToLogin,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.04),

            // Title
            richText(24),
            SizedBox(height: size.height * 0.05),

            // Phone & password input fields
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                ],
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(height: size.height * 0.03),

            // Sign-in button
            signInButton(size),
            SizedBox(height: size.height * 0.04),

            // Sign-up text
            footerText(),
          ],
        ),
      ),
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: AppTextStyles.display1,
        children: [
          TextSpan(
            text: S.of(context).login,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(
            text: S.of(context).page,
            style: TextStyle(
              color: ColorHelper.secondaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget signInButton(Size size) {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          await ref.read(authViewModelProvider.notifier).loginUser(
                phone: _phoneController.text.trim(),
                password: _passwordController.text.trim(),
              );
        } else {
          showSnackBar(context, 'Missing fields!');
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height / 11,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: ColorHelper.primaryColor,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C2E84).withOpacity(0.2),
              offset: const Offset(0, 15.0),
              blurRadius: 60.0,
            ),
          ],
        ),
        child: Text(
          S.of(context).signIn,
          style: AppTextStyles.body2FixedLightColor,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget footerText() {
    return InkWell(
      onTap: () {
        Get.offNamed(Routes.signupPage);
      },
      child: Text.rich(
        TextSpan(
          style: AppTextStyles.body1,
          children: [
            TextSpan(text: S.of(context).dontHaveAnAccount),
            TextSpan(
              text: ' ${S.of(context).signUp}',
              style: TextStyle(
                color: ColorHelper.secondaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
