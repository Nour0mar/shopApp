import 'package:flutter/material.dart';
import 'package:online_shop/provider/cart.dart';
import 'package:online_shop/provider/products.dart';
import 'package:online_shop/screens/cart_screen.dart';
import 'package:online_shop/widgets/app_drawer.dart';
import 'package:online_shop/widgets/product_grid.dart';
import 'package:online_shop/widgets/badge.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/product_overView';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit=true;
  var _isLoading=false;
  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading= true;
      });
      Provider.of<Products>(context).fetchAndSet().then((_){
        setState(() {
          _isLoading=false;
        });
      });
    }
     _isInit=false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              child: ch,
              value: cart.itemsCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body:_isLoading ? Center(child: CircularProgressIndicator()): ProductsGrid(_showOnlyFavorites),
    );
  }
}
