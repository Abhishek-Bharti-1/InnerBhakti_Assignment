
import 'package:equatable/equatable.dart';
import 'package:innershakti_assignment/screens/category_details/model/category_details.dart';

abstract class CategoryDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryDetailsInitial extends CategoryDetailsState {}

class CategoryDetailsLoading extends CategoryDetailsState {}

class CategoryDetailsLoaded extends CategoryDetailsState {
  final List<CategoryDetails> categoryDetails;

 CategoryDetailsLoaded(this.categoryDetails);

  @override
  List<Object> get props => [categoryDetails];
}

class CategoryDetailsError extends CategoryDetailsState {
  final String message;

  CategoryDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
