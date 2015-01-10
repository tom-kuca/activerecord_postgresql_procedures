ActiveRecord::Schema.define do

	execute "DROP TABLE IF EXISTS table_models"
	execute "DROP FUNCTION IF EXISTS proc_models()"

	data = <<-SQL
		SELECT
                    1, 'Small John', 7, true, 'Booooring'::text,  TIMESTAMP '2014-01-01',  TIMESTAMP '2014-01-02'
                UNION
		SELECT
                    2, 'Big John', 8, false, 'Funny'::text,  TIMESTAMP '2014-01-03',  TIMESTAMP '2014-01-04'
	SQL

	execute <<-SQL
	CREATE FUNCTION proc_models()
		RETURNS TABLE (
			id INTEGER,
      title CHARACTER VARYING,
			volume INTEGER,
			published BOOLEAN,
			description TEXT,
			created_at TIMESTAMP WITHOUT TIME ZONE,
 			updated_at TIMESTAMP WITHOUT TIME ZONE
		) LANGUAGE SQL STABLE
		AS $$
			#{data}
		$$
		SQL

		execute <<-SQL
	 		CREATE TABLE table_models (
				id INTEGER PRIMARY KEY,
	      title CHARACTER VARYING,
				volume INTEGER,
				published BOOLEAN,
				description TEXT,
				created_at TIMESTAMP WITHOUT TIME ZONE,
	 			updated_at TIMESTAMP WITHOUT TIME ZONE
		);
		INSERT INTO table_models #{data}

	SQL


end

