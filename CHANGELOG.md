### Unreleased

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
