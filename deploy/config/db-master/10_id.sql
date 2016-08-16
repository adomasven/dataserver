-- From http://code.flickr.com/blegerog/2010/02/08/ticket-servers-distributed-unique-primary-keys-on-the-cheap/

-- Create database
DROP DATABASE IF EXISTS `zotero_ids`;
CREATE DATABASE `zotero_ids`;
USE `zotero_ids`;

-- Create database user
GRANT USAGE ON *.* TO 'zotero_id' IDENTIFIED BY 'password';
DROP USER 'zotero_id';
CREATE USER 'zotero_id' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE, DELETE ON zotero_ids.* TO 'zotero_id';

CREATE TABLE `collections` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `stub` char(1) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=MyISAM;

CREATE TABLE `creators` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `stub` char(1) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=MyISAM;

CREATE TABLE `items` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `stub` char(1) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=MyISAM;

CREATE TABLE `relations` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `stub` char(1) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=MyISAM;

CREATE TABLE `savedSearches` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `stub` char(1) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=MyISAM;

CREATE TABLE `tags` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `stub` char(1) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=MyISAM;
