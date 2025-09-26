import 'package:equatable/equatable.dart';

abstract class WidgetInfoState extends Equatable {
  WidgetInfoState([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class FetchingWidgetInfo extends WidgetInfoState {}

class FetchedWidgetInfo extends WidgetInfoState {
  final double height;
  final double width;
  FetchedWidgetInfo({required this.height, required this.width});
}
