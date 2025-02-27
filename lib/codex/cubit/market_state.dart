import 'package:equatable/equatable.dart';
import 'package:market_client/market_client.dart';

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object> get props => [];
}

class MarketInitial extends MarketState {}

class FindingOrders extends MarketState {
  const FindingOrders();
}

class OrdersFound extends MarketState {
  const OrdersFound(this.orders);

  final List<OrderRow> orders;
}

class NoOrdersFound extends MarketState {
  const NoOrdersFound();
}

class MarketError extends MarketState {
  const MarketError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
