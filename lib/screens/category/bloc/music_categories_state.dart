import 'package:equatable/equatable.dart';
import 'package:innershakti_assignment/screens/category/model/music_category.dart';

abstract class MusicCategoriesState extends Equatable {
  @override
  List<Object> get props => [];
}

class MusicCategoriesInitial extends MusicCategoriesState {}

class MusicCategoriesLoading extends MusicCategoriesState {}

class MusicCategoriesLoaded extends MusicCategoriesState {
  final List<MusicCategory> categories;

  MusicCategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class MusicCategoriesError extends MusicCategoriesState {
  final String message;

  MusicCategoriesError(this.message);

  @override
  List<Object> get props => [message];
}
