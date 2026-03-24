import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvestbox_restaurant_app/widgets/custom_text_field.dart';
import 'package:harvestbox_restaurant_app/widgets/custom_button.dart';
import 'package:harvestbox_restaurant_app/theme/app_theme.dart';

void main() {
  // Helper to build a testable widget
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }

  group('Login Form - Email Validation', () {
    testWidgets('should show email text field', (WidgetTester tester) async {
      final emailController = TextEditingController();

      await tester.pumpWidget(buildTestWidget(
        CustomTextField(
          label: 'Email or Phone Number',
          hint: 'Enter your email or phone',
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
      ));

      // Verify label is displayed
      expect(find.text('Email or Phone Number'), findsOneWidget);

      // Verify hint text
      expect(find.text('Enter your email or phone'), findsOneWidget);
    });

    testWidgets('should accept email input', (WidgetTester tester) async {
      final emailController = TextEditingController();

      await tester.pumpWidget(buildTestWidget(
        CustomTextField(
          label: 'Email or Phone Number',
          hint: 'Enter your email or phone',
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
      ));

      // Enter email
      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.pump();

      expect(emailController.text, 'test@example.com');
    });

    testWidgets('email field should be empty initially',
        (WidgetTester tester) async {
      final emailController = TextEditingController();

      await tester.pumpWidget(buildTestWidget(
        CustomTextField(
          label: 'Email or Phone Number',
          hint: 'Enter your email or phone',
          controller: emailController,
        ),
      ));

      expect(emailController.text, isEmpty);
    });
  });

  group('Login Form - Password Validation', () {
    testWidgets('should show password field with obscured text',
        (WidgetTester tester) async {
      final passwordController = TextEditingController();

      await tester.pumpWidget(buildTestWidget(
        CustomTextField(
          label: 'Password',
          hint: 'Enter your password',
          isPassword: true,
          controller: passwordController,
        ),
      ));

      // Verify label
      expect(find.text('Password'), findsOneWidget);

      // Verify the TextField has obscureText set
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
    });

    testWidgets('should toggle password visibility',
        (WidgetTester tester) async {
      final passwordController = TextEditingController();

      await tester.pumpWidget(buildTestWidget(
        CustomTextField(
          label: 'Password',
          hint: 'Enter your password',
          isPassword: true,
          controller: passwordController,
        ),
      ));

      // Initially password is obscured
      TextField textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);

      // Tap the visibility toggle button
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Password should now be visible
      textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, false);
    });

    testWidgets('should accept password input', (WidgetTester tester) async {
      final passwordController = TextEditingController();

      await tester.pumpWidget(buildTestWidget(
        CustomTextField(
          label: 'Password',
          hint: 'Enter your password',
          isPassword: true,
          controller: passwordController,
        ),
      ));

      await tester.enterText(find.byType(TextField), 'MySecurePass123');
      await tester.pump();

      expect(passwordController.text, 'MySecurePass123');
    });
  });

  group('Login Form - Button', () {
    testWidgets('should render Sign In button', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(buildTestWidget(
        CustomButton(
          text: 'Sign In',
          onPressed: () => wasPressed = true,
        ),
      ));

      expect(find.text('Sign In'), findsOneWidget);

      // Tap the button
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(wasPressed, true);
    });

    testWidgets('button should be disabled when onPressed is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        const CustomButton(
          text: 'Sign In',
          onPressed: null,
        ),
      ));

      // Find the ElevatedButton inside CustomButton
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });

  group('Login Form - Complete Form', () {
    testWidgets('should render complete login form layout',
        (WidgetTester tester) async {
      final emailController = TextEditingController();
      final passwordController = TextEditingController();

      await tester.pumpWidget(buildTestWidget(
        Column(
          children: [
            CustomTextField(
              label: 'Email or Phone Number',
              hint: 'Enter your email or phone',
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Password',
              hint: 'Enter your password',
              isPassword: true,
              controller: passwordController,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Sign In',
              onPressed: () {},
            ),
          ],
        ),
      ));

      // All form elements should be present
      expect(find.text('Email or Phone Number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);

      // Fill in the form
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'user@harvestbox.com');
      await tester.enterText(textFields.last, 'password123');
      await tester.pump();

      expect(emailController.text, 'user@harvestbox.com');
      expect(passwordController.text, 'password123');
    });
  });
}
