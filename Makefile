inserts: clean_data
	python ./generate_inserts.py > data.sql
blob: clean_data inserts
	cat createTables.sql data.sql createTrig.sql createFunc.sql > all.sql
clean_data:
	rm -rf ./data/.*swp
