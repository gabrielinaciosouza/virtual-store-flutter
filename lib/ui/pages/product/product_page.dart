import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';

class ProductPage extends StatelessWidget
    with KeyboardManager, CardSizeManager {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Builder(
            builder: (context) {
              return Align(
                alignment: Alignment.topCenter,
                child: BaseWidget(builder: (context, sizingInformation) {
                  return ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: cardSize(sizingInformation)),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * .15,
                          ),
                          ResponsiveHeadline6(
                            color: Theme.of(context).primaryColorLight,
                            text: R.strings.addPhoto,
                          ),
                          SizedBox(
                            height: height * .07,
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {},
                            icon: Icon(
                              Icons.photo_camera,
                              size: 42,
                            ),
                            color: theme.primaryColorLight,
                          ),
                          SizedBox(
                            height: height * .07,
                          ),
                          ProductInput(
                            icon: Icons.check_circle,
                            labelText: R.strings.name,
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          ProductInput(
                            icon: Icons.code,
                            labelText: R.strings.code,
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          ProductInput(
                            icon: Icons.attach_money,
                            labelText: R.strings.price,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          ProductInput(
                            icon: Icons.archive,
                            labelText: R.strings.stock,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: height * .07,
                          ),
                          ProductButton(),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}