### Unreleased

### 0.1.2
  * bug fixes
    * fix error in which always it was expected a matrix as a result of find methods.

### 0.1.1
  * improve intelligence of find methods
    * new scope for find without encode id, use `secret_id: false`.
  * bug fixes
    * Fix bug that only allows find on STI.

  I need tests for this stuff.

### 0.1.0
  * now `secret_id` instead of `id` shows the encoded value.
  * bug fixes
    * Fix bug when updated a resource.
    * Fix bug in which all models are decoding ids (including those who were not extended), produced in `find_with_ids`.
    * Fix bug when decode_id failed and not raise a `ActiveRecord::RecordNotFound`.

### 0.0.2
  * bug fix
    * Fix bug when created a resource.

### 0.0.1
  * secret_id initial version released.
