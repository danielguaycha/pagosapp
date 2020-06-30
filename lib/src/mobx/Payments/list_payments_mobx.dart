import 'package:mobx/mobx.dart';

part 'list_payments_mobx.g.dart';

class ListPaymentsMobx = _ListPaymentsMobx with _$ListPaymentsMobx;

abstract class _ListPaymentsMobx with Store {
  @observable
  double bottoForGrid = 0.0;

  @action
  void up(){
    bottoForGrid = 65.0;

  }
  @action
  void down(){
    bottoForGrid = 0.0;
  }
  
}