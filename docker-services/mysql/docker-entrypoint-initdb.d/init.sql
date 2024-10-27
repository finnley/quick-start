CREATE DATABASE liber DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

CREATE DATABASE `micro_shop_user_srv` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

CREATE DATABASE `test_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
use test_db;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '',
  `age` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE DATABASE `wordpress` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

create database if not exists xiaohongshu_b DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
create database if not exists xiaohongshu_c DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
