# Use draper in conjunction with Kaminari
# Reference: https://qiita.com/zorori777/items/1d2115b2cbd7b2fa7fc9
Draper::CollectionDecorator.delegate :current_page,
  :total_pages,
  :limit_value,
  :total_count,
  :offset_value
