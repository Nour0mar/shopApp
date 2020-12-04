import 'package:flutter/material.dart';
import 'package:online_shop/provider/cart.dart';
import 'package:provider/provider.dart';
class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem(this.id,this.productId, this.title, this.quantity, this.price);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction){
        return showDialog(context: context,
        builder: (ctx)=>AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Do you want to remove the item from cart?"),
          actions: [
            FlatButton(onPressed: (){
              Navigator.of(context).pop(false);
            },
                child: Text("No")),
            FlatButton(onPressed: (){
              Navigator.of(context).pop(true);
            },
                child: Text("Yes")),
          ],
        )
        );
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeItem(productId);

      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text("\$$price")),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total: \$${(price * quantity).toStringAsFixed(2)}"),
            trailing: Text("$quantity X"),
          ),
        ),
      ),
    );
  }
}
