// blocs/sessions/sessions_event.dart
import 'package:equatable/equatable.dart';

abstract class CategoryDetailsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCategoryDetails extends CategoryDetailsEvent {
  final String id;

  FetchCategoryDetails(this.id);
}
