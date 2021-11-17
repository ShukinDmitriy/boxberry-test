2. У вас есть база размером свыше 100гб и более 8млн строк. Вам необходимо добавить 3 новых поля, переименовать одно поле, а также добавить два индекса. Опишите, как вы это будете делать?

Решение (применимо к postresql):
- добавить 3 новых поля  
  
  alter table table_name add column_name column_type;  
  Такая конструкция работает практически мгновенно, без переписывания всей таблицы. А вот если добавить DEFAULT-значение, то — только начиная с 11-й версии. 

- переименовать одно поле  
  ALTER TABLE table_name RENAME COLUMN old_column TO new_column;
- добавить два индекса
 CREATE CONCURRENTLY IF NOT EXISTS index_name ON table_name (column_name); 
