import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages/home/components/components.dart';
import '../../../helpers/utils/utils.dart';
import '../../../components/components.dart';
import '../home.dart';

class HomeProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<HomePresenter>(context);
    return StreamBuilder<List<ProductViewModel>?>(
        stream: presenter.productsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return HomeEmptyList();
            }
            return GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 40),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Theme.of(context).primaryColorDark,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ResponsiveHeadline6(
                              color: Theme.of(context).primaryColor,
                              text: R.strings.atention,
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () => Navigator.of(context).pop())
                          ],
                        ),
                        content: ResponsiveHeadline6(
                          color: Theme.of(context).primaryColorLight,
                          text: R.strings.questionDelete,
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () => presenter
                                .deleteProduct(snapshot.data![index].code),
                            child: ResponsiveHeadline6(
                              color: Theme.of(context).primaryColorLight,
                              text: R.strings.yes,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onTap: () =>
                      presenter.goToEditProduct(snapshot.data![index].code),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey, width: 0.7)),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            child: snapshot.data![index].imagePath!.isEmpty
                                ? Image.asset(
                                    'lib/ui/assets/iphone.jpg',
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(snapshot.data![index].imagePath!)),
                          ),
                        ),
                        LayoutBuilder(builder: (context, constraints) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: constraints.maxHeight * .5,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius:
                                          1, // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ResponsiveHeadline6(
                                    text: snapshot.data![index].name,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  ResponsiveHeadline6(
                                    text: snapshot.data![index].price == null
                                        ? 'Produto sem preço!'
                                        : 'R\$ ${snapshot.data![index].price!.toStringAsFixed(2)}',
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return HomeErrorWidget();
        });
  }
}
