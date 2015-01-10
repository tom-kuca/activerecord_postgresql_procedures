require 'spec_helper'

require "models/table_model"
require "models/proc_model"

require "cases/helper"

describe ActiverecordPostgresqlProcedures do

	before(:all) do
		ARPPTest.connect
		@connection = ActiveRecord::Base.connection
	end

	context 'table' do
		it 'should exist' do
			expect(@connection.table_or_view_exists?("table_models")).to be_truthy
		end

		it 'should not be recognized as procedure' do
			expect(@connection.procedure_exists?("table_models")).to be_falsey
		end

		it 'should have columns' do
			expect(TableModel.columns).to_not be_empty
		end

		it 'should have primary key id' do
			expect(TableModel.primary_key).to eql('id')
		end
	end


	context 'procedure' do
		it 'should exist' do
			expect(@connection.procedure_exists?("proc_models")).to be_truthy
		end

		it 'should not be recognized as a table' do
			expect(@connection.table_or_view_exists?("proc_models")).to be_falsey
		end

		it 'should have columns' do
			expect(ProcModel.columns).to_not be_empty
		end

		it 'should have primary key id' do
			expect(ProcModel.primary_key).to eql('id')
		end

		it 'should load all records' do
			expect(ProcModel.from('proc_models()').size).to eql(2)
		end

		it 'should load primary key' do
			expect(ProcModel.from('proc_models()').first.id).to eql(1)
		end

	end

	it 'should load same columns for same definition (except primary key)' do
		tbl_cols = @connection.column_definitions("table_models")
		proc_cols = @connection.column_definitions("proc_models")
		expect(tbl_cols).to eq(proc_cols)
	end


	it 'should load same records' do
		expect(ProcModel.from('proc_models()').map(&:attributes)).to eql(TableModel.all.map(&:attributes))
	end

end
