/* 유저 추가 */

/* 1번 사용자 */
INSERT INTO users (id, password, name, phone, gender, email, birth, enabled, question, answer)
VALUES ('john123', 'securePass123!', '김영수', '01012345678', 'M', 'john.doe@example.com', '1990-01-15', true, 'What is your favorite color?', 'Blue');
SET @userNo = LAST_INSERT_ID();
INSERT INTO user_auth (user_no, auth)
VALUES (@userNo, 'ROLE_USER');

/* 2번 사용자 */
INSERT INTO users (id, password, name, phone, gender, email, birth, enabled, question, answer)
VALUES ('jane456', 'passJane@456', '이수진', '01098765432', 'F', 'jane.smith@example.com', '1985-05-20', true, 'What is your mother’s maiden name?', 'Johnson');
SET @userNo = LAST_INSERT_ID();
INSERT INTO user_auth (user_no, auth)
VALUES (@userNo, 'ROLE_USER');

/* 3번 사용자 */
INSERT INTO users (id, password, name, phone, gender, email, birth, enabled, question, answer)
VALUES ('alex2023', 'Alex!Secure2023', '박철수', '01056781234', 'M', 'alex.brown@example.com', '2000-12-10', true, 'What was your first pet’s name?', 'Buddy');
SET @userNo = LAST_INSERT_ID();
INSERT INTO user_auth (user_no, auth)
VALUES (@userNo, 'ROLE_USER');

/* 4번 사용자 */
INSERT INTO users (id, password, name, phone, gender, email, birth, enabled, question, answer)
VALUES ('sara789', 'Sara_789$pass', '최은영', '01034567890', 'F', 'sara.lee@example.com', '1995-07-25', true, 'What city were you born in?', 'Seoul');
SET @userNo = LAST_INSERT_ID();
INSERT INTO user_auth (user_no, auth)
VALUES (@userNo, 'ROLE_USER');

/* 5번 사용자 */
INSERT INTO users (id, password, name, phone, gender, email, birth, enabled, question, answer)
VALUES ('chris888', 'Chris#888Pass', '정민호', '01087654321', 'M', 'chris.johnson@example.com', '1988-03-30', true, 'What is your favorite food?', 'Pizza');
SET @userNo = LAST_INSERT_ID();
INSERT INTO user_auth (user_no, auth)
VALUES (@userNo, 'ROLE_USER');

/* 6번 사용자 */
INSERT INTO users (id, password, name, phone, gender, email, birth, enabled, question, answer)
VALUES ('lisa101', 'Lisa$101pass', '김수정', '01011112222', 'F', 'lisa.kim@example.com', '1992-06-12', true, 'What was the name of your first school?', 'Sunny School');
SET @userNo = LAST_INSERT_ID();
INSERT INTO user_auth (user_no, auth)
VALUES (@userNo, 'ROLE_USER');

/* 7번 사용자 */
INSERT INTO users (id, password, name, phone, gender, email, birth, enabled, question, answer)
VALUES ('daniel777', 'Daniel!777pass', '박준형', '01033334444', 'M', 'daniel.park@example.com', '1998-02-18', true, 'What is your dream job?', 'Pilot');
SET @userNo = LAST_INSERT_ID();
INSERT INTO user_auth (user_no, auth)
VALUES (@userNo, 'ROLE_USER');

/* 8번 사용자 */
INSERT INTO users (id, password, name, phone, gender, email, birth, enabled, question, answer)
VALUES ('emma2024', 'Emma#2024$', '이지혜', '01055556666', 'F', 'emma.lee@example.com', '1993-09-09', true, 'What is your father’s middle name?', 'Michael');
SET @userNo = LAST_INSERT_ID();
INSERT INTO user_auth (user_no, auth)
VALUES (@userNo, 'ROLE_USER');

/* 9번 사용자 */
INSERT INTO users (id, password, name, phone, gender, email, birth, enabled, question, answer)
VALUES ('mike999', 'Mike@999pass', '최성훈', '01077778888', 'M', 'mike.choi@example.com', '1991-11-11', true, 'What was the model of your first car?', 'Civic');
SET @userNo = LAST_INSERT_ID();
INSERT INTO user_auth (user_no, auth)
VALUES (@userNo, 'ROLE_USER');

/* 10번 사용자 */
INSERT INTO users (id, password, name, phone, gender, email, birth, enabled, question, answer)
VALUES ('nina555', 'Nina#555pass', '강은주', '01099990000', 'F', 'nina.kang@example.com', '1996-03-03', true, 'Who was your childhood hero?', 'Wonder Woman');
SET @userNo = LAST_INSERT_ID();
INSERT INTO user_auth (user_no, auth)
VALUES (@userNo, 'ROLE_USER');






/* 기본 출석 횟수 세팅 */
INSERT INTO
    `attendance` (
        `qr_id`,
        `user_no`,
        `check_time`
    )
VALUES ('QR112345', 10, NOW());

    INSERT INTO
    `attendance` (
        `qr_id`,
        `user_no`,
        `check_time`
    )
VALUES ('QR12345', 2, NOW());

    INSERT INTO
    `attendance` (
        `qr_id`,
        `user_no`,
        `check_time`
    )
VALUES ('QR1dsfdsfsd2345', 3, NOW());

    INSERT INTO
    `attendance` (
        `qr_id`,
        `user_no`,
        `check_time`
    )
VALUES ('QR14235235232345', 4, NOW());

    INSERT INTO
    `attendance` (
        `qr_id`,
        `user_no`,
        `check_time`
    )
VALUES ('QR1243634622132345', 5, NOW());

    INSERT INTO
    `attendance` (
        `qr_id`,
        `user_no`,
        `check_time`
    )
VALUES ('QR342352212345', 6, NOW());

    INSERT INTO
    `attendance` (
        `qr_id`,
        `user_no`,
        `check_time`
    )
VALUES ('QR122342356345', 7, NOW());

    INSERT INTO
    `attendance` (
        `qr_id`,
        `user_no`,
        `check_time`
    )
VALUES ('QR12452345', 8, NOW());

    INSERT INTO
    `attendance` (
        `qr_id`,
        `user_no`,
        `check_time`
    )
VALUES ('QR121412546345', 9, NOW());

INSERT INTO
    `attendance` (
        `qr_id`,
        `user_no`,
        `check_time`
    )
VALUES 
    ('QR174577142354', 1, NOW());



/* 출석 횟수 올리기 */
INSERT INTO
    `attendance` (
        `qr_id`,
        `user_no`,
        `check_time`
    )
VALUES ('QR12134134312345', 1, NOW());





INSERT INTO `attendance` (`qr_id`, `user_no`, `check_time`)
VALUES
    ('qr_31', 31, NOW()),
    ('qr_32', 32, NOW()),
    ('qr_33', 33, NOW()),
    ('qr_34', 34, NOW()),
    ('qr_35', 35, NOW()),
    ('qr_36', 36, NOW()),
    ('qr_37', 37, NOW()),
    ('qr_38', 38, NOW()),
    ('qr_39', 39, NOW()),
    ('qr_40', 40, NOW()),
    ('qr_41', 41, NOW()),
    ('qr_42', 42, NOW()),
    ('qr_43', 43, NOW()),
    ('qr_44', 44, NOW()),
    ('qr_45', 45, NOW()),
    ('qr_46', 46, NOW()),
    ('qr_47', 47, NOW()),
    ('qr_48', 48, NOW()),
    ('qr_49', 49, NOW()),
    ('qr_50', 50, NOW()),
    ('qr_51', 51, NOW());
