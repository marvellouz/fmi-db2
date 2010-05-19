inserts: clean_data
	python ./generate_inserts.py > data.sql
blob: clean_data inserts
	cat createTables.sql data.sql createTrig.sql createFunc.sql createView.sql > all.sql
clean_data:
	rm -rf ./data/.*swp
tgz:
	tar cvzf ../71100_71112_DB2_Project.tar.gz createTables.sql data.sql createTrig.sql createView.sql createFunc.sql createProc.sql
