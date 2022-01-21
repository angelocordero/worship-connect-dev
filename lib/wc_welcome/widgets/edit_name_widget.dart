import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/wc_welcome/screens/welcome_page.dart';

class EditNameWidget extends StatefulWidget {
  const EditNameWidget({Key? key}) : super(key: key);

  @override
  _EditNameWidgetState createState() => _EditNameWidgetState();
}

class _EditNameWidgetState extends State<EditNameWidget> {
  static final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    if(mounted){
      _textEditingController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: WCUtils().screenHeightSafeArea(context)! / 4,
        decoration: BoxDecoration(
          color: Colors.black38,
          border: Border.all(color: wcPrimaryColor),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(
              WCUtils().screenWidth(context)!,
              75,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientText('Welcome,',
                  colors: wcGradientColors,
                  style: GoogleFonts.exo2(
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, _) {
                  String userName = ref.watch(userNameProvider)!;

                  WidgetsBinding.instance?.addPostFrameCallback(
                    (_) {
                      _textEditingController.text = userName;
                      _textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: userName.length));
                    },
                  );

                  return TextField(
                    controller: _textEditingController,
                    onChanged: (value) {
                      ref.watch(userNameProvider.state).state = value;
                    },
                    style: GoogleFonts.exo2(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
