DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
    `no` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id` VARCHAR(100) NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `phone` VARCHAR(20) NOT NULL,
    `gender` VARCHAR(20) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `birth` VARCHAR(50) NOT NULL,
    `trainer_no` INT NULL,
    `code` VARCHAR(20) NULL,
    `enabled` INT NOT NULL DEFAULT '1',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `question` VARCHAR(100) NOT NULL,
    `answer` VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS `user_auth`;

CREATE TABLE `user_auth` (
    `no` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_no` INT NOT NULL,
    `auth` VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS `attendance`;

CREATE TABLE `attendance` (
    `qr_id` VARCHAR(100) NOT NULL PRIMARY KEY,
    `user_no` INT NOT NULL,
    `check_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS `ticket`;

CREATE TABLE `ticket` (
    `no` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `price` INT NOT NULL,
    `info` VARCHAR(100) NOT NULL,
    `type` VARCHAR(100) NOT NULL,
    `months` INT NOT NULL,
    `pt_count` INT NULL
);

DROP TABLE IF EXISTS `buy_list`;

CREATE TABLE `buy_list` (
    `no` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `ticket_no` INT NOT NULL,
    `user_no` INT NOT NULL,
    `trainer_no` INT NOT NULL,
    -- `pt_count` INT NULL,
    `buy_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `end_date` TIMESTAMP NOT NULL,
    `canceled_at`	TIMESTAMP	NULL,
	`status`	VARCHAR(10)	NOT NULL	DEFAULT '정상',
    `start_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS `trainer_profile`;

CREATE TABLE `trainer_profile` (
    `no` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `trainer_no` INT NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `simple_info`	VARCHAR(100)	NOT NULL,
	`detail_info`	VARCHAR(2000)	NOT NULL
);

DROP TABLE IF EXISTS `reservation`;

CREATE TABLE `reservation` (
    `no`    INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `rv_date`   TIMESTAMP   NOT NULL,
    `user_no`   INT NOT NULL,
    `trainer_no`    INT NOT NULL,
    `created_at` TIMESTAMP  NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    `canceled_at` TIMESTAMP NULL,
    `enabled` INT NOT NULL DEFAULT 1
);

DROP TABLE IF EXISTS `files`;

CREATE TABLE `files` (
    `no` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `profile_no` INT NOT NULL,
    `type` VARCHAR(100) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `path` VARCHAR(100) NOT NULL,
    `size` INT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS `comment`;

CREATE TABLE `comment` (
    `no` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `comment_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `trainer_no` INT NOT NULL,
    `user_no` INT NOT NULL,
    `c_content` VARCHAR(500) NOT NULL,
    `f_content` VARCHAR(500) NOT NULL
);

DROP TABLE IF EXISTS `plan`;

CREATE TABLE `plan` (
    `no` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_no` INT NOT NULL,
    `plan_name` VARCHAR(100) NOT NULL,
    `plan_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `plan_content` VARCHAR(500) NULL,
    `plan_end` TIMESTAMP NULL
);

DROP TABLE IF EXISTS `board`;

CREATE TABLE `board` (
    `no` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_no` INT NOT NULL,
    `title` VARCHAR(100) NOT NULL,
    `content` VARCHAR(500) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS `persistent_logins`;

CREATE TABLE `persistent_logins` (
    `username` VARCHAR(100) NOT NULL PRIMARY KEY,
    `series` VARCHAR(100) NOT NULL,
    `token` VARCHAR(100) NOT NULL,
    `last_used` VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS `answer`;

CREATE TABLE `answer` (
    `no` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `board_no` INT NOT NULL,
    `user_no` INT NOT NULL,
    `content` VARCHAR(500) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS `qr_code`;

CREATE TABLE `qr_code` (
    `no` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_no` INT NOT NULL,
    `uuid` VARCHAR(100) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE `user_auth`
ADD CONSTRAINT `FK_users_TO_user_auth_1` FOREIGN KEY (`user_no`) REFERENCES `users` (`no`);

ALTER TABLE `attendance`
ADD CONSTRAINT `FK_users_TO_attendance_1` FOREIGN KEY (`user_no`) REFERENCES `users` (`no`);

ALTER TABLE `trainer_profile`
ADD CONSTRAINT `FK_users_TO_trainer_profile_1` FOREIGN KEY (`trainer_no`) REFERENCES `users` (`no`);

ALTER TABLE `reservation`
ADD CONSTRAINT `FK_users_TO_reservation_1` FOREIGN KEY (`user_no`) REFERENCES `users` (`no`);

ALTER TABLE `reservation`
ADD CONSTRAINT `FK_users_TO_reservation_2` FOREIGN KEY (`trainer_no`) REFERENCES `users` (`no`);

ALTER TABLE `files`
ADD CONSTRAINT `FK_trainer_profile_TO_file_1` FOREIGN KEY (`profile_no`) REFERENCES `trainer_profile` (`no`);

ALTER TABLE `comment`
ADD CONSTRAINT `FK_plan_TO_comment_1` FOREIGN KEY (`user_no`) REFERENCES `users` (`no`);

ALTER TABLE `comment`
ADD CONSTRAINT `FK_users_TO_comment_1` FOREIGN KEY (`trainer_no`) REFERENCES `users` (`no`);

ALTER TABLE `plan`
ADD CONSTRAINT `FK_users_TO_plan_1` FOREIGN KEY (`user_no`) REFERENCES `users` (`no`);

ALTER TABLE `board`
ADD CONSTRAINT `FK_users_TO_board_1` FOREIGN KEY (`user_no`) REFERENCES `users` (`no`);

ALTER TABLE `answer`
ADD CONSTRAINT `FK_board_TO_answer_1` FOREIGN KEY (`board_no`) REFERENCES `board` (`no`);

ALTER TABLE `answer`
ADD CONSTRAINT `FK_users_TO_answer_1` FOREIGN KEY (`user_no`) REFERENCES `users` (`no`);

ALTER TABLE `qr_code`
ADD CONSTRAINT `FK_users_TO_qr_code_1` FOREIGN KEY (`user_no`) REFERENCES `users` (`no`);




/* QR코드 이벤트 핸들러 */

SET GLOBAL event_scheduler = ON;

SELECT * FROM qr_code;

CREATE EVENT delete_expired_qr_codes
ON SCHEDULE EVERY 1 MINUTE  -- 1분마다 실행 QR코드 삭제
DO
DELETE FROM qr_code WHERE created_at <= NOW() - INTERVAL 60 SECOND;