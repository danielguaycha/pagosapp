import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pagosapp/src/models/payments/payment_history.dart';
import 'package:pagosapp/src/pages/payments/actions/payments_actions.dart';
import 'package:pagosapp/src/utils/validators.dart';

class SlidebleHistoryPay extends StatefulWidget {
  final PaymentHistory pay;
  SlidebleHistoryPay({Key key, this.pay}) : super(key: key);

  @override
  _SlidebleHistoryPayState createState() => _SlidebleHistoryPayState();
}

class _SlidebleHistoryPayState extends State<SlidebleHistoryPay> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      child: ListTile(
        title: Row(
          children: <Widget>[
            Container(
              height: 20,
              width: 20,
              child: CircleAvatar(
                  backgroundColor: _getColor(widget.pay.status),
                  child: Text("${widget.pay.number}",
                      style: TextStyle(fontSize: 13))),
            ),
            SizedBox(width: 10),
            Text("${money(widget.pay.total)}",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _getColor(widget.pay.status))),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("${widget.pay.getStatus()}",
                style: TextStyle(color: _getColor(widget.pay.status))),
            Text("${dateForHumans2(widget.pay.date)}",
                style: TextStyle(color: _getColor(widget.pay.status))),
          ],
        ),
      ),
      secondaryActions:_slides(context),
    );
  }

  List<Widget> _slides(context) {
    List<Widget> list = List();
    if (widget.pay.status == PaymentHistory.COBRADO) {
      list.add(_slideAnular(context));
    }
    else if (widget.pay.status == PaymentHistory.MORA) {
      list.add(_slidePagar(context));
    }
    else {
      list.add(_slideMora(context));
      list.add(_slidePagar(context));
    }
    return list;
  }

  // slides

  _slideMora(context) {
    return IconSlideAction(
        caption: 'Mora',
        color: Colors.red,
        icon: Icons.remove_circle_outline,
        onTap: () async {
          if (await setMoraPay(context, payId: widget.pay.id)) {
            setState(() {
              widget.pay.status = PaymentHistory.MORA;
            });
          }
        });
  }

  _slidePagar(context) {
    return IconSlideAction(
        caption: 'Cobrar',
        color: Colors.green,
        icon: Icons.payment,
        onTap: () async {
          if (widget.pay.status == PaymentHistory.COBRADO) {
            return null;
          }
          if (await setPaySuccess(context, payId: widget.pay.id)) {
            setState(() {
              widget.pay.status = PaymentHistory.COBRADO;
            });
          }
        });
  }

  _slideAnular(context) {
    return IconSlideAction(
        caption: 'Anular',
        color: Theme.of(context).primaryColor,
        icon: Icons.delete,
        onTap: () async {
          if (widget.pay.status == PaymentHistory.MORA ||
              widget.pay.status == PaymentHistory.PENDIENTE) {
            return null;
          }
          if (await cancelPay(context, payId: widget.pay.id)) {
            setState(() {
              widget.pay.status = PaymentHistory.PENDIENTE;
            });
          }
        });
  }

  Color _getColor(int status) {
    if (status == 2) {
      return Colors.green;
    }

    if (status == -1) {
      return Colors.red;
    }

    return Colors.black87;
  }
}
