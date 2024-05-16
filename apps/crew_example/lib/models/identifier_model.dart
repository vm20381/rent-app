import '/models/model.dart';

abstract class IdentifierModel<T> extends Model {
  final String id;

  IdentifierModel(this.id);
}
