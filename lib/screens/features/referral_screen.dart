import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rewardly/providers/referral_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refer & Earn'),
      ),
      body: Consumer<ReferralProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildReferralCodeCard(context, provider.referralCode),
                const SizedBox(height: 30),
                _buildActionButtons(context, provider.referralCode),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReferralCodeCard(BuildContext context, String referralCode) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Your Referral Code',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text(
              referralCode,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String referralCode) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: referralCode));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Referral code copied!')),
            );
          },
          icon: const Icon(Icons.copy),
          label: const Text('Copy Code'),
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            // ignore: deprecated_member_use
            Share.share(
                'Join Rewardly and earn rewards! Use my referral code: $referralCode');
          },
          icon: const Icon(Icons.share),
          label: const Text('Share Code'),
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
