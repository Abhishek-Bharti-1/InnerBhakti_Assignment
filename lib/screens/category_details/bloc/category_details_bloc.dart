
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innershakti_assignment/repository/music_repository.dart';
import 'package:innershakti_assignment/screens/category_details/bloc/category_details_event.dart';
import 'package:innershakti_assignment/screens/category_details/bloc/category_details_state.dart';


class CategoryDetailsBloc extends Bloc<CategoryDetailsEvent, CategoryDetailsState> {
  final MusicRepository musicRepository;

CategoryDetailsBloc(this.musicRepository) : super(CategoryDetailsInitial()) {
    on<FetchCategoryDetails>((event, emit) async {
      emit(CategoryDetailsLoading());
      try {
        final categoryDetails = await musicRepository.fetchSessions(event.id);
        emit(CategoryDetailsLoaded(categoryDetails));
      } catch (e) {
        emit(CategoryDetailsError(e.toString()));
      }
    });
  }
}
