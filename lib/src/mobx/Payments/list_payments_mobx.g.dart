// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_payments_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ListPaymentsMobx on _ListPaymentsMobx, Store {
  final _$bottoForGridAtom = Atom(name: '_ListPaymentsMobx.bottoForGrid');

  @override
  double get bottoForGrid {
    _$bottoForGridAtom.reportRead();
    return super.bottoForGrid;
  }

  @override
  set bottoForGrid(double value) {
    _$bottoForGridAtom.reportWrite(value, super.bottoForGrid, () {
      super.bottoForGrid = value;
    });
  }

  final _$_ListPaymentsMobxActionController =
      ActionController(name: '_ListPaymentsMobx');

  @override
  void up() {
    final _$actionInfo = _$_ListPaymentsMobxActionController.startAction(
        name: '_ListPaymentsMobx.up');
    try {
      return super.up();
    } finally {
      _$_ListPaymentsMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void down() {
    final _$actionInfo = _$_ListPaymentsMobxActionController.startAction(
        name: '_ListPaymentsMobx.down');
    try {
      return super.down();
    } finally {
      _$_ListPaymentsMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
bottoForGrid: ${bottoForGrid}
    ''';
  }
}
