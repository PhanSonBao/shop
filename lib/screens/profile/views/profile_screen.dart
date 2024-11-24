import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/components/list_tile/divider_list_tile.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/models/user_model.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          logInScreenRoute,
          (route) => false, // Remove all previous routes from the stack
        );
      }
    }
  }

  Future<void> _changePassword(BuildContext context) async {}

  Future<void> _logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        logInScreenRoute,
        (route) => false, // Remove all previous routes from the stack
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("Vui lòng đăng nhập."),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Không tìm thấy thông tin người dùng."),
            );
          }

          final user = UserModel.fromfirestore(snapshot.data!);
          return ListView(
            children: [
              ProfileCard(
                name: user.name,
                email: user.email,
                imageSrc: user.avatar,
                press: () {
                  Navigator.pushNamed(
                    context,
                    userInfoScreenRoute,
                    arguments: user.uid,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  "Tài khoản",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: defaultPadding / 2),
              ProfileMenuListTile(
                text: "Đơn hàng",
                svgSrc: "assets/icons/Order.svg",
                press: () {
                  Navigator.pushNamed(context, ordersScreenRoute);
                },
              ),
              ProfileMenuListTile(
                text: "Trả hàng",
                svgSrc: "assets/icons/Return.svg",
                press: () {},
              ),
              ProfileMenuListTile(
                text: "Địa chỉ",
                svgSrc: "assets/icons/Address.svg",
                press: () {
                  Navigator.pushNamed(context, addressesScreenRoute);
                },
              ),
              ProfileMenuListTile(
                text: "Ví",
                svgSrc: "assets/icons/Wallet.svg",
                press: () {
                  Navigator.pushNamed(context, walletScreenRoute);
                },
              ),
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 2),
                child: Text(
                  "Cá nhân",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              DividerListTileWithTrilingText(
                svgSrc: "assets/icons/Notification.svg",
                title: "Thông báo",
                trilingText: "Off",
                press: () {
                  Navigator.pushNamed(context, enableNotificationScreenRoute);
                },
              ),
              ProfileMenuListTile(
                text: "Preferences",
                svgSrc: "assets/icons/Preferences.svg",
                press: () {
                  Navigator.pushNamed(context, preferencesScreenRoute);
                },
              ),
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 2),
                child: Text(
                  "Cài đặt",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ProfileMenuListTile(
                text: "Ngôn ngữ",
                svgSrc: "assets/icons/Language.svg",
                press: () {
                  Navigator.pushNamed(context, selectLanguageScreenRoute);
                },
              ),
              ProfileMenuListTile(
                text: "Location",
                svgSrc: "assets/icons/Location.svg",
                press: () {},
              ),
              ProfileMenuListTile(
                text: "Đổi mật khẩu",
                svgSrc: "assets/icons/Lock.svg",
                press: () => _changePassword(context),
              ),
              ListTile(
                onTap: () => _deleteAccount(context),
                minLeadingWidth: 24,
                leading: SvgPicture.asset(
                  "assets/icons/Delete.svg",
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    blackColor,
                    BlendMode.clear,
                  ),
                ),
                title: const Text(
                  "Xóa tài khoản",
                  style: TextStyle(color: blackColor, fontSize: 14, height: 1),
                ),
              ),
              ListTile(
                onTap: () => _logOut(context), // Call the log out function
                minLeadingWidth: 24,
                leading: SvgPicture.asset(
                  "assets/icons/Logout.svg",
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    errorColor,
                    BlendMode.srcIn,
                  ),
                ),
                title: const Text(
                  "Đăng xuất",
                  style: TextStyle(color: errorColor, fontSize: 14, height: 1),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
