import 'package:cbdc/screens/utils/kycverification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<UserProvider>(
          builder: (context, user, child) {
            if (user.email.isEmpty || user.fullName.isEmpty) {
              Future.microtask(() => PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: LoginScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  ));
              return SizedBox();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                user.kycStatus == "not_submitted"
                    ? Container()
                    : _buildProfileHeader(user),
                const SizedBox(height: 20),
                _buildKYCStatus(context, user.kycStatus),
                const SizedBox(height: 20),
                _buildProfileInfo(user),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserProvider user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(
            "${user.baseurl}/images/profile/${user.walletuserid}",
          ),
          onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 60),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildKYCStatus(BuildContext context, String kycStatus) {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    VoidCallback? action;

    switch (kycStatus) {
      case "verified":
        statusColor = Colors.green;
        statusIcon = Icons.verified;
        statusText = "KYC Verified";
        action = null;
        break;
      case "pending":
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        statusText = "KYC Pending";
        action = null;
        break;
      default:
        statusColor = Colors.red;
        statusIcon = Icons.warning;
        statusText = "Verify KYC";
        action = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KycVerificationScreen()),
          );
        };
    }

    return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: statusColor, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(statusIcon, color: statusColor, size: 26),
            const SizedBox(width: 10),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(UserProvider user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _profileField("Full Name", user.fullName),
        const SizedBox(height: 20),
        _profileField("Email", user.email),
        const SizedBox(height: 20),
        user.kycStatus == "not_submitted"
            ? Container()
            : Container(
                child: Column(
                  children: [
                    _profileField("Date of Birth", user.dob),
                    const SizedBox(height: 20),
                    _profileField("Citizenship No", user.citizenidno),
                    const SizedBox(height: 20),
                    _buildGovtIDImage(user),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _profileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.isNotEmpty ? value : "Not Provided",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGovtIDImage(UserProvider user) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          "${user.baseurl}/images/government-id/${user.walletuserid}",
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.network("https://via.placeholder.com/180");
          },
        ),
      ),
    );
  }
}
