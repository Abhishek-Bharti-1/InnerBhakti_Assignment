
import 'package:equatable/equatable.dart';

abstract class MusicCategoriesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMusicCategories extends MusicCategoriesEvent {}
