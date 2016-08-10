BEGIN;

INSERT INTO bookbrainz.achievement_type ("name", "description", "badge_url") VALUES
	('Revisionist I', 'Perform one revision', '/images/revisionistI.svg'),
	('Revisionist II', 'Perform 50 revisions', '/images/revisionistII.svg'),
	('Revisionist III', 'Perform 250 revisions', '/images/revisionistIII.svg'),
	('Creator Creator I', 'Create one creator', '/images/creatorcreatorI.svg'),
	('Creator Creator II', 'Create 10 creators', '/images/creatorcreatorII.svg'),
	('Creator Creator III', 'Create 100 creators', '/images/creatorcreatorIII.svg'),
	('Explorer I', 'View 10 entities', '/images/explorerI.svg'),
	('Explorer II', 'View 100 entities', '/images/explorerII.svg'),
	('Explorer III', 'View 1000 entities', '/images/explorerIII.svg');
	('Publisher I', 'Create one publication', '/images/publisherI.svg'),
	('Publisher II', 'Create 10 publications', '/images/publisherII.svg'),
	('Publisher III', 'Create 100 publications', '/images/publisherIII.svg'),
	('Sprinter', 'Create 10 revisions in an hour', '/images/sprinter.svg'),
	('Fun Runner', 'Create a revision every day for a week', '/images/funrunner.svg'),
	('Marathoner', 'Create a revision a day for 30 days', '/images/marathoner.svg'),
	('Time Traveller', 'Create an edition before it is released', '/images/timetraveller.svg'),
	('Hot Off the Press', 'Create an edition within a week of its release', '/images/hotoffthepress.svg'),
	('Publisher Creator I', 'Create one publisher', '/images/publishercreatorI.svg'),
	('Publisher Creator II', 'Create 10 publishers', '/images/publishercreatorII.svg'),
	('Publisher Creator III', 'Create 100 publishers', '/images/publishercreatorIII.svg'),
	('Limited Edition I', 'Create one edition', '/images/limitededitionI.svg'),
	('Limited Edition II', 'Create 10 editions', '/images/limitededitionII.svg'),
	('Limited Edition III', 'Create 100 editions', '/images/limitededitionIII.svg'),
	('Worker Bee I', 'Create one work', '/images/workerbeeI.svg'),
	('Worker Bee II', 'Create 10 works', '/images/workerbeeII.svg'),
	('Worker Bee III', 'Create 100 works', '/images/workerbeeIII.svg');

INSERT INTO bookbrainz.title_type ("title", "description") VALUES
	('Revisionist', 'Complete the Revisionist series of badges'),
	('Creator Creator', 'Complete the Creator Creator series of badges'),
	('Publisher', 'Complete the Publisher series of badges'),
	('Fun Runner', 'Complete the Fun Runner Achievement'),
	('Sprinter', 'Complete the Sprinter Achievement'),
	('Marathoner', 'Complete the Marathoner Achievement'),
	('Worker Bee', 'Complete the Worker Bee series of badges'),
	('Publisher Creator', 'Complete the Publisher Creator series of badges'),
	('Limited Edition', 'Complete the Limited Edition series of badges'),
	('Hot Off the Press', 'Complete the Hot Off the Press Achievement'),
	('Time Traveller', 'Complete the Time Traveller achievement');

COMMIT;
