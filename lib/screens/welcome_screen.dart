import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              // App Icon
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.eco,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // App Name
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Harvest',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 36,
                            letterSpacing: -0.5,
                          ),
                    ),
                    TextSpan(
                      text: 'Box',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 36,
                            color: AppTheme.primaryGreen,
                            letterSpacing: -0.5,
                          ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Tagline
              Text(
                'Freshness delivered from\nthe farm to your doorstep',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 15,
                      height: 1.5,
                    ),
              ),
              
              const Spacer(flex: 2),
              
              // Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIndicator(true),
                  const SizedBox(width: 8),
                  _buildIndicator(false),
                  const SizedBox(width: 8),
                  _buildIndicator(false),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Get Started Button
              CustomButton(
                text: 'Get Started',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                  );
                },
              ),
              
              const SizedBox(height: 20),
              
              // Already Have Account
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Text(
                  'I already have an account',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryGreen : AppTheme.primaryGreen.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
