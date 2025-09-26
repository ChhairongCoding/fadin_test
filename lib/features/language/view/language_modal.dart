import 'package:fardinexpress/features/language/model/app_localization.dart';
import 'package:flutter/cupertino.dart';

languageModal(context) {
  List options = [
    {"name": "ខ្មែរ", "code": "Language.KM"},
    {"name": "English", "code": "Language.EN"},
    {"name": "中文", "code": "Language.CHS"},
  ];
  int index = 0;

  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xff999999),
                  width: 0.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CupertinoButton(
                  child: Text(
                    "Cancel",
                    // AppLocalizations.of(context)!.translate("cancel")!,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ),
                ),
                CupertinoButton(
                  child: Text(
                    "Confirm",
                    // AppLocalizations.of(context)!.translate("confirm")!,
                  ),
                  onPressed: () {
                    if (options[index]["code"] == "Language.KM") {
                      var locale = Locale('km', 'KH');
                      AppLocalization.changeLocale("km");
                    } else if (options[index]["code"] == "Language.EN") {
                      var locale = Locale('en', 'US');
                      AppLocalization.changeLocale("en");
                      // Get.updateLocale(locale);
                    } else {
                      var locale = Locale('zh', 'CHS');
                      // Get.updateLocale(locale);
                      AppLocalization.changeLocale("zh");
                    }
                    Navigator.of(context).pop();
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ),
                )
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height / 3,
              color: Color(0xfff7f7f7),
              child: CupertinoPicker(
                itemExtent: 50,
                children: options
                    .map((option) => Center(
                          child: Text(option["name"]),
                        ))
                    .toList(),
                onSelectedItemChanged: (indexx) {
                  index = indexx;
                },
              ))
        ],
      );
    },
  );
}
