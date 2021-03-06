
-- phpMyAdmin SQL Dump
-- version 4.0.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 26, 2013 at 04:29 PM
-- Server version: 5.5.32-0ubuntu0.12.04.1
-- PHP Version: 5.3.10-1ubuntu3.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `bookmarks`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookmark`
--

DROP TABLE IF EXISTS `bookmark`;
CREATE TABLE IF NOT EXISTS `bookmark` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `url` varchar(300) NOT NULL,
  `position` int(11) NOT NULL,
  `parent` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `bookmark_type_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_bookmark_user` (`user_id`),
  KEY `fk_bookmark_category1` (`category_id`),
  KEY `fk_bookmark_bookmark_type1` (`bookmark_type_id`),
  KEY `fk_bookmark_bookmark1` (`parent`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=38 ;

--
-- Dumping data for table `bookmark`
--

INSERT INTO `bookmark` (`id`, `name`, `url`, `position`, `parent`, `user_id`, `category_id`, `bookmark_type_id`) VALUES
(1, 'Book dans perso', 'http://www.spope.fr', 0, NULL, 1, 2, 1),
(2, 'Autre book', 'http://www.google.com', 3, NULL, 1, 2, 1),
(4, 'Thinkster', 'http://www.thinkster.io', 1, NULL, 1, 2, 1),
(5, 'll', 'http://www.thinkster.io', 4, NULL, 1, 2, 1),
(13, 'Spope', 'http://spope.fr', 2, NULL, 1, 3, 1),
(24, 'TESTa', 'http://api.jquery.com/trigger/', 2, NULL, 1, 2, 1),
(26, 'Korben', 'http://korben.info/', 1, NULL, 1, 3, 1),
(27, 'The Dailymars', 'http://www.dailymars.net/', 3, NULL, 1, 3, 1),
(28, 'Journal du geek', 'http://www.journaldugeek.com/', 0, NULL, 1, 3, 1),
(29, 'Folder', '', 5, NULL, 1, 2, 2),
(30, 'Bitch', 'http://desyeuxdebitch.wordpress.com/', 0, 29, 1, 2, 1),
(35, 'Repo', 'https://github.com/Spope/bookmarks', 1, 29, 1, 2, 1),
(36, 'Sub folder', '', 2, 29, 1, 2, 2),
(37, 'Joies du codes', 'http://lesjoiesducode.tumblr.com/', 0, 36, 1, 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `bookmark_type`
--

DROP TABLE IF EXISTS `bookmark_type`;
CREATE TABLE IF NOT EXISTS `bookmark_type` (
  `id` int(11) NOT NULL,
  `label` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `bookmark_type`
--

INSERT INTO `bookmark_type` (`id`, `label`) VALUES
(1, 'book'),
(2, 'folder');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `parent` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_category_user1` (`user_id`),
  KEY `fk_category_parent1` (`parent`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`, `parent`, `user_id`) VALUES
(1, '__default', 0, 1),
(2, 'Perso', 1, 1),
(3, 'Cool cool cool', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `oauth_access_token`
--

DROP TABLE IF EXISTS `oauth_access_token`;
CREATE TABLE IF NOT EXISTS `oauth_access_token` (
  `token` varchar(45) NOT NULL,
  `user_id` int(11) NOT NULL,
  `client_id` varchar(45) NOT NULL,
  UNIQUE KEY `token` (`token`),
  KEY `fk_oauth_access_token_oauth_client1` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_authorization_code`
--

DROP TABLE IF EXISTS `oauth_authorization_code`;
CREATE TABLE IF NOT EXISTS `oauth_authorization_code` (
  `code` varchar(45) NOT NULL,
  `client_id` varchar(45) NOT NULL,
  `redirect_uri` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  UNIQUE KEY `unique_client_user` (`client_id`,`user_id`),
  KEY `fk_oauth_authorization_code_user1` (`user_id`),
  KEY `fk_oauth_authorization_code_client1` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_client`
--

DROP TABLE IF EXISTS `oauth_client`;
CREATE TABLE IF NOT EXISTS `oauth_client` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `client_id` varchar(45) NOT NULL,
  `client_secret` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `oauth_client`
--

INSERT INTO `oauth_client` (`id`, `name`, `client_id`, `client_secret`) VALUES
(1, 'Chrome', 'chrome_321', 'az97j24ho24cvh24xq671345ef5uop54');

-- --------------------------------------------------------

--
-- Table structure for table `search_engine`
--

DROP TABLE IF EXISTS `search_engine`;
CREATE TABLE IF NOT EXISTS `search_engine` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `url` varchar(300) NOT NULL,
  `logo` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `search_engine`
--

INSERT INTO `search_engine` (`id`, `name`, `url`, `logo`) VALUES
(1, 'Google', 'http://www.google.fr/search?q={q}', 'google.png'),
(2, 'Amazon', 'http://www.amazon.fr/s/ref=nb_sb_noss_1?__mk_fr_FR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&url=search-alias%3Daps&field-keywords={q}', 'amazon.png'),
(3, 'Bookmarks', 'bookmarks', 'bookmarks.png'),
(4, 'Google Maps', 'http://maps.google.fr/maps?q={q}', 'maps.png'),
(5, 'Tiwtter', 'http://twitter.com/#!/search/{q}', 'twitter.png'),
(6, 'Youtube', 'http://www.youtube.fr/results?search_query={q}', 'youtube.png'),
(7, 'Facebook', 'http://www.facebook.com/search/?q={q}', 'facebook.png'),
(8, 'Google Images', 'http://www.google.fr/search?q={q}&tbm=isch', 'images.png');

-- --------------------------------------------------------

--
-- Table structure for table `theme`
--

DROP TABLE IF EXISTS `theme`;
CREATE TABLE IF NOT EXISTS `theme` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `file` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `theme`
--

INSERT INTO `theme` (`id`, `name`, `file`) VALUES
(1, 'default', 'default');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `salt` varchar(255) NOT NULL,
  `token` varchar(32) NOT NULL,
  `email` varchar(45) NOT NULL,
  `theme` int(11) NOT NULL DEFAULT '1',
  `roles` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE_username` (`username`),
  KEY `fk_user_theme1` (`theme`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `password`, `salt`, `token`, `email`, `theme`, `roles`, `created`, `updated`) VALUES
(1, 'Spope', 'bZwBSYxSmhTXGBqzJsPeRkqV4GuU5Msj+2nCP0OzY5GLiHdviXihheVpxZbMAllcZCgOVpfZ0v406cLLkKeM1CTXOB093wwEFwotfXWin84xXlrWlzPF2oBafqJzyEIiTDhBB6bRZJKLIc731VpErz/pFgDbNidtED8tWa2t88o=', 'd00pGjHvTxXpuctDsHF0DqJNj+7VYgEDXHtwS0xih0Fh+Y29mSIRRVplgOKfdAIQUavmyr+qoX2uON1uMmcx+50hoBiwQLC6jiVrE1VOEsHyjSIrC1+vaKEr26yt42MSGq0QjtUn9EdLuCxBqh/bphSWxmCidgp1Z0V47ECBxmQ=', '4lJ6tLpeO0Va6XaR87geA6l2QNUV4I6j', 'pinaudt@gmail.com', 1, '1', '0000-00-00 00:00:00', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `user_search_engine`
--

DROP TABLE IF EXISTS `user_search_engine`;
CREATE TABLE IF NOT EXISTS `user_search_engine` (
  `user_id` int(11) NOT NULL,
  `search_engine_id` int(11) NOT NULL,
  `default` tinyint(1) NOT NULL,
  PRIMARY KEY (`user_id`,`search_engine_id`),
  KEY `fk_user_has_search_engine_search_engine1` (`search_engine_id`),
  KEY `fk_user_has_search_engine_user1` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_search_engine`
--

INSERT INTO `user_search_engine` (`user_id`, `search_engine_id`, `default`) VALUES
(1, 1, 1),
(1, 2, 0),
(1, 3, 0),
(1, 4, 0),
(1, 5, 0),
(1, 6, 0),
(1, 7, 0);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookmark`
--
ALTER TABLE `bookmark`
  ADD CONSTRAINT `fk_bookmark_bookmark1` FOREIGN KEY (`parent`) REFERENCES `bookmark` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_bookmark_bookmark_type1` FOREIGN KEY (`bookmark_type_id`) REFERENCES `bookmark_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_bookmark_category1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_bookmark_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `category`
--
ALTER TABLE `category`
  ADD CONSTRAINT `fk_category_user1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `oauth_access_token`
--
ALTER TABLE `oauth_access_token`
  ADD CONSTRAINT `fk_oauth_access_token_oauth_client1` FOREIGN KEY (`client_id`) REFERENCES `oauth_client` (`client_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_oauth_access_token_user1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `oauth_authorization_code`
--
ALTER TABLE `oauth_authorization_code`
  ADD CONSTRAINT `fk_oauth_authorization_code_client1` FOREIGN KEY (`client_id`) REFERENCES `oauth_client` (`client_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_oauth_authorization_code_user1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `fk_user_theme1` FOREIGN KEY (`theme`) REFERENCES `theme` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `user_search_engine`
--
ALTER TABLE `user_search_engine`
  ADD CONSTRAINT `fk_user_has_search_engine_search_engine1` FOREIGN KEY (`search_engine_id`) REFERENCES `search_engine` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_user_has_search_engine_user1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

