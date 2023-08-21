import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buyer/l10n/local_provider.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  final _sideTopPadding = Constants.sideTopPadding;

  Locale _locale = const Locale("en");
  bool dumyFirstLocale = true;
  @override
  Widget build(BuildContext context) {
    final changeLanguage = Provider.of<LocalProvider>(context);
    if (dumyFirstLocale) {
      dumyFirstLocale = false;
      _locale = changeLanguage.locale;
    }
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: _sideTopPadding,
          child: Column(
            children: [
              Padding(
                padding: _sideTopPadding,
                child: Text(
                  AppLocalizations.of(context)!.selectYourLanguage,
                  // "Select Your Language",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: RadioListTile(
                  title: const Text("English"),
                  value: const Locale("en"),
                  groupValue: _locale,
                  onChanged: (value) {
                    setState(() {
                      _locale = const Locale("en");
                    });
                  },
                ),
              ),
              RadioListTile(
                title: const Text("ಕನ್ನಡ"),
                value: const Locale("kn"),
                groupValue: _locale,
                onChanged: (value) {
                  setState(() {
                    _locale = const Locale("kn");
                  });
                },
              ),
              // Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 34.0),
                child: SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          changeLanguage.setLocal(_locale);
                          setState(() {});
                        },
                        child: const Text("Submit Language"))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
