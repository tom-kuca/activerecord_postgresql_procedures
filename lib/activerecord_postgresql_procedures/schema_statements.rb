module ActiveRecord
	module ConnectionAdapters
		module PostgreSQL
			module SchemaStatements

				# Returns just a table's primary key
				def primary_key(table)
					if table_or_view_exists?(table)
						 table_primary_key(table)
					else
						procedure_primary_key(table)
					end
				end

				def table_primary_key(table)
					row = exec_query(<<-end_sql, 'SCHEMA').rows.first
						SELECT attr.attname
						FROM pg_attribute attr
						INNER JOIN pg_constraint cons ON attr.attrelid = cons.conrelid AND attr.attnum = cons.conkey[1]
						WHERE cons.contype = 'p'
						AND cons.conrelid =  (SELECT oid FROM pg_class WHERE relname = '#{table}')
						end_sql
					row && row.first
				end

				# Return the procedure's primary key
				#
				# The procedure doesn't have 'native' primary key, the first column is used.
				def procedure_primary_key(name)
					row = exec_query(<<-end_sql, 'SCHEMA').rows.first
            SELECT proargnames[1] FROM pg_proc WHERE proname = '#{name}'
          end_sql
					row && row.first
				end


				# Returns the list of all tables in the schema search path or a specified schema.
				# def tables(name = nil)
				# 	query(<<-SQL, 'SCHEMA').map { |row| row[0] }
				# 		SELECT tablename
				# 		FROM pg_tables
				# 		WHERE schemaname = ANY (current_schemas(false))
				# 	SQL
				# end

				# Returns true if table or procedure exists.
				# If the schema is not specified as part of +name+ then it will only find tables within
				# the current schema search path (regardless of permissions to access tables in other schemas)
				def table_exists?(name)
					table_or_view_exists?(name) or procedure_exists?(name)
				end

				# Returns true if table exists.
				# If the schema is not specified as part of +name+ then it will only find tables within
				# the current schema search path (regardless of permissions to access tables in other schemas)
				def table_or_view_exists?(name)
					name = Utils.extract_schema_qualified_name(name.to_s)
					return false unless name.identifier
					exec_query(<<-SQL, 'SCHEMA').rows.first[0].to_i > 0
						SELECT COUNT(*)
						FROM
							pg_class c
							LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
						WHERE
							c.relkind IN ('r','v','m') -- (r)elation/table, (v)iew, (m)aterialized view
							AND c.relname = '#{name.identifier}'
							AND n.nspname = #{name.schema ? "'#{name.schema}'" : 'ANY (current_schemas(false))'}
					SQL
				end


				def procedure_exists?(name)
					name = Utils.extract_schema_qualified_name(name.to_s)
					return false unless name.identifier
					exec_query(<<-SQL, 'SCHEMA').rows.first[0].to_i > 0
						SELECT  COUNT(*)
						FROM
							pg_catalog.pg_proc p
							JOIN    pg_catalog.pg_namespace n ON pronamespace = n.oid
							JOIN    pg_catalog.pg_type t ON typelem = p.prorettype
						WHERE
							typname = '_record'
							AND p.proname = '#{name.identifier}'
							AND n.nspname = #{name.schema ? "'#{name.schema}'" : 'ANY (current_schemas(false))'}
					SQL
				end

			end
		end
	end
end

