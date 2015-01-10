module ActiveRecord
	module ConnectionAdapters
	 	class PostgreSQLAdapter < AbstractAdapter

			# Returns the list of a table's or procedure's column names, data types, and default values.
			def column_definitions(name) # :nodoc:
				if procedure_exists?(name)
					procedure_column_definitions(name)
				else
					table_column_definitions(name)
				end
			end

			# Returns the list of a table's column names, data types, and default values.
			#
			# Query implementation notes:
			#  - format_type includes the column size constraint, e.g. varchar(50)
			#  - ::regclass is a function that gives the id for a table name
			def table_column_definitions(name)
				exec_query(<<-SQL, 'SCHEMA').rows
				SELECT a.attname, format_type(a.atttypid, a.atttypmod),
					pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod
				FROM
				pg_attribute a
				LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
				WHERE
				a.attrelid = '#{quote_table_name(name)}'::regclass
				AND a.attnum > 0 AND NOT a.attisdropped
				ORDER BY a.attnum
				SQL
			end

			# Returns the list of procedure's column names, data types, and default values.
			def procedure_column_definitions(name)
				exec_query(<<-SQL, 'SCHEMA').rows
				SELECT
					argname, format_type(argtype,typtypmod), typdefault, CASE row_number() over() WHEN 1 THEN true ELSE typnotnull END, argtype, typtypmod
				FROM
				(
					SELECT
						unnest(proargnames) AS argname,
						unnest(proallargtypes) AS argtype,
						unnest(proargmodes) AS argmode
					FROM pg_proc
					WHERE proname = '#{name}'
				) t
				JOIN pg_type ON t.argtype = pg_type.oid and t.argmode = 't'
				SQL
			end

		end
	end
end
