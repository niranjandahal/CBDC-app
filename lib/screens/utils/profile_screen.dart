import 'package:cbdc/provider/userprovider.dart';
import 'package:cbdc/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(builder: (context, value, child) {
          String baseurl = value.baseurl;
          String uid = value.walletuserid;
          print(baseurl);
          if (value.email.isEmpty || value.fullName.isEmpty) {
            Future.microtask(() => PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: LoginScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                ));
            return SizedBox();
          }

          // Check KYC status
          String kycStatus = value.kycStatus;
          String userImageUrl = value.userImageurl;
          String govImageUrl = value.governmentIdImageUrl;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Show user and government images if available
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage("$baseurl/images/profile/$uid"),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),

                const SizedBox(height: 40),
                _profileField("Full Name", value.fullName),
                const SizedBox(height: 20),
                _profileField("Email", value.email),
                const SizedBox(height: 20),
                _profileField("Date of birth", value.dob),
                const SizedBox(height: 20),
                _profileField("Citizenship No", value.citizenidno),
                const SizedBox(height: 20),

                //add the images of the citizenship from internet if no image then show dummy imgages
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(
                    "$baseurl/images/government-id/$uid",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Return a dummy placeholder image if the network image fails
                      return Image.network("https://via.placeholder.com/150",
                          fit: BoxFit.cover);
                    },
                  ),
                ),

                // Check KYC status and show KYC-related UI
                if (kycStatus == "verified")
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "KYC Verified",
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      const SizedBox(height: 10),
                      // KYC verified but user still has to verify by uploading images
                      if (userImageUrl.isEmpty || govImageUrl.isEmpty)
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to KYC verification page
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Verify KYC"),
                        ),
                    ],
                  )
                else if (kycStatus == "pending")
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "KYC Pending",
                        style: TextStyle(fontSize: 16, color: Colors.orange),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to KYC verification page
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Complete KYC"),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _profileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
