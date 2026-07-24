-- MySQL dump 10.13  Distrib 9.7.1, for macos26.4 (arm64)
--
-- Host: localhost    Database: exam_portal
-- ------------------------------------------------------
-- Server version	9.7.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'd47c990c-8266-11f1-8a77-16bd6ff787bf:1-937';

--
-- Table structure for table `academic_years`
--

DROP TABLE IF EXISTS `academic_years`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_years` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_years`
--

LOCK TABLES `academic_years` WRITE;
/*!40000 ALTER TABLE `academic_years` DISABLE KEYS */;
/*!40000 ALTER TABLE `academic_years` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `answers`
--

DROP TABLE IF EXISTS `answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `exam_id` int NOT NULL,
  `question_id` int NOT NULL,
  `answer` varchar(500) DEFAULT NULL,
  `is_correct` tinyint(1) DEFAULT NULL,
  `attempt_count` int DEFAULT '0',
  `answered_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_answer` (`user_id`,`exam_id`,`question_id`),
  KEY `exam_id` (`exam_id`),
  KEY `question_id` (`question_id`),
  CONSTRAINT `answers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `answers_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `answers_ibfk_3` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answers`
--

LOCK TABLES `answers` WRITE;
/*!40000 ALTER TABLE `answers` DISABLE KEYS */;
INSERT INTO `answers` VALUES (47,9,6,19,'a',0,3,'2026-07-23 11:22:07'),(50,9,7,23,'RuBy official',1,3,'2026-07-24 00:27:45'),(52,9,7,20,'dont know',0,3,'2026-07-24 00:27:56'),(56,9,7,21,'no need',0,3,'2026-07-24 00:28:25'),(58,9,7,22,'stress due to exam',1,3,'2026-07-24 00:28:32');
/*!40000 ALTER TABLE `answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coding_problems`
--

DROP TABLE IF EXISTS `coding_problems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coding_problems` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `input_format` text NOT NULL,
  `output_format` text NOT NULL,
  `sample_input` text NOT NULL,
  `sample_output` text NOT NULL,
  `time_limit` int NOT NULL DEFAULT '1000' COMMENT 'milliseconds',
  `memory_limit` int NOT NULL DEFAULT '256' COMMENT 'MB',
  `difficulty` enum('easy','medium','hard') NOT NULL DEFAULT 'easy',
  `created_by` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `coding_problems_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coding_problems`
--

LOCK TABLES `coding_problems` WRITE;
/*!40000 ALTER TABLE `coding_problems` DISABLE KEYS */;
INSERT INTO `coding_problems` VALUES (1,'Two Sum','Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.','First line: space-separated integers for array.\nSecond line: target integer.','Space-separated indices.','2 7 11 15\n9','0 1',1000,256,'easy',1,'2026-07-21 13:33:11'),(2,'Fibonacci Number','Write a function to compute the N-th Fibonacci number.','A single integer N.','N-th Fibonacci number.','5','5',1000,256,'easy',1,'2026-07-21 13:33:11'),(3,'Reverse Words in a String','Given an input string s, reverse the order of the words.','A string s containing words.','Reversed string.','the sky is blue','blue is sky the',1000,256,'medium',1,'2026-07-21 13:33:11'),(4,'Sudoku Solver','python example','A 9 × 9 Sudoku grid.\r\nEmpty cells are represented by 0.','No solution exists.','7 8 0 4 0 0 1 2 0\r\n6 0 0 0 7 5 0 0 9\r\n0 0 0 6 0 1 0 7 8\r\n0 0 7 0 4 0 2 6 0\r\n0 0 1 0 5 0 9 3 0\r\n9 0 4 0 6 0 0 0 5\r\n0 7 0 3 0 0 0 1 2\r\n1 2 0 0 0 7 4 0 0\r\n0 4 9 2 0 6 0 0 7','Solved Sudoku:\r\n7 8 5 4 3 9 1 2 6\r\n6 1 2 8 7 5 3 4 9\r\n4 9 3 6 2 1 5 7 8\r\n8 5 7 9 4 3 2 6 1\r\n2 6 1 7 5 8 9 3 4\r\n9 3 4 1 6 2 7 8 5\r\n5 7 8 3 9 4 6 1 2\r\n1 2 6 5 8 7 4 9 3\r\n3 4 9 2 1 6 8 5 7',1000,256,'hard',1,'2026-07-23 00:10:57'),(5,'Student Record Management System','c example','First line: Enter the number of students n.\r\nFor each student, enter:\r\nRoll Number (Integer)\r\nName (String)\r\nMarks (Float)','Display the details of all students in the following format:','2\r\n101\r\nRohit\r\n89.5\r\n102\r\nRahul\r\n91','----- Student Records -----\r\n\r\nRoll No : 101\r\nName    : Rohit\r\nMarks   : 89.50\r\n\r\nRoll No : 102\r\nName    : Rahul\r\nMarks   : 91.00',1000,256,'hard',1,'2026-07-23 00:17:01');
/*!40000 ALTER TABLE `coding_problems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coding_submissions`
--

DROP TABLE IF EXISTS `coding_submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coding_submissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `problem_id` int NOT NULL,
  `language` varchar(50) NOT NULL,
  `code` text NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Pending',
  `runtime` int DEFAULT NULL COMMENT 'milliseconds',
  `memory` int DEFAULT NULL COMMENT 'MB',
  `submitted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `problem_id` (`problem_id`),
  CONSTRAINT `coding_submissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `coding_submissions_ibfk_2` FOREIGN KEY (`problem_id`) REFERENCES `coding_problems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coding_submissions`
--

LOCK TABLES `coding_submissions` WRITE;
/*!40000 ALTER TABLE `coding_submissions` DISABLE KEYS */;
INSERT INTO `coding_submissions` VALUES (3,9,4,'python','def print_board(board):\r\n    for row in board:\r\n        print(\" \".join(str(num) for num in row))\r\n\r\ndef find_empty(board):\r\n    for i in range(9):\r\n        for j in range(9):\r\n            if board[i][j] == 0:\r\n                return (i, j)\r\n    return None\r\n\r\ndef is_valid(board, num, pos):\r\n    row, col = pos\r\n\r\n    # Check row\r\n    for j in range(9):\r\n        if board[row][j] == num and col != j:\r\n            return False\r\n\r\n    # Check column\r\n    for i in range(9):\r\n        if board[i][col] == num and row != i:\r\n            return False\r\n\r\n    # Check 3x3 box\r\n    box_x = col // 3\r\n    box_y = row // 3\r\n\r\n    for i in range(box_y * 3, box_y * 3 + 3):\r\n        for j in range(box_x * 3, box_x * 3 + 3):\r\n            if board[i][j] == num and (i, j) != pos:\r\n                return False\r\n\r\n    return True\r\n\r\ndef solve(board):\r\n    empty = find_empty(board)\r\n\r\n    if not empty:\r\n        return True\r\n\r\n    row, col = empty\r\n\r\n    for num in range(1, 10):\r\n        if is_valid(board, num, (row, col)):\r\n            board[row][col] = num\r\n\r\n            if solve(board):\r\n                return True\r\n\r\n            board[row][col] = 0\r\n\r\n    return False\r\n\r\n\r\n# Example Sudoku (0 = empty)\r\nboard = [\r\n    [5,3,0,0,7,0,0,0,0],\r\n    [6,0,0,1,9,5,0,0,0],\r\n    [0,9,8,0,0,0,0,6,0],\r\n    [8,0,0,0,6,0,0,0,3],\r\n    [4,0,0,8,0,3,0,0,1],\r\n    [7,0,0,0,2,0,0,0,6],\r\n    [0,6,0,0,0,0,2,8,0],\r\n    [0,0,0,4,1,9,0,0,5],\r\n    [0,0,0,0,8,0,0,7,9]\r\n]\r\n\r\nif solve(board):\r\n    print(\"Solved Sudoku:\")\r\n    print_board(board)\r\nelse:\r\n    print(\"No solution exists.\")','Accepted',41,11,'2026-07-23 09:58:52'),(4,9,4,'python','def print_board(board):\r\n    for row in board:\r\n        print(\" \".join(str(num) for num in row))\r\n\r\ndef find_empty(board):\r\n    for i in range(9):\r\n        for j in range(9):\r\n            if board[i][j] == 0:\r\n                return (i, j)\r\n    return None\r\n\r\ndef is_valid(board, num, pos):\r\n    row, col = pos\r\n\r\n    # Check row\r\n    for j in range(9):\r\n        if board[row][j] == num and col != j:\r\n            return False\r\n\r\n    # Check column\r\n    for i in range(9):\r\n        if board[i][col] == num and row != i:\r\n            return False\r\n\r\n    # Check 3x3 box\r\n    box_x = col // 3\r\n    box_y = row // 3\r\n\r\n    for i in range(box_y * 3, box_y * 3 + 3):\r\n        for j in range(box_x * 3, box_x * 3 + 3):\r\n            if board[i][j] == num and (i, j) != pos:\r\n                return False\r\n\r\n    return True\r\n\r\ndef solve(board):\r\n    empty = find_empty(board)\r\n\r\n    if not empty:\r\n        return True\r\n\r\n    row, col = empty\r\n\r\n    for num in range(1, 10):\r\n        if is_valid(board, num, (row, col)):\r\n            board[row][col] = num\r\n\r\n            if solve(board):\r\n                return True\r\n\r\n            board[row][col] = 0\r\n\r\n    return False\r\n\r\n\r\n# Example Sudoku (0 = empty)\r\nboard = [\r\n    [5,3,0,0,7,0,0,0,0],\r\n    [6,0,0,1,9,5,0,0,0],\r\n    [0,9,8,0,0,0,0,6,0],\r\n    [8,0,0,0,6,0,0,0,3],\r\n    [4,0,0,8,0,3,0,0,1],\r\n    [7,0,0,0,2,0,0,0,6],\r\n    [0,6,0,0,0,0,2,8,0],\r\n    [0,0,0,4,1,9,0,0,5],\r\n    [0,0,0,0,8,0,0,7,9]\r\n]\r\n\r\nif solve(board):\r\n    print(\"Solved Sudoku:\")\r\n    print_board(board)\r\nelse:\r\n    print(\"No solution exists.\")','Accepted',66,29,'2026-07-23 09:59:03'),(5,9,1,'cpp','#include<iostream>\r\nusing namespace std;\r\nint main(){\r\nint n, target;\r\ncin>> n;\r\n\r\nint a[n];\r\nfor(int i=0; i<n; i++)\r\ncin>> a[i];\r\ncin>>target;\r\nfor (int i=0; i<n; i++){\r\nfor (int j=i+1; j<n; j++){\r\nif (a[i] +a[j] == target){\r\ncout<<i<<\"\"<<j;\r\nreturn 0;\r\n}\r\n}\r\n}\r\ncout<<\"no solution\";\r\nreturn 0;\r\n}','Accepted',30,23,'2026-07-23 10:24:33'),(6,9,1,'python','#include<iostream>\r\n#include<vector>\r\nusing namespace std;\r\nint main(){\r\nvector<int> nums-{2,7,11,15};\r\nint target=9\r\nfor (int i=0;i<nums.size();i++){\r\nfor (int j=i+1;j<nums.size();j++){\r\nif(nums[i]+ nums[j]==target){\r\ncout<<\"Indices: \"<<i<<\" \" <<endl;\r\nreturn 0;\r\n}\r\n}\r\n}\r\ncout<<\"No solution found.\"<<endl;\r\nreturn 0;\r\n}','Compilation Error',0,0,'2026-07-24 09:58:45'),(7,9,1,'python','#include<iostream>\r\n#include<vector>\r\nusing namespace std;\r\nint main(){\r\nvector<int> nums-{2,7,11,15};\r\nint target=9;\r\nfor (int i=0;i<nums.size();i++){\r\nfor (int j=i+1;j<nums.size();j++){\r\nif(nums[i]+ nums[j]==target){\r\ncout<<\"Indices: \"<<i<<\" \" <<endl;\r\nreturn 0;\r\n}\r\n}\r\n}\r\ncout<<\"No solution found.\"<<endl;\r\nreturn 0;\r\n}','Compilation Error',0,0,'2026-07-24 09:59:01'),(8,9,1,'python','#include<iostream>\r\n#include<vector>\r\nusing namespace std;\r\nint main(){\r\nvector<int> nums={2,7,11,15};\r\nint target=9\r\nfor (int i=0;i<nums.size();i++){\r\nfor (int j=i+1;j<nums.size();j++){\r\nif(nums[i]+ nums[j]==target){\r\ncout<<\"Indices: \"<<i<<\" \" <<endl;\r\nreturn 0;\r\n}\r\n}\r\n}\r\ncout<<\"No solution found.\"<<endl;\r\nreturn 0;\r\n}','Compilation Error',0,0,'2026-07-24 10:01:08'),(9,9,1,'cpp','#include<iostream>\r\n#include<vector>\r\nusing namespace std;\r\nint main(){\r\nvector<int> nums={2,7,11,15};\r\nint target=9;\r\nfor (int i=0;i<nums.size();i++){\r\nfor (int j=i+1;j<nums.size();j++){\r\nif(nums[i]+ nums[j]==target){\r\ncout<<\"Indices: \"<<i<<\" \" <<endl;\r\nreturn 0;\r\n}\r\n}\r\n}\r\ncout<<\"No solution found.\"<<endl;\r\nreturn 0;\r\n}','Accepted',17,17,'2026-07-24 10:01:52');
/*!40000 ALTER TABLE `coding_submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'Information Technology','IT','Department of Information Technology','2026-07-22 00:10:21'),(2,'Computer Science','CS','Department of Computer Science','2026-07-22 00:10:21'),(3,'Artificial Intelligence and Data Science','AIDS','Department of Artificial Intelligence and Data Science','2026-07-22 00:10:21'),(4,'Artificial Intelligence and Machine Learning','AIML','Department of Artificial Intelligence and Machine Learning','2026-07-22 00:10:21');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_logs`
--

DROP TABLE IF EXISTS `email_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `email_type` varchar(50) NOT NULL,
  `recipient` varchar(150) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `sent_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `email_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_logs`
--

LOCK TABLES `email_logs` WRITE;
/*!40000 ALTER TABLE `email_logs` DISABLE KEYS */;
INSERT INTO `email_logs` VALUES (4,9,'password_reset_otp','swaraghodke111@gmail.com','🔐 Your Password Reset OTP Code - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #F5F0E6; padding: 30px;\'>\n                <div style=\'max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 14px; padding: 32px; border: 1.5px solid #A67C52; box-shadow: 0 10px 25px rgba(0,0,0,0.08);\'>\n                    <div style=\'text-align: center; margin-bottom: 20px;\'>\n                        <h2 style=\'color: #A67C52; margin: 0; font-size: 1.5rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #7A5C48; font-size: 0.9rem; margin-top: 4px;\'>Password Reset Request</p>\n                    </div>\n                    <p style=\'color: #2E2E2E; font-size: 0.95rem;\'>Hello <strong>Swaranjali Ghodke</strong>,</p>\n                    <p style=\'color: #555555; font-size: 0.9rem; line-height: 1.6;\'>You requested to reset your password. Use the following 6-digit One-Time Password (OTP) to complete your verification:</p>\n                    \n                    <div style=\'background: rgba(166, 124, 82, 0.08); border: 2px dashed #A67C52; font-size: 2.4rem; font-weight: 800; letter-spacing: 10px; text-align: center; color: #7A5C48; padding: 18px; border-radius: 10px; margin: 24px 0;\'>\n                        196391\n                    </div>\n                    \n                    <p style=\'color: #888888; font-size: 0.82rem; text-align: center; margin-bottom: 0;\'>\n                        ⏰ This OTP is valid for <strong>15 minutes</strong>.<br>If you did not request a password reset, please ignore this email.\n                    </p>\n                </div>\n            </div>','2026-07-23 12:07:24'),(5,9,'password_reset_otp','swaraghodke111@gmail.com','🔐 Your Password Reset OTP Code - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #F5F0E6; padding: 30px;\'>\n                <div style=\'max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 14px; padding: 32px; border: 1.5px solid #A67C52; box-shadow: 0 10px 25px rgba(0,0,0,0.08);\'>\n                    <div style=\'text-align: center; margin-bottom: 20px;\'>\n                        <h2 style=\'color: #A67C52; margin: 0; font-size: 1.5rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #7A5C48; font-size: 0.9rem; margin-top: 4px;\'>Password Reset Request</p>\n                    </div>\n                    <p style=\'color: #2E2E2E; font-size: 0.95rem;\'>Hello <strong>Swaranjali Ghodke</strong>,</p>\n                    <p style=\'color: #555555; font-size: 0.9rem; line-height: 1.6;\'>You requested to reset your password. Use the following 6-digit One-Time Password (OTP) to complete your verification:</p>\n                    \n                    <div style=\'background: rgba(166, 124, 82, 0.08); border: 2px dashed #A67C52; font-size: 2.4rem; font-weight: 800; letter-spacing: 10px; text-align: center; color: #7A5C48; padding: 18px; border-radius: 10px; margin: 24px 0;\'>\n                        108942\n                    </div>\n                    \n                    <p style=\'color: #888888; font-size: 0.82rem; text-align: center; margin-bottom: 0;\'>\n                        ⏰ This OTP is valid for <strong>15 minutes</strong>.<br>If you did not request a password reset, please ignore this email.\n                    </p>\n                </div>\n            </div>','2026-07-23 14:05:19'),(6,9,'password_reset_otp','swaraghodke111@gmail.com','🔐 Your Password Reset OTP Code - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #F5F0E6; padding: 30px;\'>\n                <div style=\'max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 14px; padding: 32px; border: 1.5px solid #A67C52; box-shadow: 0 10px 25px rgba(0,0,0,0.08);\'>\n                    <div style=\'text-align: center; margin-bottom: 20px;\'>\n                        <h2 style=\'color: #A67C52; margin: 0; font-size: 1.5rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #7A5C48; font-size: 0.9rem; margin-top: 4px;\'>Password Reset Request</p>\n                    </div>\n                    <p style=\'color: #2E2E2E; font-size: 0.95rem;\'>Hello <strong>Swaranjali Ghodke</strong>,</p>\n                    <p style=\'color: #555555; font-size: 0.9rem; line-height: 1.6;\'>You requested to reset your password. Use the following 6-digit One-Time Password (OTP) to complete your verification:</p>\n                    \n                    <div style=\'background: rgba(166, 124, 82, 0.08); border: 2px dashed #A67C52; font-size: 2.4rem; font-weight: 800; letter-spacing: 10px; text-align: center; color: #7A5C48; padding: 18px; border-radius: 10px; margin: 24px 0;\'>\n                        268620\n                    </div>\n                    \n                    <p style=\'color: #888888; font-size: 0.82rem; text-align: center; margin-bottom: 0;\'>\n                        ⏰ This OTP is valid for <strong>15 minutes</strong>.<br>If you did not request a password reset, please ignore this email.\n                    </p>\n                </div>\n            </div>','2026-07-23 14:05:26'),(7,11,'password_reset_otp','sohamsolankar16@gmail.com','🔐 Your Password Reset OTP Code - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #F5F0E6; padding: 30px;\'>\n                <div style=\'max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 14px; padding: 32px; border: 1.5px solid #A67C52; box-shadow: 0 10px 25px rgba(0,0,0,0.08);\'>\n                    <div style=\'text-align: center; margin-bottom: 20px;\'>\n                        <h2 style=\'color: #A67C52; margin: 0; font-size: 1.5rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #7A5C48; font-size: 0.9rem; margin-top: 4px;\'>Password Reset Request</p>\n                    </div>\n                    <p style=\'color: #2E2E2E; font-size: 0.95rem;\'>Hello <strong>Soham Solankar</strong>,</p>\n                    <p style=\'color: #555555; font-size: 0.9rem; line-height: 1.6;\'>You requested to reset your password. Use the following 6-digit One-Time Password (OTP) to complete your verification:</p>\n                    \n                    <div style=\'background: rgba(166, 124, 82, 0.08); border: 2px dashed #A67C52; font-size: 2.4rem; font-weight: 800; letter-spacing: 10px; text-align: center; color: #7A5C48; padding: 18px; border-radius: 10px; margin: 24px 0;\'>\n                        667521\n                    </div>\n                    \n                    <p style=\'color: #888888; font-size: 0.82rem; text-align: center; margin-bottom: 0;\'>\n                        ⏰ This OTP is valid for <strong>15 minutes</strong>.<br>If you did not request a password reset, please ignore this email.\n                    </p>\n                </div>\n            </div>','2026-07-23 14:26:12'),(8,11,'password_reset_otp','sohamsolankar16@gmail.com','🔐 Your Password Reset OTP Code - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #F5F0E6; padding: 30px;\'>\n                <div style=\'max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 14px; padding: 32px; border: 1.5px solid #A67C52; box-shadow: 0 10px 25px rgba(0,0,0,0.08);\'>\n                    <div style=\'text-align: center; margin-bottom: 20px;\'>\n                        <h2 style=\'color: #A67C52; margin: 0; font-size: 1.5rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #7A5C48; font-size: 0.9rem; margin-top: 4px;\'>Password Reset Request</p>\n                    </div>\n                    <p style=\'color: #2E2E2E; font-size: 0.95rem;\'>Hello <strong>Soham Solankar</strong>,</p>\n                    <p style=\'color: #555555; font-size: 0.9rem; line-height: 1.6;\'>You requested to reset your password. Use the following 6-digit One-Time Password (OTP) to complete your verification:</p>\n                    \n                    <div style=\'background: rgba(166, 124, 82, 0.08); border: 2px dashed #A67C52; font-size: 2.4rem; font-weight: 800; letter-spacing: 10px; text-align: center; color: #7A5C48; padding: 18px; border-radius: 10px; margin: 24px 0;\'>\n                        532836\n                    </div>\n                    \n                    <p style=\'color: #888888; font-size: 0.82rem; text-align: center; margin-bottom: 0;\'>\n                        ⏰ This OTP is valid for <strong>15 minutes</strong>.<br>If you did not request a password reset, please ignore this email.\n                    </p>\n                </div>\n            </div>','2026-07-23 14:26:27'),(9,11,'password_reset_otp','sohamsolankar16@gmail.com','🔐 Your Password Reset OTP Code - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #F5F0E6; padding: 30px;\'>\n                <div style=\'max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 14px; padding: 32px; border: 1.5px solid #A67C52; box-shadow: 0 10px 25px rgba(0,0,0,0.08);\'>\n                    <div style=\'text-align: center; margin-bottom: 20px;\'>\n                        <h2 style=\'color: #A67C52; margin: 0; font-size: 1.5rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #7A5C48; font-size: 0.9rem; margin-top: 4px;\'>Password Reset Request</p>\n                    </div>\n                    <p style=\'color: #2E2E2E; font-size: 0.95rem;\'>Hello <strong>Soham Solankar</strong>,</p>\n                    <p style=\'color: #555555; font-size: 0.9rem; line-height: 1.6;\'>You requested to reset your password. Use the following 6-digit One-Time Password (OTP) to complete your verification:</p>\n                    \n                    <div style=\'background: rgba(166, 124, 82, 0.08); border: 2px dashed #A67C52; font-size: 2.4rem; font-weight: 800; letter-spacing: 10px; text-align: center; color: #7A5C48; padding: 18px; border-radius: 10px; margin: 24px 0;\'>\n                        236811\n                    </div>\n                    \n                    <p style=\'color: #888888; font-size: 0.82rem; text-align: center; margin-bottom: 0;\'>\n                        ⏰ This OTP is valid for <strong>15 minutes</strong>.<br>If you did not request a password reset, please ignore this email.\n                    </p>\n                </div>\n            </div>','2026-07-23 14:26:42'),(10,13,'password_reset_otp','navyasingh8002@gmail.com','🔐 Your Password Reset OTP Code - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #F5F0E6; padding: 30px;\'>\n                <div style=\'max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 14px; padding: 32px; border: 1.5px solid #A67C52; box-shadow: 0 10px 25px rgba(0,0,0,0.08);\'>\n                    <div style=\'text-align: center; margin-bottom: 20px;\'>\n                        <h2 style=\'color: #A67C52; margin: 0; font-size: 1.5rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #7A5C48; font-size: 0.9rem; margin-top: 4px;\'>Password Reset Request</p>\n                    </div>\n                    <p style=\'color: #2E2E2E; font-size: 0.95rem;\'>Hello <strong>Navya Singh</strong>,</p>\n                    <p style=\'color: #555555; font-size: 0.9rem; line-height: 1.6;\'>You requested to reset your password. Use the following 6-digit One-Time Password (OTP) to complete your verification:</p>\n                    \n                    <div style=\'background: rgba(166, 124, 82, 0.08); border: 2px dashed #A67C52; font-size: 2.4rem; font-weight: 800; letter-spacing: 10px; text-align: center; color: #7A5C48; padding: 18px; border-radius: 10px; margin: 24px 0;\'>\n                        386873\n                    </div>\n                    \n                    <p style=\'color: #888888; font-size: 0.82rem; text-align: center; margin-bottom: 0;\'>\n                        ⏰ This OTP is valid for <strong>15 minutes</strong>.<br>If you did not request a password reset, please ignore this email.\n                    </p>\n                </div>\n            </div>','2026-07-23 14:28:12'),(11,9,'password_reset_otp','swaraghodke111@gmail.com','🔐 Your Password Reset OTP Code - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #F5F0E6; padding: 30px;\'>\n                <div style=\'max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 14px; padding: 32px; border: 1.5px solid #A67C52; box-shadow: 0 10px 25px rgba(0,0,0,0.08);\'>\n                    <div style=\'text-align: center; margin-bottom: 20px;\'>\n                        <h2 style=\'color: #A67C52; margin: 0; font-size: 1.5rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #7A5C48; font-size: 0.9rem; margin-top: 4px;\'>Password Reset Request</p>\n                    </div>\n                    <p style=\'color: #2E2E2E; font-size: 0.95rem;\'>Hello <strong>Swaranjali Ghodke</strong>,</p>\n                    <p style=\'color: #555555; font-size: 0.9rem; line-height: 1.6;\'>You requested to reset your password. Use the following 6-digit One-Time Password (OTP) to complete your verification:</p>\n                    \n                    <div style=\'background: rgba(166, 124, 82, 0.08); border: 2px dashed #A67C52; font-size: 2.4rem; font-weight: 800; letter-spacing: 10px; text-align: center; color: #7A5C48; padding: 18px; border-radius: 10px; margin: 24px 0;\'>\n                        123790\n                    </div>\n                    \n                    <p style=\'color: #888888; font-size: 0.82rem; text-align: center; margin-bottom: 0;\'>\n                        ⏰ This OTP is valid for <strong>15 minutes</strong>.<br>If you did not request a password reset, please ignore this email.\n                    </p>\n                </div>\n            </div>','2026-07-23 14:54:32'),(12,9,'password_reset_otp','swaraghodke111@gmail.com','🔐 Your Password Reset OTP Code - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #F5F0E6; padding: 30px;\'>\n                <div style=\'max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 14px; padding: 32px; border: 1.5px solid #A67C52; box-shadow: 0 10px 25px rgba(0,0,0,0.08);\'>\n                    <div style=\'text-align: center; margin-bottom: 20px;\'>\n                        <h2 style=\'color: #A67C52; margin: 0; font-size: 1.5rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #7A5C48; font-size: 0.9rem; margin-top: 4px;\'>Password Reset Request</p>\n                    </div>\n                    <p style=\'color: #2E2E2E; font-size: 0.95rem;\'>Hello <strong>Swaranjali Omprakash Ghodke</strong>,</p>\n                    <p style=\'color: #555555; font-size: 0.9rem; line-height: 1.6;\'>You requested to reset your password. Use the following 6-digit One-Time Password (OTP) to complete your verification:</p>\n                    \n                    <div style=\'background: rgba(166, 124, 82, 0.08); border: 2px dashed #A67C52; font-size: 2.4rem; font-weight: 800; letter-spacing: 10px; text-align: center; color: #7A5C48; padding: 18px; border-radius: 10px; margin: 24px 0;\'>\n                        671888\n                    </div>\n                    \n                    <p style=\'color: #888888; font-size: 0.82rem; text-align: center; margin-bottom: 0;\'>\n                        ⏰ This OTP is valid for <strong>15 minutes</strong>.<br>If you did not request a password reset, please ignore this email.\n                    </p>\n                </div>\n            </div>','2026-07-24 10:11:04'),(13,9,'login_alert','swaraghodke111@gmail.com','🔐 Security Alert: Successful Login to Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; padding: 20px; color: #1e293b;\'>\n                <h2 style=\'color: #10b981;\'>🔐 Successful Account Login Alert</h2>\n                <p>Hello <strong>Swaranjali Omprakash Ghodke</strong>,</p>\n                <p>You have successfully logged into your account on the Online Examination Portal.</p>\n                <div style=\'background: #f8fafc; padding: 15px; border-left: 4px solid #10b981; border-radius: 6px; margin: 15px 0;\'>\n                    <p style=\'margin: 0;\'><strong>Account Email:</strong> swaraghodke111@gmail.com</p>\n                    <p style=\'margin: 6px 0 0 0;\'><strong>Portal Role:</strong> Student</p>\n                    <p style=\'margin: 6px 0 0 0;\'><strong>Timestamp:</strong> July 24, 2026, 11:07 am</p>\n                    <p style=\'margin: 6px 0 0 0;\'><strong>IP Address:</strong> 127.0.0.1</p>\n                </div>\n                <p style=\'font-size: 0.85rem; color: #64748b;\'>If this was you, no action is needed. If you did not log in, please change your password immediately.</p>\n            </div>','2026-07-24 11:07:35'),(14,9,'login_alert','swaraghodke111@gmail.com','🔐 Security Alert: Successful Login to Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; padding: 20px; color: #1e293b;\'>\n                <h2 style=\'color: #10b981;\'>🔐 Successful Account Login Alert</h2>\n                <p>Hello <strong>Swaranjali Omprakash Ghodke</strong>,</p>\n                <p>You have successfully logged into your account on the Online Examination Portal.</p>\n                <div style=\'background: #f8fafc; padding: 15px; border-left: 4px solid #10b981; border-radius: 6px; margin: 15px 0;\'>\n                    <p style=\'margin: 0;\'><strong>Account Email:</strong> swaraghodke111@gmail.com</p>\n                    <p style=\'margin: 6px 0 0 0;\'><strong>Portal Role:</strong> Student</p>\n                    <p style=\'margin: 6px 0 0 0;\'><strong>Timestamp:</strong> July 24, 2026, 11:09 am</p>\n                    <p style=\'margin: 6px 0 0 0;\'><strong>IP Address:</strong> 127.0.0.1</p>\n                </div>\n                <p style=\'font-size: 0.85rem; color: #64748b;\'>If this was you, no action is needed. If you did not log in, please change your password immediately.</p>\n            </div>','2026-07-24 11:09:38'),(15,1,'login_alert','balajichaughule@gmail.com','🔐 Security Alert: Successful Login to Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; padding: 20px; color: #1e293b;\'>\n                <h2 style=\'color: #10b981;\'>🔐 Successful Account Login Alert</h2>\n                <p>Hello <strong>Balaji Chaughule</strong>,</p>\n                <p>You have successfully logged into your account on the Online Examination Portal.</p>\n                <div style=\'background: #f8fafc; padding: 15px; border-left: 4px solid #10b981; border-radius: 6px; margin: 15px 0;\'>\n                    <p style=\'margin: 0;\'><strong>Account Email:</strong> balajichaughule@gmail.com</p>\n                    <p style=\'margin: 6px 0 0 0;\'><strong>Portal Role:</strong> Admin</p>\n                    <p style=\'margin: 6px 0 0 0;\'><strong>Timestamp:</strong> July 24, 2026, 11:14 am</p>\n                    <p style=\'margin: 6px 0 0 0;\'><strong>IP Address:</strong> 127.0.0.1</p>\n                </div>\n                <p style=\'font-size: 0.85rem; color: #64748b;\'>If this was you, no action is needed. If you did not log in, please change your password immediately.</p>\n            </div>','2026-07-24 11:14:29'),(16,1,'login_alert','balajichaughule@gmail.com','🔐 Account Login Details & Alert - Online Examination Portal','<h1>Test Login Email</h1>','2026-07-24 11:19:58'),(17,18,'registration_welcome','badakrohit@gmail.com','🎉 Welcome to Online Examination Portal - Account Details','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #f8fafc; padding: 25px;\'>\n                <div style=\'max-width: 560px; margin: 0 auto; background: #ffffff; border-radius: 16px; padding: 32px; border: 1px solid #e2e8f0; box-shadow: 0 10px 25px rgba(0,0,0,0.06);\'>\n                    <div style=\'text-align: center; margin-bottom: 24px;\'>\n                        <div style=\'display: inline-block; width: 56px; height: 56px; line-height: 56px; border-radius: 16px; background: rgba(255, 107, 0, 0.1); color: #ff6b00; font-size: 1.8rem; text-align: center;\'>🎓</div>\n                        <h2 style=\'color: #1e293b; margin: 12px 0 4px 0; font-size: 1.4rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #ff6b00; font-weight: 600; font-size: 0.95rem; margin: 0;\'>🎉 Account Created Successfully</p>\n                    </div>\n                    \n                    <p style=\'color: #1e293b; font-size: 0.95rem;\'>Hello <strong>RuBy Official</strong>,</p>\n                    <p style=\'color: #475569; font-size: 0.9rem; line-height: 1.6;\'>Welcome to the Online Examination Portal! Here are your account registration & login details:</p>\n                    \n                    <div style=\'background: #f8fafc; border: 1.5px solid #e2e8f0; border-left: 4px solid #ff6b00; padding: 18px; border-radius: 10px; margin: 20px 0;\'>\n                        <table style=\'width: 100%; border-collapse: collapse; font-size: 0.9rem; color: #1e293b;\'>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b; width: 140px;\'><strong>Full Name:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600;\'>RuBy Official</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Registered Email:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600; color: #ff6b00;\'>badakrohit@gmail.com</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Portal Role:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600; color: #10b981;\'>Student Portal</td>\n                            </tr>\n                        </table>\n                    </div>\n\n                    <div style=\'text-align: center; margin-top: 24px; margin-bottom: 20px;\'>\n                        <a href=\'http://localhost:8001/auth/login.php\' style=\'display: inline-block; padding: 12px 28px; background: #ff6b00; color: #ffffff; text-decoration: none; border-radius: 10px; font-weight: 700; font-size: 0.95rem; box-shadow: 0 4px 14px rgba(255, 107, 0, 0.3);\'>Click Here to Login →</a>\n                    </div>\n                </div>\n            </div>','2026-07-24 11:21:18'),(18,18,'login_alert','badakrohit@gmail.com','🔐 Account Login Details & Alert - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #f8fafc; padding: 25px;\'>\n                <div style=\'max-width: 560px; margin: 0 auto; background: #ffffff; border-radius: 16px; padding: 32px; border: 1px solid #e2e8f0; box-shadow: 0 10px 25px rgba(0,0,0,0.06);\'>\n                    <div style=\'text-align: center; margin-bottom: 24px;\'>\n                        <div style=\'display: inline-block; width: 56px; height: 56px; line-height: 56px; border-radius: 16px; background: rgba(255, 107, 0, 0.1); color: #ff6b00; font-size: 1.8rem; text-align: center;\'>🎓</div>\n                        <h2 style=\'color: #1e293b; margin: 12px 0 4px 0; font-size: 1.4rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #10b981; font-weight: 600; font-size: 0.95rem; margin: 0;\'>✅ Account Login Successful</p>\n                    </div>\n                    \n                    <p style=\'color: #1e293b; font-size: 0.95rem;\'>Hello <strong>RuBy Official</strong>,</p>\n                    <p style=\'color: #475569; font-size: 0.9rem; line-height: 1.6;\'>You have successfully logged into your account on the Online Examination Portal. Here are your account login details:</p>\n                    \n                    <div style=\'background: #f8fafc; border: 1.5px solid #e2e8f0; border-left: 4px solid #ff6b00; padding: 18px; border-radius: 10px; margin: 20px 0;\'>\n                        <table style=\'width: 100%; border-collapse: collapse; font-size: 0.9rem; color: #1e293b;\'>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b; width: 140px;\'><strong>Account Holder:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600;\'>RuBy Official</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Registered Email:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600; color: #ff6b00;\'>badakrohit@gmail.com</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Portal Role:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600; color: #6366f1;\'>Student Portal</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Login Time:</strong></td>\n                                <td style=\'padding: 6px 0;\'>July 24, 2026, 11:21 am</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>IP Address:</strong></td>\n                                <td style=\'padding: 6px 0; font-family: monospace;\'>127.0.0.1</td>\n                            </tr>\n                        </table>\n                    </div>\n\n                    <div style=\'text-align: center; margin-top: 24px; margin-bottom: 20px;\'>\n                        <a href=\'http://localhost:8001/student/dashboard.php\' style=\'display: inline-block; padding: 12px 28px; background: #ff6b00; color: #ffffff; text-decoration: none; border-radius: 10px; font-weight: 700; font-size: 0.95rem; box-shadow: 0 4px 14px rgba(255, 107, 0, 0.3);\'>Go to Your Dashboard →</a>\n                    </div>\n\n                    <hr style=\'border: none; border-top: 1px solid #e2e8f0; margin: 20px 0;\'>\n                    <p style=\'color: #94a3b8; font-size: 0.8rem; text-align: center; margin: 0;\'>\n                        If you did not perform this login, please <a href=\'http://localhost:8001/auth/forgot_password.php\' style=\'color: #ef4444; text-decoration: underline;\'>reset your password immediately</a>.\n                    </p>\n                </div>\n            </div>','2026-07-24 11:21:58'),(19,1,'login_alert','balajichaughule@gmail.com','🔐 Account Login Details & Alert - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #f8fafc; padding: 25px;\'>\n                <div style=\'max-width: 560px; margin: 0 auto; background: #ffffff; border-radius: 16px; padding: 32px; border: 1px solid #e2e8f0; box-shadow: 0 10px 25px rgba(0,0,0,0.06);\'>\n                    <div style=\'text-align: center; margin-bottom: 24px;\'>\n                        <div style=\'display: inline-block; width: 56px; height: 56px; line-height: 56px; border-radius: 16px; background: rgba(255, 107, 0, 0.1); color: #ff6b00; font-size: 1.8rem; text-align: center;\'>🎓</div>\n                        <h2 style=\'color: #1e293b; margin: 12px 0 4px 0; font-size: 1.4rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #10b981; font-weight: 600; font-size: 0.95rem; margin: 0;\'>✅ Account Login Successful</p>\n                    </div>\n                    \n                    <p style=\'color: #1e293b; font-size: 0.95rem;\'>Hello <strong>Balaji Chaughule</strong>,</p>\n                    <p style=\'color: #475569; font-size: 0.9rem; line-height: 1.6;\'>You have successfully logged into your account on the Online Examination Portal. Here are your account login details:</p>\n                    \n                    <div style=\'background: #f8fafc; border: 1.5px solid #e2e8f0; border-left: 4px solid #ff6b00; padding: 18px; border-radius: 10px; margin: 20px 0;\'>\n                        <table style=\'width: 100%; border-collapse: collapse; font-size: 0.9rem; color: #1e293b;\'>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b; width: 140px;\'><strong>Account Holder:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600;\'>Balaji Chaughule</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Registered Email:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600; color: #ff6b00;\'>balajichaughule@gmail.com</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Portal Role:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600; color: #6366f1;\'>Admin Portal</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Login Time:</strong></td>\n                                <td style=\'padding: 6px 0;\'>July 24, 2026, 11:24 am</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>IP Address:</strong></td>\n                                <td style=\'padding: 6px 0; font-family: monospace;\'>127.0.0.1</td>\n                            </tr>\n                        </table>\n                    </div>\n\n                    <div style=\'text-align: center; margin-top: 24px; margin-bottom: 20px;\'>\n                        <a href=\'http://localhost:8001/admin/dashboard.php\' style=\'display: inline-block; padding: 12px 28px; background: #ff6b00; color: #ffffff; text-decoration: none; border-radius: 10px; font-weight: 700; font-size: 0.95rem; box-shadow: 0 4px 14px rgba(255, 107, 0, 0.3);\'>Go to Your Dashboard →</a>\n                    </div>\n\n                    <hr style=\'border: none; border-top: 1px solid #e2e8f0; margin: 20px 0;\'>\n                    <p style=\'color: #94a3b8; font-size: 0.8rem; text-align: center; margin: 0;\'>\n                        If you did not perform this login, please <a href=\'http://localhost:8001/auth/forgot_password.php\' style=\'color: #ef4444; text-decoration: underline;\'>reset your password immediately</a>.\n                    </p>\n                </div>\n            </div>','2026-07-24 11:24:13'),(20,1,'login_alert','balajichaughule@gmail.com','Instant Login Email Test','<h1>Fast Login</h1>','2026-07-24 11:30:20'),(21,1,'login_alert','balajichaughule@gmail.com','🔐 Account Login Details & Alert - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #f8fafc; padding: 25px;\'>\n                <div style=\'max-width: 560px; margin: 0 auto; background: #ffffff; border-radius: 16px; padding: 32px; border: 1px solid #e2e8f0; box-shadow: 0 10px 25px rgba(0,0,0,0.06);\'>\n                    <div style=\'text-align: center; margin-bottom: 24px;\'>\n                        <div style=\'display: inline-block; width: 56px; height: 56px; line-height: 56px; border-radius: 16px; background: rgba(255, 107, 0, 0.1); color: #ff6b00; font-size: 1.8rem; text-align: center;\'>🎓</div>\n                        <h2 style=\'color: #1e293b; margin: 12px 0 4px 0; font-size: 1.4rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #10b981; font-weight: 600; font-size: 0.95rem; margin: 0;\'>✅ Account Login Successful</p>\n                    </div>\n                    \n                    <p style=\'color: #1e293b; font-size: 0.95rem;\'>Hello <strong>Balaji Chaughule</strong>,</p>\n                    <p style=\'color: #475569; font-size: 0.9rem; line-height: 1.6;\'>You have successfully logged into your account on the Online Examination Portal. Here are your account login details:</p>\n                    \n                    <div style=\'background: #f8fafc; border: 1.5px solid #e2e8f0; border-left: 4px solid #ff6b00; padding: 18px; border-radius: 10px; margin: 20px 0;\'>\n                        <table style=\'width: 100%; border-collapse: collapse; font-size: 0.9rem; color: #1e293b;\'>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b; width: 140px;\'><strong>Account Holder:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600;\'>Balaji Chaughule</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Registered Email:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600; color: #ff6b00;\'>balajichaughule@gmail.com</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Portal Role:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600; color: #6366f1;\'>Admin Portal</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Login Time:</strong></td>\n                                <td style=\'padding: 6px 0;\'>July 24, 2026, 11:30 am</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>IP Address:</strong></td>\n                                <td style=\'padding: 6px 0; font-family: monospace;\'>127.0.0.1</td>\n                            </tr>\n                        </table>\n                    </div>\n\n                    <div style=\'text-align: center; margin-top: 24px; margin-bottom: 20px;\'>\n                        <a href=\'http://localhost:8001/admin/dashboard.php\' style=\'display: inline-block; padding: 12px 28px; background: #ff6b00; color: #ffffff; text-decoration: none; border-radius: 10px; font-weight: 700; font-size: 0.95rem; box-shadow: 0 4px 14px rgba(255, 107, 0, 0.3);\'>Go to Your Dashboard →</a>\n                    </div>\n\n                    <hr style=\'border: none; border-top: 1px solid #e2e8f0; margin: 20px 0;\'>\n                    <p style=\'color: #94a3b8; font-size: 0.8rem; text-align: center; margin: 0;\'>\n                        If you did not perform this login, please <a href=\'http://localhost:8001/auth/forgot_password.php\' style=\'color: #ef4444; text-decoration: underline;\'>reset your password immediately</a>.\n                    </p>\n                </div>\n            </div>','2026-07-24 11:30:42'),(22,1,'login_alert','balajichaughule@gmail.com','🔐 Account Login Details & Alert - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #f8fafc; padding: 25px;\'>\n                <div style=\'max-width: 560px; margin: 0 auto; background: #ffffff; border-radius: 16px; padding: 32px; border: 1px solid #e2e8f0; box-shadow: 0 10px 25px rgba(0,0,0,0.06);\'>\n                    <div style=\'text-align: center; margin-bottom: 24px;\'>\n                        <div style=\'display: inline-block; width: 56px; height: 56px; line-height: 56px; border-radius: 16px; background: rgba(255, 107, 0, 0.1); color: #ff6b00; font-size: 1.8rem; text-align: center;\'>🎓</div>\n                        <h2 style=\'color: #1e293b; margin: 12px 0 4px 0; font-size: 1.4rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #10b981; font-weight: 600; font-size: 0.95rem; margin: 0;\'>✅ Account Login Successful</p>\n                    </div>\n                    \n                    <p style=\'color: #1e293b; font-size: 0.95rem;\'>Hello <strong>Balaji Chaughule</strong>,</p>\n                    <p style=\'color: #475569; font-size: 0.9rem; line-height: 1.6;\'>You have successfully logged into your account on the Online Examination Portal. Here are your account login details:</p>\n                    \n                    <div style=\'background: #f8fafc; border: 1.5px solid #e2e8f0; border-left: 4px solid #ff6b00; padding: 18px; border-radius: 10px; margin: 20px 0;\'>\n                        <table style=\'width: 100%; border-collapse: collapse; font-size: 0.9rem; color: #1e293b;\'>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b; width: 140px;\'><strong>Account Holder:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600;\'>Balaji Chaughule</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Registered Email:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600; color: #ff6b00;\'>balajichaughule@gmail.com</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Portal Role:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600; color: #6366f1;\'>Admin Portal</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Login Time:</strong></td>\n                                <td style=\'padding: 6px 0;\'>July 24, 2026, 12:07 pm</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>IP Address:</strong></td>\n                                <td style=\'padding: 6px 0; font-family: monospace;\'>127.0.0.1</td>\n                            </tr>\n                        </table>\n                    </div>\n\n                    <div style=\'text-align: center; margin-top: 24px; margin-bottom: 20px;\'>\n                        <a href=\'http://localhost:8001/admin/dashboard.php\' style=\'display: inline-block; padding: 12px 28px; background: #ff6b00; color: #ffffff; text-decoration: none; border-radius: 10px; font-weight: 700; font-size: 0.95rem; box-shadow: 0 4px 14px rgba(255, 107, 0, 0.3);\'>Go to Your Dashboard →</a>\n                    </div>\n\n                    <hr style=\'border: none; border-top: 1px solid #e2e8f0; margin: 20px 0;\'>\n                    <p style=\'color: #94a3b8; font-size: 0.8rem; text-align: center; margin: 0;\'>\n                        If you did not perform this login, please <a href=\'http://localhost:8001/auth/forgot_password.php\' style=\'color: #ef4444; text-decoration: underline;\'>reset your password immediately</a>.\n                    </p>\n                </div>\n            </div>','2026-07-24 12:07:21'),(23,1,'login_alert','balajichaughule@gmail.com','🔐 Account Login Details & Alert - Online Examination Portal','\n            <div style=\'font-family: Poppins, Arial, sans-serif; background-color: #f8fafc; padding: 25px;\'>\n                <div style=\'max-width: 560px; margin: 0 auto; background: #ffffff; border-radius: 16px; padding: 32px; border: 1px solid #e2e8f0; box-shadow: 0 10px 25px rgba(0,0,0,0.06);\'>\n                    <div style=\'text-align: center; margin-bottom: 24px;\'>\n                        <div style=\'display: inline-block; width: 56px; height: 56px; line-height: 56px; border-radius: 16px; background: rgba(255, 107, 0, 0.1); color: #ff6b00; font-size: 1.8rem; text-align: center;\'>🎓</div>\n                        <h2 style=\'color: #1e293b; margin: 12px 0 4px 0; font-size: 1.4rem;\'>Online Examination Portal</h2>\n                        <p style=\'color: #10b981; font-weight: 600; font-size: 0.95rem; margin: 0;\'>✅ Account Login Successful</p>\n                    </div>\n                    \n                    <p style=\'color: #1e293b; font-size: 0.95rem;\'>Hello <strong>Balaji Chaughule</strong>,</p>\n                    <p style=\'color: #475569; font-size: 0.9rem; line-height: 1.6;\'>You have successfully logged into your account on the Online Examination Portal. Here are your account login details:</p>\n                    \n                    <div style=\'background: #f8fafc; border: 1.5px solid #e2e8f0; border-left: 4px solid #ff6b00; padding: 18px; border-radius: 10px; margin: 20px 0;\'>\n                        <table style=\'width: 100%; border-collapse: collapse; font-size: 0.9rem; color: #1e293b;\'>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b; width: 140px;\'><strong>Account Holder:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600;\'>Balaji Chaughule</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Registered Email:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600; color: #ff6b00;\'>balajichaughule@gmail.com</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Portal Role:</strong></td>\n                                <td style=\'padding: 6px 0; font-weight: 600; color: #6366f1;\'>Admin Portal</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>Login Time:</strong></td>\n                                <td style=\'padding: 6px 0;\'>July 24, 2026, 12:17 pm</td>\n                            </tr>\n                            <tr>\n                                <td style=\'padding: 6px 0; color: #64748b;\'><strong>IP Address:</strong></td>\n                                <td style=\'padding: 6px 0; font-family: monospace;\'>127.0.0.1</td>\n                            </tr>\n                        </table>\n                    </div>\n\n                    <div style=\'text-align: center; margin-top: 24px; margin-bottom: 20px;\'>\n                        <a href=\'http://localhost:8001/admin/dashboard.php\' style=\'display: inline-block; padding: 12px 28px; background: #ff6b00; color: #ffffff; text-decoration: none; border-radius: 10px; font-weight: 700; font-size: 0.95rem; box-shadow: 0 4px 14px rgba(255, 107, 0, 0.3);\'>Go to Your Dashboard →</a>\n                    </div>\n\n                    <hr style=\'border: none; border-top: 1px solid #e2e8f0; margin: 20px 0;\'>\n                    <p style=\'color: #94a3b8; font-size: 0.8rem; text-align: center; margin: 0;\'>\n                        If you did not perform this login, please <a href=\'http://localhost:8001/auth/forgot_password.php\' style=\'color: #ef4444; text-decoration: underline;\'>reset your password immediately</a>.\n                    </p>\n                </div>\n            </div>','2026-07-24 12:17:55');
/*!40000 ALTER TABLE `email_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_attempts`
--

DROP TABLE IF EXISTS `exam_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_attempts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `exam_id` int NOT NULL,
  `start_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('in_progress','submitted','expired') NOT NULL DEFAULT 'in_progress',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_attempt` (`user_id`,`exam_id`),
  KEY `exam_id` (`exam_id`),
  CONSTRAINT `exam_attempts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `exam_attempts_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_attempts`
--

LOCK TABLES `exam_attempts` WRITE;
/*!40000 ALTER TABLE `exam_attempts` DISABLE KEYS */;
INSERT INTO `exam_attempts` VALUES (33,9,5,'2026-07-23 11:08:30','in_progress'),(34,9,1,'2026-07-23 11:19:18','in_progress'),(35,9,2,'2026-07-23 11:19:18','submitted'),(37,9,6,'2026-07-23 11:19:18','submitted'),(42,9,7,'2026-07-24 00:27:36','submitted');
/*!40000 ALTER TABLE `exam_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exams`
--

DROP TABLE IF EXISTS `exams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text,
  `duration` int NOT NULL DEFAULT '60' COMMENT 'minutes',
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `total_marks` int NOT NULL DEFAULT '0',
  `pass_marks` int NOT NULL DEFAULT '0',
  `created_by` int NOT NULL,
  `is_published` tinyint(1) NOT NULL DEFAULT '0',
  `randomize` tinyint(1) NOT NULL DEFAULT '1',
  `status` enum('draft','scheduled','active','completed') NOT NULL DEFAULT 'draft',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `exams_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exams`
--

LOCK TABLES `exams` WRITE;
/*!40000 ALTER TABLE `exams` DISABLE KEYS */;
INSERT INTO `exams` VALUES (1,'Class Test','CPP quiz exam',10,'2028-12-31 10:00:00','2028-12-31 12:00:00',2,10,1,1,1,'scheduled','2026-07-21 13:54:16'),(2,'Coding & Programming MCQ Quiz','A comprehensive test containing 15 coding and programming concepts quiz questions created by the Administrator.',30,'2026-07-24 00:40:00','2026-07-24 12:10:00',15,8,1,1,1,'scheduled','2026-07-21 14:06:33'),(3,'er','ggh',60,'2026-07-22 00:36:00','2026-07-22 00:37:00',0,0,1,0,0,'draft','2026-07-22 00:37:05'),(5,'ETE','End Term Examination FY BTECH 2026-27',60,'2026-07-23 10:50:00','2026-07-23 11:20:00',2,30,6,1,1,'scheduled','2026-07-23 10:36:37'),(6,'class test 2','sy',60,'2026-07-23 00:00:00','2026-07-24 23:59:59',1,0,6,1,1,'scheduled','2026-07-23 10:59:05'),(7,'Class Test V','do not copy.',15,'2026-07-24 00:00:00','2026-07-24 23:59:59',20,10,6,1,1,'scheduled','2026-07-24 00:21:19');
/*!40000 ALTER TABLE `exams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculty_profiles`
--

DROP TABLE IF EXISTS `faculty_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faculty_profiles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `faculty_id` varchar(50) NOT NULL,
  `department_id` int DEFAULT NULL,
  `designation` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `office_location` varchar(100) DEFAULT NULL,
  `status` enum('active','inactive','suspended') NOT NULL DEFAULT 'active',
  `joining_date` date NOT NULL,
  `qualification` varchar(255) NOT NULL,
  `bio` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `faculty_id` (`faculty_id`),
  KEY `idx_faculty_dept` (`department_id`),
  CONSTRAINT `faculty_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `faculty_profiles_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculty_profiles`
--

LOCK TABLES `faculty_profiles` WRITE;
/*!40000 ALTER TABLE `faculty_profiles` DISABLE KEYS */;
INSERT INTO `faculty_profiles` VALUES (1,6,'IT2601',1,'professor','8965709754','zeal college of engineering','active','2026-07-22','BE',NULL,'2026-07-22 00:15:22'),(2,17,'IT2602',1,'professor','8765496782','zeal college of engineering','active','2026-07-23','Ph.D in mathematics',NULL,'2026-07-23 23:48:59');
/*!40000 ALTER TABLE `faculty_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `id` int NOT NULL AUTO_INCREMENT,
  `faculty_id` int NOT NULL,
  `student_id` int NOT NULL,
  `exam_id` int NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `faculty_id` (`faculty_id`),
  KEY `student_id` (`student_id`),
  KEY `exam_id` (`exam_id`),
  CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`faculty_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `feedback_ibfk_3` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `help_queries`
--

DROP TABLE IF EXISTS `help_queries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `help_queries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `user_name` varchar(255) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `query_text` text NOT NULL,
  `admin_reply` text,
  `replied_by` int DEFAULT NULL,
  `replied_at` datetime DEFAULT NULL,
  `status` enum('pending','replied') DEFAULT 'pending',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `help_queries_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_queries`
--

LOCK TABLES `help_queries` WRITE;
/*!40000 ALTER TABLE `help_queries` DISABLE KEYS */;
INSERT INTO `help_queries` VALUES (1,9,'Swaranjali Ghodke','swaraghodke111@gmail.com','How do I download my exam certificate after passing?','You can view and download your certificate directly from your My Results tab under Examination History!',1,'2026-07-23 11:48:21','replied','2026-07-23 11:48:21');
/*!40000 ALTER TABLE `help_queries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=231 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (2,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-21 13:45:43'),(3,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-21 13:51:39'),(6,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-21 14:08:10'),(8,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-21 14:24:15'),(10,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-21 14:34:33'),(12,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-21 15:02:59'),(14,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-21 16:30:07'),(16,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-21 23:16:04'),(20,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-21 23:59:48'),(25,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-22 00:04:53'),(26,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-22 01:06:27'),(28,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-22 09:33:49'),(29,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-22 09:38:04'),(30,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-22 09:43:33'),(35,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-22 09:48:14'),(36,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-22 09:51:17'),(43,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-22 12:58:42'),(45,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-22 13:19:05'),(47,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-22 13:36:47'),(48,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-22 13:37:59'),(49,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-22 13:38:42'),(50,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-22 13:43:56'),(51,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-22 13:46:44'),(55,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-22 14:28:32'),(57,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-22 14:36:19'),(59,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-22 14:43:38'),(61,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-22 14:49:45'),(63,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-22 15:13:27'),(64,1,'Welcome back, Super Admin! You have logged in successfully.',1,'2026-07-22 15:16:04'),(73,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 00:34:56'),(77,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 00:45:38'),(78,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 01:05:41'),(82,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 09:26:50'),(83,9,'Welcome to Exam Portal, Swaranjali Ghodke! Your account has been created successfully.',1,'2026-07-23 09:30:27'),(84,9,'🎉 Your email address has been verified successfully. Welcome to the portal!',1,'2026-07-23 09:30:30'),(85,10,'Welcome to Exam Portal, Shrawani Rokde! Your account has been created successfully.',1,'2026-07-23 09:32:03'),(86,10,'🎉 Your email address has been verified successfully. Welcome to the portal!',1,'2026-07-23 09:32:04'),(87,11,'Welcome to Exam Portal, Soham Solankar! Your account has been created successfully.',1,'2026-07-23 09:34:22'),(88,11,'🎉 Your email address has been verified successfully. Welcome to the portal!',1,'2026-07-23 09:34:23'),(89,12,'Welcome to Exam Portal, Suchita Shihore! Your account has been created successfully.',1,'2026-07-23 09:35:30'),(90,12,'🎉 Your email address has been verified successfully. Welcome to the portal!',1,'2026-07-23 09:35:32'),(91,13,'Welcome to Exam Portal, Navya Singh! Your account has been created successfully.',1,'2026-07-23 09:36:47'),(92,13,'🎉 Your email address has been verified successfully. Welcome to the portal!',1,'2026-07-23 09:36:48'),(93,14,'Welcome to Exam Portal, Siddhesh Dhavale! Your account has been created successfully.',0,'2026-07-23 09:38:43'),(94,14,'🎉 Your email address has been verified successfully. Welcome to the portal!',0,'2026-07-23 09:38:45'),(95,15,'Welcome to Exam Portal, Shrinidhi Shinde! Your account has been created successfully.',1,'2026-07-23 09:39:48'),(96,15,'🎉 Your email address has been verified successfully. Welcome to the portal!',1,'2026-07-23 09:39:57'),(97,16,'Welcome to Exam Portal, Tejaswini Shinde! Your account has been created successfully.',0,'2026-07-23 09:41:53'),(98,16,'🎉 Your email address has been verified successfully. Welcome to the portal!',0,'2026-07-23 09:41:54'),(99,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 09:42:09'),(100,11,'Welcome back, Soham Solankar! You have logged in successfully.',1,'2026-07-23 09:46:14'),(101,10,'Welcome back, Shrawani Rokde! You have logged in successfully.',1,'2026-07-23 09:48:34'),(102,12,'Welcome back, Suchita Shihore! You have logged in successfully.',1,'2026-07-23 09:50:32'),(103,13,'Welcome back, Navya Singh! You have logged in successfully.',1,'2026-07-23 09:50:59'),(104,15,'Welcome back, Shrinidhi Shinde! You have logged in successfully.',1,'2026-07-23 09:51:48'),(105,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 09:54:28'),(106,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 09:56:18'),(107,9,'🎉 Your solution for \'Sudoku Solver\' was ACCEPTED!',1,'2026-07-23 09:58:52'),(108,9,'🎉 Your solution for \'Sudoku Solver\' was ACCEPTED!',1,'2026-07-23 09:59:03'),(109,9,'🎉 Your solution for \'Two Sum\' was ACCEPTED!',1,'2026-07-23 10:24:33'),(110,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 10:24:57'),(111,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 10:32:47'),(112,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-23 10:33:37'),(113,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 10:38:38'),(114,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 10:39:06'),(115,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 10:43:53'),(116,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-23 10:44:58'),(117,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 10:45:40'),(118,9,'🚀 A new exam has been published: ETE. Check Available Exams!',1,'2026-07-23 10:45:54'),(119,10,'🚀 A new exam has been published: ETE. Check Available Exams!',0,'2026-07-23 10:45:54'),(120,11,'🚀 A new exam has been published: ETE. Check Available Exams!',0,'2026-07-23 10:45:54'),(121,12,'🚀 A new exam has been published: ETE. Check Available Exams!',0,'2026-07-23 10:45:54'),(122,13,'🚀 A new exam has been published: ETE. Check Available Exams!',0,'2026-07-23 10:45:54'),(123,14,'🚀 A new exam has been published: ETE. Check Available Exams!',0,'2026-07-23 10:45:54'),(124,15,'🚀 A new exam has been published: ETE. Check Available Exams!',0,'2026-07-23 10:45:54'),(125,16,'🚀 A new exam has been published: ETE. Check Available Exams!',0,'2026-07-23 10:45:54'),(126,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 10:46:06'),(127,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-23 10:57:58'),(128,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 11:00:01'),(129,9,'🚀 A new exam has been published: class test 2. Check Available Exams!',1,'2026-07-23 11:00:05'),(130,10,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:00:05'),(131,11,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:00:05'),(132,12,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:00:05'),(133,13,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:00:05'),(134,14,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:00:05'),(135,15,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:00:05'),(136,16,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:00:05'),(137,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 11:00:24'),(138,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-23 11:12:08'),(139,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 11:12:50'),(140,9,'🚀 A new exam has been published: class test 2. Check Available Exams!',1,'2026-07-23 11:12:59'),(141,10,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:12:59'),(142,11,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:12:59'),(143,12,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:12:59'),(144,13,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:12:59'),(145,14,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:12:59'),(146,15,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:12:59'),(147,16,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:12:59'),(148,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 11:13:14'),(149,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 11:16:25'),(150,9,'🚀 A new exam has been published: class test 2. Check Available Exams!',1,'2026-07-23 11:17:14'),(151,10,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:17:14'),(152,11,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:17:14'),(153,12,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:17:14'),(154,13,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:17:14'),(155,14,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:17:14'),(156,15,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:17:14'),(157,16,'🚀 A new exam has been published: class test 2. Check Available Exams!',0,'2026-07-23 11:17:14'),(158,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 11:17:28'),(159,9,'You scored 0/1 (0%) on \"class test 2\".',1,'2026-07-23 11:22:35'),(160,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 11:34:00'),(161,1,'📩 Help Request from swaranjali ghodke (swaraghodke111@gmail.com): \"my login is not working\"',1,'2026-07-23 11:36:07'),(162,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 11:36:24'),(163,9,'💬 Super Admin replied to your query: \"You can view and download your certificate directly from your My Results tab under Examination History!\"',1,'2026-07-23 11:48:21'),(164,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 11:50:52'),(165,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 11:51:29'),(166,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 12:12:35'),(167,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 13:03:57'),(168,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 14:30:02'),(169,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 14:32:43'),(170,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-23 14:35:16'),(171,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 14:41:51'),(172,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 14:48:54'),(173,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 14:52:08'),(174,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 14:56:49'),(175,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 23:14:39'),(176,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 23:18:13'),(177,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-23 23:24:17'),(178,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 23:41:05'),(179,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 23:41:51'),(180,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-23 23:44:54'),(181,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-23 23:46:11'),(182,17,'Welcome back, Priyanka Patil! You have logged in successfully.',1,'2026-07-23 23:49:20'),(183,9,'Welcome back, Swaranjali Ghodke! You have logged in successfully.',1,'2026-07-23 23:51:53'),(184,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-24 00:15:47'),(185,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-24 00:26:51'),(186,9,'🚀 A new exam has been published: Class Test V. Check Available Exams!',1,'2026-07-24 00:26:57'),(187,10,'🚀 A new exam has been published: Class Test V. Check Available Exams!',0,'2026-07-24 00:26:57'),(188,11,'🚀 A new exam has been published: Class Test V. Check Available Exams!',0,'2026-07-24 00:26:57'),(189,12,'🚀 A new exam has been published: Class Test V. Check Available Exams!',0,'2026-07-24 00:26:57'),(190,13,'🚀 A new exam has been published: Class Test V. Check Available Exams!',0,'2026-07-24 00:26:57'),(191,14,'🚀 A new exam has been published: Class Test V. Check Available Exams!',0,'2026-07-24 00:26:57'),(192,15,'🚀 A new exam has been published: Class Test V. Check Available Exams!',0,'2026-07-24 00:26:57'),(193,16,'🚀 A new exam has been published: Class Test V. Check Available Exams!',0,'2026-07-24 00:26:57'),(194,9,'Welcome back, Swaranjali Omprakash Ghodke! You have logged in successfully.',1,'2026-07-24 00:27:15'),(195,9,'You scored 16/20 (80%) on \"Class Test V\".',1,'2026-07-24 00:28:49'),(196,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-24 00:30:18'),(197,9,'🚀 A new exam has been published: Coding & Programming MCQ Quiz. Check Available Exams!',1,'2026-07-24 00:35:09'),(198,10,'🚀 A new exam has been published: Coding & Programming MCQ Quiz. Check Available Exams!',0,'2026-07-24 00:35:09'),(199,11,'🚀 A new exam has been published: Coding & Programming MCQ Quiz. Check Available Exams!',0,'2026-07-24 00:35:09'),(200,12,'🚀 A new exam has been published: Coding & Programming MCQ Quiz. Check Available Exams!',0,'2026-07-24 00:35:09'),(201,13,'🚀 A new exam has been published: Coding & Programming MCQ Quiz. Check Available Exams!',0,'2026-07-24 00:35:09'),(202,14,'🚀 A new exam has been published: Coding & Programming MCQ Quiz. Check Available Exams!',0,'2026-07-24 00:35:09'),(203,15,'🚀 A new exam has been published: Coding & Programming MCQ Quiz. Check Available Exams!',0,'2026-07-24 00:35:09'),(204,16,'🚀 A new exam has been published: Coding & Programming MCQ Quiz. Check Available Exams!',0,'2026-07-24 00:35:09'),(205,9,'Welcome back, Swaranjali Omprakash Ghodke! You have logged in successfully.',1,'2026-07-24 00:35:47'),(206,9,'You scored 0/15 (0%) on \"Coding & Programming MCQ Quiz\".',1,'2026-07-24 00:41:02'),(207,9,'Welcome back, Swaranjali Omprakash Ghodke! You have logged in successfully.',1,'2026-07-24 09:18:04'),(208,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-24 09:21:37'),(209,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-24 09:24:58'),(210,9,'Welcome back, Swaranjali Omprakash Ghodke! You have logged in successfully.',1,'2026-07-24 09:35:37'),(211,6,'Welcome back, Wrushabh Shirsat! You have logged in successfully.',1,'2026-07-24 09:36:40'),(212,9,'Welcome back, Swaranjali Omprakash Ghodke! You have logged in successfully.',1,'2026-07-24 09:38:11'),(213,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-24 09:42:54'),(214,9,'Welcome back, Swaranjali Omprakash Ghodke! You have logged in successfully.',1,'2026-07-24 09:47:15'),(215,9,'🎉 Your solution for \'Two Sum\' was ACCEPTED!',1,'2026-07-24 10:01:52'),(216,9,'Welcome back, Swaranjali Omprakash Ghodke! You have logged in successfully.',1,'2026-07-24 10:12:07'),(217,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-24 10:17:37'),(218,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-24 10:18:18'),(219,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-24 11:00:54'),(220,9,'Welcome back, Swaranjali Omprakash Ghodke! You have logged in successfully.',1,'2026-07-24 11:01:06'),(221,9,'Welcome back, Swaranjali Omprakash Ghodke! You have logged in successfully.',1,'2026-07-24 11:07:29'),(222,9,'Welcome back, Swaranjali Omprakash Ghodke! You have logged in successfully.',1,'2026-07-24 11:09:21'),(223,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-24 11:14:23'),(224,18,'Welcome to Exam Portal, RuBy Official! Your account has been created successfully.',1,'2026-07-24 11:21:13'),(225,18,'🎉 Your email address has been verified successfully. Welcome to the portal!',1,'2026-07-24 11:21:35'),(226,18,'Welcome back, RuBy Official! You have logged in successfully.',1,'2026-07-24 11:21:53'),(227,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-24 11:24:07'),(228,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-24 11:30:42'),(229,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-24 12:07:21'),(230,1,'Welcome back, Balaji Chaughule! You have logged in successfully.',1,'2026-07-24 12:17:55');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `programs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department_id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_program_dept` (`department_id`),
  CONSTRAINT `programs_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_id` int NOT NULL,
  `question` text NOT NULL,
  `opt1` varchar(500) NOT NULL,
  `opt2` varchar(500) NOT NULL,
  `opt3` varchar(500) NOT NULL,
  `opt4` varchar(500) NOT NULL,
  `answer` varchar(500) NOT NULL,
  `marks` int NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `exam_id` (`exam_id`),
  CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (1,1,'What is a function in C++?','a data type','reusable block','a variable','a loop','reusable block',1,'2026-07-21 13:58:26'),(2,1,'2. Which of the following best describes a constructor in C++?','a','b','c','d','a',1,'2026-07-21 13:59:53'),(3,2,'What is the output of print(type(1 / 2)) in Python 3?','<class \'int\'>','<class \'float\'>','<class \'double\'>','<class \'number\'>','<class \'float\'>',1,'2026-07-21 14:06:33'),(4,2,'Which of the following is correct about typeof null in JavaScript?','\"null\"','\"undefined\"','\"object\"','\"function\"','\"object\"',1,'2026-07-21 14:06:33'),(5,2,'Which operator is used to deallocate memory in C++ that was allocated using new?','delete','free','remove','destruct','delete',1,'2026-07-21 14:06:33'),(6,2,'Which SQL keyword is used to sort the result-set?','SORT BY','ORDER BY','GROUP BY','ALIGN BY','ORDER BY',1,'2026-07-21 14:06:33'),(7,2,'Which Git command is used to show the commit history?','git status','git history','git log','git show','git log',1,'2026-07-21 14:06:33'),(8,2,'What is the time complexity of searching in a balanced Binary Search Tree (BST) in the worst case?','O(1)','O(log n)','O(n)','O(n log n)','O(log n)',1,'2026-07-21 14:06:33'),(9,2,'How do you define a variable in PHP?','var myVar;','$myVar;','let myVar;','def myVar;','$myVar;',1,'2026-07-21 14:06:33'),(10,2,'Which of these is NOT a primitive data type in Java?','int','boolean','String','char','String',1,'2026-07-21 14:06:33'),(11,2,'Which HTML5 tag is used to embed a self-contained audio file?','<sound>','<music>','<audio>','<media>','<audio>',1,'2026-07-21 14:06:33'),(12,2,'What does CSS stand for?','Creative Style Sheets','Cascading Style Sheets','Computer Style Sheets','Colorful Style Sheets','Cascading Style Sheets',1,'2026-07-21 14:06:33'),(13,2,'Which sorting algorithm has a worst-case time complexity of O(n^2) but is average-case O(n log n)?','Merge Sort','Quick Sort','Heap Sort','Bubble Sort','Quick Sort',1,'2026-07-21 14:06:33'),(14,2,'Which standard library function is used to allocate memory dynamically in C?','malloc','alloc','new','calloc_mem','malloc',1,'2026-07-21 14:06:33'),(15,2,'What protocol does the World Wide Web use to transmit data?','FTP','SMTP','HTTP','SSH','HTTP',1,'2026-07-21 14:06:33'),(16,2,'What does HTTPS stand for?','Hypertext Transfer Protocol Secure','Hypertext Transfer Protocol Standard','Hypertext Transmission Protocol System','Hyperlink Transfer Program Secure','Hypertext Transfer Protocol Secure',1,'2026-07-21 14:06:33'),(17,2,'Which file is used to define a container\'s environment and steps to build an image?','docker.yaml','docker-compose.yml','Dockerfile','container.json','Dockerfile',1,'2026-07-21 14:06:33'),(18,5,'what is polymorphism?','a','b','c','d','a',2,'2026-07-23 10:37:19'),(19,6,'qweer','a','b','c','d','b',1,'2026-07-23 10:59:34'),(20,7,'where is your corser','at center','at top right corner','at typing','dont know','at typing',2,'2026-07-24 00:22:47'),(21,7,'do you know my name','no','yes','no need','may be','may be',2,'2026-07-24 00:23:45'),(22,7,'how are you','fine','sad','angry','stress due to exam','stress due to exam',10,'2026-07-24 00:24:54'),(23,7,'who is co founder of SaroGrow','RuBy official','Hruta Official','Dixit Official','Madhur Official','RuBy official',6,'2026-07-24 00:26:15');
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results`
--

DROP TABLE IF EXISTS `results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `exam_id` int NOT NULL,
  `score` int NOT NULL DEFAULT '0',
  `total` int NOT NULL DEFAULT '0',
  `percentage` decimal(5,2) NOT NULL DEFAULT '0.00',
  `passed` tinyint(1) NOT NULL DEFAULT '0',
  `submitted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `time_taken` int DEFAULT NULL COMMENT 'seconds',
  `auto_submitted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_result` (`user_id`,`exam_id`),
  KEY `exam_id` (`exam_id`),
  CONSTRAINT `results_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `results_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results`
--

LOCK TABLES `results` WRITE;
/*!40000 ALTER TABLE `results` DISABLE KEYS */;
INSERT INTO `results` VALUES (5,9,6,0,1,0.00,1,'2026-07-23 11:22:35',197,0),(6,9,7,16,20,80.00,1,'2026-07-24 00:28:49',73,0),(7,9,2,0,15,0.00,0,'2026-07-24 00:41:02',48104,1);
/*!40000 ALTER TABLE `results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `program_id` int NOT NULL,
  `semester_id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_section` (`program_id`,`semester_id`,`name`),
  KEY `idx_section_program` (`program_id`),
  KEY `idx_section_semester` (`semester_id`),
  CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sections_ibfk_2` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sections`
--

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `semesters`
--

DROP TABLE IF EXISTS `semesters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `semesters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `academic_year_id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_semester_ay` (`academic_year_id`),
  CONSTRAINT `semesters_ibfk_1` FOREIGN KEY (`academic_year_id`) REFERENCES `academic_years` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `semesters`
--

LOCK TABLES `semesters` WRITE;
/*!40000 ALTER TABLE `semesters` DISABLE KEYS */;
/*!40000 ALTER TABLE `semesters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department_id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_subject_dept` (`department_id`),
  CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
INSERT INTO `system_settings` VALUES (1,'allow_registration','1'),(2,'maintenance_mode','0'),(3,'default_exam_duration','60'),(4,'smtp_server_simulation','1');
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_submissions`
--

DROP TABLE IF EXISTS `task_submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_submissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `task_id` int NOT NULL,
  `user_id` int NOT NULL,
  `submission_text` text,
  `file_path` varchar(255) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `grade` varchar(10) DEFAULT NULL,
  `feedback` text,
  `submitted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_task_sub` (`task_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `task_submissions_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `task_submissions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_submissions`
--

LOCK TABLES `task_submissions` WRITE;
/*!40000 ALTER TABLE `task_submissions` DISABLE KEYS */;
INSERT INTO `task_submissions` VALUES (2,3,9,'wer',NULL,'pending',NULL,NULL,'2026-07-24 09:36:25');
/*!40000 ALTER TABLE `task_submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `deadline` datetime NOT NULL,
  `created_by` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (1,'Database Design Assignment','Create an ER diagram and normalize the tables for an e-commerce platform up to 3NF.','2026-07-26 13:33:11',1,'2026-07-21 13:33:11'),(2,'RESTful API Homework','Implement a secure RESTful API in PHP with CRUD operations and user role validation.','2026-07-23 13:33:11',1,'2026-07-21 13:33:11'),(3,'create a student result management  system','create a web based application developed to simplify the process of managing and publishing students academic results','2026-07-28 15:30:00',6,'2026-07-22 13:32:35'),(4,'create a examination portal','realastic','2026-07-28 10:30:00',6,'2026-07-24 09:35:10');
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('student','faculty','admin') NOT NULL DEFAULT 'student',
  `email_verified` tinyint(1) NOT NULL DEFAULT '0',
  `verify_token` varchar(64) DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT '0',
  `verification_token` varchar(64) DEFAULT NULL,
  `token_expires_at` datetime DEFAULT NULL,
  `reset_token` varchar(64) DEFAULT NULL,
  `reset_expires` datetime DEFAULT NULL,
  `profile_pic` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Balaji Chaughule','balajichaughule@gmail.com','$2y$12$X5403Hk4gcgzq5rL6j4e5e5c/VEswtgU3rdKFIR.MtZoG3vRtqFTy','admin',1,NULL,1,NULL,NULL,NULL,NULL,'uploads/balaji_chaughule.jpg','2026-07-21 13:33:11'),(6,'Wrushabh Shirsat','wrushabhs@gmail.com','$2y$12$DgXk7uPMZcJRm06j2zEyeu8kbPRKNUgciF28rFOjmsdHCdW6dTwj6','faculty',1,NULL,1,NULL,NULL,NULL,NULL,NULL,'2026-07-22 00:15:22'),(9,'Swaranjali Omprakash Ghodke','swaraghodke111@gmail.com','$2y$12$mWVyzOHID5s.fPf.j8XKsevYnHkYe890zc0pMz2DjAOCyT5J7I7pq','student',1,NULL,1,NULL,NULL,NULL,NULL,'uploads/user_9_1784780100.jpeg','2026-07-23 09:30:27'),(10,'Shrawani Rokde','shrawanirokde@gmail.com','$2y$12$d8YZAFKwuYlaGDqkv5AwX.l/J807lu3I.u4FvjoG3SiJPw.wmhz0O','student',1,NULL,1,NULL,NULL,NULL,NULL,'uploads/user_10_1784780385.jpeg','2026-07-23 09:32:03'),(11,'Soham Solankar','sohamsolankar16@gmail.com','$2y$12$vp7PnAIQats0IUV5Ap0MyOZ9HRpbfeBnr5PLUzzE2hT8cOOL/Je8K','student',1,NULL,1,NULL,NULL,'236811','2026-07-23 14:41:27',NULL,'2026-07-23 09:34:22'),(12,'Suchita Shihore','ramchandrashihore@gmail.com','$2y$12$HcM9npPKpu0.y5MbJfR8a.4gJkd6/ahc3mhaf1u3Tas34f5uMAqeW','student',1,NULL,1,NULL,NULL,NULL,NULL,'uploads/user_12_1784780445.jpeg','2026-07-23 09:35:30'),(13,'Navya Singh','navyasingh8002@gmail.com','$2y$12$kx.CgU5Bp8W09PEljS/1SO1tdlBKZqavqgnf3ntuTvXKJVd4Nh.6q','student',1,NULL,1,NULL,NULL,NULL,NULL,'uploads/user_13_1784780480.jpeg','2026-07-23 09:36:47'),(14,'Siddhesh Dhavale','dhavalesiddhesh007@gmail.com','$2y$12$JR4ym8yIdwQU9aSNzOmXoeVbCEGlUICmXiAEryTxpgCPsUpxEN3ty','student',1,NULL,1,NULL,NULL,NULL,NULL,NULL,'2026-07-23 09:38:43'),(15,'Shrinidhi Shinde','workshrinidhishinde@gmail.com','$2y$12$Lukjx4YlbGDtZ.zMsPiTwun5aOPbdq0Tvi0tOaBtP2AjNPIdRyNzm','student',1,NULL,1,NULL,NULL,NULL,NULL,'uploads/user_15_1784780585.jpeg','2026-07-23 09:39:48'),(16,'Tejaswini Shinde','shindetejasvini62@gmail.com','$2y$12$V9qfogoVFP/z7j6tRxTobeYCCxf1A2j.19nu7E3Bb4Cy9Ql3e6RKW','student',1,NULL,1,NULL,NULL,NULL,NULL,NULL,'2026-07-23 09:41:53'),(17,'Priyanka Patil','priyankap@gmail.com','$2y$12$wDJuXeyPCsdf4ysCODT.yujiiNbWI02UGNHPvyYpPsAU9iqiJkEg6','faculty',1,NULL,1,NULL,NULL,NULL,NULL,NULL,'2026-07-23 23:48:59'),(18,'RuBy Official','badakrohit@gmail.com','$2y$12$mnkfuONK1I67NONtC9E0lOAavGNzooS8jozkpLDSZStLs5nO1mj/O','student',1,NULL,1,NULL,NULL,NULL,NULL,NULL,'2026-07-24 11:21:13');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-24 12:22:22
