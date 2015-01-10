# ActiveRecord PostgreSQL procedures

PostgreSQL allows to create a procedure which returns a result set. The gem modifies ActiveRecord (>= 4.2) so that it's possible to create (readonly) model based on resultset instead of a database table.

Given a PostgreSQL procedure

```SQL
CREATE FUNCTION books(whatever INT)
RETURNS TABLE (
    id INTEGER,
    title CHARACTER VARYING,
    volume INTEGER,
    published BOOLEAN
) LANGUAGE SQL STABLE
AS $$
...
$$
```

and model

```ruby
class Book < ActiveRecord::Base
end
```

you can read the model the same way you read model based on database table. You need to call the procedure using the `from` clause.

```ruby
Book.from("books(1)") # <ActiveRecord::Relation [#<Book id: 1, title: "Small John", volume: 7, published: true>, ...]>
```

Relationship and other stuff from Active Record also work. In fact the gem modifies PostgreSQL adapter, Active Record doesn't even know if it reads table or a resultset.

## Notes

* The first column is used as a primary key.
* You can't write a model back to the database.


## Download and installation

The latest version of Active Record PostgreSQL procedures can be installed with RubyGems:

```
  % [sudo] gem install activerecord_postgresql_procedures
```

Source code can be downloaded from GitHub:

* https://github.com/tom-kuca/activerecord_postgresql_procedures

## License

The project is released under the MIT license:

* http://www.opensource.org/licenses/MIT

## Support

Bug reports can be filed here:

* https://github.com/tom-kuca/activerecord_postgresql_procedures/issues

