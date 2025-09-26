import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:fardinexpress/shared/bloc/file_pickup/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:fardinexpress/utils/helper/helper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditAccountInfo extends StatefulWidget {
  @override
  State<EditAccountInfo> createState() => _EditAccountInfoState();
}

class _EditAccountInfoState extends State<EditAccountInfo> {
  final _formKey = GlobalKey<FormState>();
  FilePickupBloc? _filePickupBloc;

  AccountController _controller =
      Get.put(AccountController(), tag: "eidtAccount");

  TextEditingController _nameCtl = TextEditingController();

  TextEditingController _addressCtl = TextEditingController();

  TextEditingController _bankNumber = TextEditingController();

  TextEditingController _phoneNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filePickupBloc = FilePickupBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined),
          ),
          // brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Container();
        } else {
          _nameCtl.text = _controller.accountInfo.name;
          _addressCtl.text = _controller.accountInfo.address.description;
          _bankNumber.text =
              _controller.accountInfo.bankNumber.toString() == "null"
                  ? ""
                  : _controller.accountInfo.bankNumber.toString();
          _phoneNumber.text = _controller.accountInfo.phone;
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  // SizedBox(height: 20),
                  Text(
                    "Edit Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                    textScaleFactor: 2,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 4),
                          ),
                          margin: EdgeInsets.only(
                              left: Get.width * 0.2,
                              right: Get.width * 0.2,
                              top: 20),
                          child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: BlocBuilder(
                                bloc: _filePickupBloc,
                                builder: (context, dynamic state) {
                                  return FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: (state == null)
                                        ? CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                              '${_controller.accountInfo.profilePic}', // Replace with your image URL
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 50,
                                            backgroundImage:
                                                Image.file(state).image),
                                  );
                                },
                              )),
                        ),
                        Positioned(
                          bottom: 100,
                          right: 90,
                          child: GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.green,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "name".tr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold),
                              textScaler: TextScaler.linear(1.2),
                            ),
                            SizedBox(height: 6),
                            TextFormField(
                              controller: _nameCtl,
                              keyboardType: TextInputType.text,
                              // decoration: InputDecoration(labelText: "name"),
                              decoration: InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey[900], // Dark field background
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "please Input";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),
                            Text(
                              "address".tr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold),
                              textScaler: TextScaler.linear(1.2),
                            ),
                            SizedBox(height: 6),
                            TextFormField(
                              controller: _addressCtl,
                              keyboardType: TextInputType.text,
                              // decoration: InputDecoration(labelText: "address"),
                              decoration: InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey[900], // Dark field background
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "required".tr;
                                }
                                return null;
                              },
                              // obscureText: true,
                            ),
                            SizedBox(height: 14),
                            Text(
                              "remark".tr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold),
                              textScaler: TextScaler.linear(1.2),
                            ),
                            SizedBox(height: 6),
                            TextFormField(
                              // enabled: false,
                              controller: _bankNumber,
                              keyboardType: TextInputType.text,
                              // decoration:
                              //     InputDecoration(labelText: "Account Number"),
                              decoration: InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey[900], // Dark field background
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return "required".tr;
                              //   }
                              //   return null;
                              // },
                              // obscureText: true,
                            ),
                            SizedBox(height: 14),
                            Text(
                              "phone".tr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold),
                              textScaler: TextScaler.linear(1.2),
                            ),
                            SizedBox(height: 6),
                            TextFormField(
                              enabled: false,
                              controller: _phoneNumber,
                              keyboardType: TextInputType.text,
                              // decoration:
                              //     InputDecoration(labelText: "Account Number"),
                              decoration: InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey[900], // Dark field background
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return "required".tr;
                              //   }
                              //   return null;
                              // },
                              // obscureText: true,
                            ),
                            // SizedBox(height: 5),
                            SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          standardBorderRadius),
                                    ),
                                  ),
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius:
                                  //       BorderRadius.circular(standardBorderRadius),
                                  // ),
                                  // color: Theme.of(context).primaryColor,
                                  // padding: EdgeInsets.symmetric(vertical: 15),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _controller.toEditAccount(
                                          _nameCtl.text,
                                          _addressCtl.text,
                                          _bankNumber.text,
                                          _filePickupBloc!.state);
                                    }
                                  },
                                  child: Text(
                                    "Submit",
                                    // textScaleFactor: 1.2,
                                    textScaler: TextScaler.linear(1.2),
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ])),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              height: 150.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library_outlined,
                        color: Colors.blue,
                      ),
                      title: new Text(
                        'Photo Library',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Helper.imgFromGallery((image) {
                          _filePickupBloc!.add(image);
                        });
                        Navigator.of(context).pop();
                      }),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 0.5,
                      )),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera, color: Colors.red),
                    title: new Text(
                      'Camera',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Helper.imgFromCamera((image) {
                        _filePickupBloc!.add(image);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _filePickupBloc!.close();
    super.dispose();
  }
}
