import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mk_tv_app/model/SettingModel.dart';
import 'package:mk_tv_app/routes.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //to change the button text to progress indicator after the user pressed the [LOGIN] button
  bool _authenticating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 50),
          Consumer<SettingModel>(
            builder: (context, value, child) => SwitchListTile.adaptive(
                title: const Text(
                  "Dark Mode",
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: value.darkMode ? const Text("On") : const Text("Off"),
                value: value.darkMode,
                onChanged: (dark) {
                  value.setDarkMode(dark: dark);
                }),
          ),
          Consumer<SettingModel>(
            builder: (context, value, child) => ListTile(
              title: const Text(
                "Language",
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(value.language),
              trailing: IconButton(
                icon: const Icon(Icons.language),
                onPressed: () async {
                  String? lang = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text("Choose your preferred Language"),
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, "am");
                              },
                              child: const Text("Amharic")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, "en");
                              },
                              child: const Text("English")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, "gez");
                              },
                              child: const Text(
                                "Geez",
                              ))
                        ],
                      );
                    },
                  );
                  if (lang != null) {
                    value.setLanguage(lang: lang);
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: () async {
                showDialog<Map<String, String>>(
                  context: context,
                  builder: (context) {
                    TextEditingController emailController =
                        TextEditingController();
                    TextEditingController passwordController =
                        TextEditingController();
                    return SimpleDialog(
                      title: const Text("Sign in to continue"),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                label: Text("Email")),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              label: Text("Password"),
                            ),
                            obscureText: true,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              _authenticating = true;
                            });
                            try {
                              final emailAddress = emailController.text;
                              final password = passwordController.text;

                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailAddress, password: password);

                              Navigator.pop(context);
                              await Navigator.pushNamed(
                                  context, RouteGenerator.live);
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      dismissDirection:
                                          DismissDirection.horizontal,
                                      content: Text(
                                          "Invalid email or password. try again!.")));
                            }
                            setState(() {
                              _authenticating = false;
                            });
                          },
                          child: _authenticating
                              ? const CupertinoActivityIndicator()
                              : const Text("Login"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text("Admin Page"),
            ),
          )
        ],
      ),
    );
  }
}
