CREATE TABLE IF NOT EXISTS `vehicle_specs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model_hash` varchar(30) NOT NULL DEFAULT '0',
  `model_name` varchar(50) NOT NULL DEFAULT 'No Model Name',
  `model_class` int(11) NOT NULL DEFAULT 0,
  `updated_on` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `version` varchar(30) NOT NULL DEFAULT '2.0.0',
  `zero_sixty` double DEFAULT NULL,
  `zero_hundered` double DEFAULT NULL,
  `quarter_mile` double NOT NULL DEFAULT 0,
  `quarter_mile_speed` double NOT NULL DEFAULT 0,
  `half_mile` double NOT NULL DEFAULT 0,
  `half_mile_speed` double unsigned NOT NULL DEFAULT 0,
  `mile` double unsigned NOT NULL DEFAULT 0,
  `mile_speed` double unsigned NOT NULL DEFAULT 0,
  `max_speed` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `model_hash` (`model_hash`)
) ENGINE=InnoDB AUTO_INCREMENT=466 DEFAULT CHARSET=utf8mb4;
