mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| itdashboard        |
| mysql              |
| orderindex         |
| performance_schema |
+--------------------+
5 rows in set (0.03 sec)

mysql> use orderindex;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+----------------------+
| Tables_in_orderindex |
+----------------------+
| 9x_orders            |
| ic_orders            |
| log_users            |
+----------------------+
3 rows in set (0.00 sec)

mysql> describe 9x_orders;
+----------+--------------+------+-----+---------+-------+
| Field    | Type         | Null | Key | Default | Extra |
+----------+--------------+------+-----+---------+-------+
| disc_id  | varchar(20)  | YES  |     | NULL    |       |
| order_no | varchar(100) | YES  |     | NULL    |       |
+----------+--------------+------+-----+---------+-------+
2 rows in set (0.10 sec)

mysql> 

