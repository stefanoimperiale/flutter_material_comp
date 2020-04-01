import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:materialbasic/model/product.dart';
import 'package:materialbasic/model/products_repository.dart';
import 'package:materialbasic/supplemental/asymmetric_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text('SHRINE'),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            semanticLabel: 'menu',
          ),
          onPressed: () {
            print('Menu button');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {},
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ProductRepository.loadProducts(Category.all),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.none:
              return AsymmetricView(products: []);
            case ConnectionState.active:
            case ConnectionState.done:
              return AsymmetricView(
                  products: snapshot.data.documents
                      .map((e) => Product.fromSnapshot(e))
                      .toList());
          }
          return null;
        },
      ),
      resizeToAvoidBottomInset:
          false, //the keyboard's appearance does not alter the size of the home page or its widgets
    );
  }

  GridView _buildGridView(
      BuildContext context, List<DocumentSnapshot> products) {
    return GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        childAspectRatio: 8.0 / 9.0,
        children: _buildGridCards(context, products));
  }

  List<Card> _buildGridCards(
      BuildContext context, List<DocumentSnapshot> products) {
    if (products == null || products.isEmpty) {
      return const <Card>[];
    }
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products
        .map((e) => Product.fromSnapshot(e))
        .map((product) => Card(
              elevation: 0.0,
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 18.0 / 11.0,
                    child: Image.asset(
                      product.assetName,
                      fit: BoxFit.fitWidth,
                      package: product.assetPackage,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            product.name,
                            style: theme.textTheme.button,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            formatter.format(product.price),
                            style: theme.textTheme.caption,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ))
        .toList();
  }
}
