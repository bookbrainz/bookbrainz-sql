BEGIN;

INSERT INTO bookbrainz.achievement_type ("name", "description", "badge_url") VALUES
	('Revisionist I', 'Perform one revision', 'images/revisionistI'),
	('Revisionist II', 'Perform 50 revisions'. 'images/revisionistII'),
	('Revisionist III', 'Perform 250 revisions'. 'images/revisionistIII'),
	('Creator Creator I', 'Create one creator', 'images/creatorcreatorI'),
	('Creator Creator II', 'Create 10 creators', 'images/creatorcreatorII'),
	('Creator Creator III', 'Create 100 creators', 'images/creatorcreatorIII'),
	('Publisher I', 'Create one publication', 'images/publisherI.svg'),
	('Publisher II', 'Create 10 publications', 'images/publisherII.svg'),
	('Publisher III', 'Create 100 publications', 'images/publisherIII.svg');
COMMIT;
