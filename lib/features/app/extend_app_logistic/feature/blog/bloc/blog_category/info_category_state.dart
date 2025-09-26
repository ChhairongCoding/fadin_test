import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/models/info_category.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class InfoCategoryState extends Equatable {
  InfoCategoryState([List props = const []]) : super();
  @override
  List<Object> get props => [];
}

class FetchingInfoCategory extends InfoCategoryState {
  @override
  String toString() => 'LoadingFavouriteProcessing';
}

class FetchedInfoCategory extends InfoCategoryState {
  @override
  String toString() => 'AddingFavouriteProcessing';
}

class ErrorFetchingInfoCategory extends InfoCategoryState {
  final String error;
  ErrorFetchingInfoCategory({required this.error});
  @override
  String toString() => 'LoadingFavouriteProcessing';
}

class FetchingInfoCategoryDetail extends InfoCategoryState {}

class FetchedInfoCategoryDetail extends InfoCategoryState {
  final InfoCategory infoCategory;
  FetchedInfoCategoryDetail({required this.infoCategory});
}

class ErrorFetchingInfoCategoryDetail extends InfoCategoryState {
  final String error;
  ErrorFetchingInfoCategoryDetail({required this.error});
}
