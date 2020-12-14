import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pagosapp/src/models/payments/payment_row.dart';
import 'package:pagosapp/src/pages/payments/actions/payments_actions.dart';
import 'package:pagosapp/src/pages/payments/old_history_payments_page.dart';
import 'package:pagosapp/src/plugins/messages.dart';
import 'package:pagosapp/src/utils/validators.dart';

class SlideablePay extends StatefulWidget {
  final PaymentRow pay;
  SlideablePay({Key key, this.pay}) : super(key: key);

  @override
  _SlideablePayState createState() => _SlideablePayState();
}

class _SlideablePayState extends State<SlideablePay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("${widget.pay.clientName}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            Text("${money(widget.pay.total)}",
                style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(child: Text("${widget.pay.cityA} | ${widget.pay.addressA}")),
            _getStatus(),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ListPaymentsPage(id: widget.pay.creditId)));
        },
      ),
      actions: <Widget>[],
      secondaryActions: _slideAll(context),
    );
  }

  Widget _getStatus() {
    switch (widget.pay.status) {
      case 1:
        return Text("PENDIENTE",
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.w700));
      case 2:
        return Text("COBRADO",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700));
      case -1:
        return Text("MORA",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700));
      default:
        return Text("PENDIENTE",
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.w700));
    }
  }

  List<Widget> _slideAll(context) {
    List<Widget> list = List();
    if (widget.pay.status == PaymentRow.COBRADO) {
      list.add(_slideAnular(context));
    } else if (widget.pay.status == PaymentRow.MORA) {
      list.add(_slidePagar(context));
    } else {
      list.add(_slideMora(context));
      list.add(_slidePagar(context));
    }
    return list;
  }

  Widget _slideMora(context) {
    return IconSlideAction(
      caption: 'Mora',
      color: Colors.red,
      icon: Icons.remove_circle_outline,
      onTap: () async {
        if (widget.pay.status == PaymentRow.MORA) {
          return null;
        }
        if (widget.pay.status == PaymentRow.COBRADO) {
          toast("Este pago ya fué procesado");
          return null;
        }
        if (await setMoraPay(context, payId: widget.pay.id)) {
          setState(() {
            widget.pay.status = PaymentRow.MORA;
          });
        }
      },
    );
  }

  Widget _slidePagar(context) {
    return IconSlideAction(
      caption: 'Cobrar',
      color: Colors.green,
      icon: Icons.payment,
      onTap: () async {
        if (widget.pay.status == PaymentRow.COBRADO) {
          return null;
        }
        if (await setPaySuccess(context, payId: widget.pay.id)) {
          setState(() {
            widget.pay.status = PaymentRow.COBRADO;
          });
        }
      },
    );
  }

  Widget _slideAnular(context) {
    return IconSlideAction(
      caption: 'Anular',
      color: Theme.of(context).primaryColor,
      icon: Icons.delete,
      onTap: () async {
        if (widget.pay.status == PaymentRow.MORA ||
            widget.pay.status == PaymentRow.PENDIENTE) {
          return null;
        }
        if (await cancelPay(context, payId: widget.pay.id)) {
          setState(() {
            widget.pay.status = PaymentRow.PENDIENTE;
          });
        }
      },
    );
  }
}
