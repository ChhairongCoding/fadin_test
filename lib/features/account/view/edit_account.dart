import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/account/view/edit_account_info.dart';
import 'package:fardinexpress/features/auth/login/view/change_password_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditAccount extends StatelessWidget {
  EditAccount({Key? key}) : super(key: key);
  final AccountController _controller = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    Future<void> _deleteAccount() async {
      return await showDialog(
          context: context,
          builder: (BuildContext _) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Warning icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.warning_amber_rounded,
                          color: Colors.red, size: 40),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      'Delete Account Permanently'.tr,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    // Description
                    Text(
                      '${"This will permanently erase all your data including".tr}:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    // Bullet points
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ${"Order history".tr}'),
                        Text('• ${"Saved addresses".tr}'),
                        Text('• ${"Payment methods".tr}'),
                        Text('• ${"Account information".tr}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Warning text
                    Text(
                      '${"This action cannot be undone".tr}.',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey[800]!),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'cancel'.tr,
                              style: TextStyle(color: Colors.grey[800]),
                            ), // Cancel in Khmer
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              // Add deletion logic here
                              Navigator.of(context).pop();
                              _controller.toDeactivateAccount(context);
                            },
                            child: Text(
                              'deleteAccount'.tr,
                              maxLines: 1,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ), // Delete in Khmer
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );

            // AlertDialog(
            //   title: const Text('Alert !'),
            //   content: Text("${'aUSureToDeleteAccount'.tr}"),
            //   actions: <Widget>[
            //     TextButton(
            //       onPressed: () {
            //         // print("you choose no");
            //         Navigator.of(context).pop();
            //       },
            //       child: const Text('No', style: TextStyle(color: Colors.blue)),
            //     ),
            //     TextButton(
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //         _controller.toDeactivateAccount(context);
            //       },
            //       child: const Text(
            //         'Yes',
            //         style: TextStyle(color: Colors.red),
            //       ),
            //     ),
            //   ],
            // );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("manageAccount".tr),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).primaryColor),
                child: Icon(Icons.edit_outlined, color: Colors.white),
              ),
              title: Text("editProfile".tr),
              // subtitle: Text("All products that you have saved"),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                size: 30.0,
              ),
              onTap: () => Get.to(() => EditAccountInfo()),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).primaryColor),
                child: Icon(Icons.vpn_key_outlined, color: Colors.white),
              ),
              title: Text("changePassword".tr),
              // subtitle: Text("All products that you have saved"),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                size: 30.0,
              ),
              onTap: () => Get.to(() => ChangePasswordPage()),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).colorScheme.error),
                child: Icon(Icons.person_remove_alt_1_outlined,
                    color: Colors.white),
              ),
              title: Text(
                "deleteAccount".tr,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () => _deleteAccount(),
            ),
          ],
        ),
      ),
    );
  }
}
