inserts:
	python ./generate_inserts.py > data.sql
blob: inserts
	cat createTables.sql data.sql > all.sql
