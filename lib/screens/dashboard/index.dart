import 'package:flutter/material.dart';
import 'package:flutter_projects/constants/enum.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/main.dart';
import 'package:flutter_projects/modules/user.dart';
import 'package:flutter_projects/providers/auth_provider.dart';
import 'package:flutter_projects/screens/dashboard/components/footer.dart';
import 'package:flutter_projects/screens/dashboard/widgets/calendar_widget.dart';
import 'package:flutter_projects/screens/dashboard/widgets/my_account_widget.dart';
import 'package:flutter_projects/screens/dashboard/widgets/settings_widget.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final User? user =
      navigatorKey.currentContext?.read<AuthProvider>().getUserInfo!;

  TranslateEnum? selectedTab;

  @override
  void initState() {
    super.initState();

    final userRoleInRoleList = userRoleList[user?.role];

    if (userRoleInRoleList == UserRole.admin ||
        userRoleInRoleList == UserRole.developer) {
      selectedTab = TranslateEnum.calendarTab;
    } else if (userRoleInRoleList == UserRole.dogOwner ||
        userRoleInRoleList == UserRole.visitor) {
      selectedTab = TranslateEnum.generalTab;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Later implement role display
    // role == 100 show calendar, other roles show different content
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                // Text("hi, this is dashboard"),
                // Text(user.email),
                Expanded(
                  child:
                      selectedTab == TranslateEnum.calendarTab
                          ? CalendarWidget()
                          : selectedTab == TranslateEnum.myAccountTab
                          ? MyAccountWidget()
                          : selectedTab == TranslateEnum.settingTab
                          ? SettingsWidget()
                          : SizedBox(),
                ),
              ],
            ),
          ),
          Footer(
            selectedTab: selectedTab,
            onTabSelected:
                (tab) => setState(() {
                  selectedTab = tab;
                }),
          ),
        ],
      ),
    );
  }
}
