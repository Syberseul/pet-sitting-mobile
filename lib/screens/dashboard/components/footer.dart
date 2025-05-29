import 'package:flutter/material.dart';
import 'package:flutter_projects/constants/c_footer_tab.dart';
import 'package:flutter_projects/constants/enum.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/modules/user.dart';
import 'package:flutter_projects/providers/auth_provider.dart';
import 'package:flutter_projects/screens/dashboard/components/footer_tab.dart';
import 'package:provider/provider.dart';

class Footer extends StatelessWidget {
  const Footer({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final TranslateEnum? selectedTab;
  final Function(TranslateEnum) onTabSelected;

  @override
  Widget build(BuildContext context) {
    final User? user = context.read<AuthProvider>().getUserInfo;
    final userRole = userRoleList[user!.role];

    return Container(
      height: 60.0,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.lightBlueAccent),
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (userRole == UserRole.admin || userRole == UserRole.developer)
              FooterTab(
                tabName: TranslateEnum.calendarTab,
                tabIcon: Icons.event,
                isSelected: selectedTab == TranslateEnum.calendarTab,
                onClick: () => onTabSelected(TranslateEnum.calendarTab),
              )
            else if (userRole == UserRole.dogOwner ||
                userRole == UserRole.visitor)
              FooterTab(
                tabName: TranslateEnum.generalTab,
                tabIcon: Icons.newspaper,
                isSelected: selectedTab == TranslateEnum.generalTab,
                onClick: () => onTabSelected(TranslateEnum.generalTab),
              )
            else
              SizedBox(),
            if (userRole == UserRole.visitor)
              TextButton(
                onPressed: () => {},
                child: Text("become a dog owner"),
              ),
            FooterTab(
              tabName: TranslateEnum.myAccountTab,
              tabIcon: Icons.account_circle,
              isSelected: selectedTab == TranslateEnum.myAccountTab,
              onClick: () => onTabSelected(TranslateEnum.myAccountTab),
            ),

            if (userRole != UserRole.visitor)
              FooterTab(
                tabName: TranslateEnum.settingTab,
                tabIcon: Icons.settings,
                isSelected: selectedTab == TranslateEnum.settingTab,
                onClick: () => onTabSelected(TranslateEnum.settingTab),
              ),
          ],
        ),
      ),
    );
  }
}
