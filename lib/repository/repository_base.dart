abstract class Repository<T> {
  late final String _table;

  Repository(this._table);

  Future<List<T>> getAll();
  Future<int?> insert(T type);
  Future<bool> delete(T type);
  Future<bool> update(T type);
  Future<T> get(String uuid);
}
