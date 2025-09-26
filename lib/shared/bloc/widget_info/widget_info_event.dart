import 'package:equatable/equatable.dart';

abstract class WidgetInfoEvent extends Equatable {
  WidgetInfoEvent([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class FetchWidgetInfo extends WidgetInfoEvent {
  final double height;
  final double width;
  FetchWidgetInfo({required this.height, required this.width});
}
