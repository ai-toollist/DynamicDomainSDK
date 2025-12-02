import 'package:flutter/material.dart';
import 'package:openim_common/openim_common.dart';
import '../../widgets/base_page.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      title: StrRes.contactUs,
      centerTitle: false,
      showLeading: true,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return H5Container(url: Config.contactLink); // Placeholder contact URL
  }
}
