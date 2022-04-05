import 'package:flutter/material.dart';
import 'package:worship_connect/wc_core/wc_user_firebase_api.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/sign_in/utils/wc_user_auth_data.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';


class EnterNameWidget extends ConsumerStatefulWidget {
  const EnterNameWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EnterNameWidgetState();
}

class _EnterNameWidgetState extends ConsumerState<EnterNameWidget> {
  static final TextEditingController _userNameTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AsyncData<WCUserAuthData?>? _wcUserAuthState = ref.watch(wcUserAuthStateStream).asData;

    return Container(
      width: WCUtils.screenWidth(context) - 50,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.black38,
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          _enterNameTextField(),
          _enterNameButton(_wcUserAuthState),
        ],
      ),
    );
  }

  Padding _enterNameButton(AsyncData<WCUserAuthData?>? _wcUserAuthState) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: wcButtonShape,
        ),
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          await _enterName(_wcUserAuthState);
        },
        child: Ink(
          decoration: BoxDecoration(
            gradient: wcLinearGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 70,
            alignment: Alignment.center,
            child: const Text(
              'Enter',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _enterNameTextField() {
    return Expanded(
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: _userNameTextEditingController,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.all(8),
          hintText: "Enter your name",
          border: InputBorder.none,
          hintStyle: wcHintStyle,
        ),
      ),
    );
  }

  Future<dynamic> _enterName(AsyncData<WCUserAuthData?>? _wcUserAuthState) {
    return WCUSerFirebaseAPI()
        .updateUserName(
      userID: _wcUserAuthState?.value?.userAuthID ?? '',
      userName: _userNameTextEditingController.text.trim(),
    )
        .then(
      (value) {
        _userNameTextEditingController.clear();
      },
    );
  }
}
