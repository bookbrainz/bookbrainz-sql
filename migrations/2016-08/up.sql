BEGIN;

UPDATE bookbrainz.achievement_type SET "badge_url" = '/images/publishercreatorI.svg'
	WHERE name = 'Publisher Creator I';
UPDATE bookbrainz.achievement_type SET "badge_url" = '/images/publishercreatorII.svg'
	WHERE name = 'Publisher Creator II';
UPDATE bookbrainz.achievement_type SET "badge_url" = '/images/publishercreatorIII.svg'
	WHERE name = 'Publisher Creator III';
UPDATE bookbrainz.achievement_type SET "badge_url" = '/images/limitededitionI.svg'
	WHERE name = 'Limited Edition I';
UPDATE bookbrainz.achievement_type SET "badge_url" = '/images/limitededitionII.svg'
	WHERE name = 'Limited Edition II';
UPDATE bookbrainz.achievement_type SET "badge_url" = '/images/limitededitionIII.svg'
	WHERE name = 'Limited Edition III';
UPDATE bookbrainz.achievement_type SET "badge_url" = '/images/workerbeeI.svg'
	WHERE name = 'Worker Bee I';
UPDATE bookbrainz.achievement_type SET "badge_url" = '/images/workerbeeII.svg'
	WHERE name = 'Worker Bee II';
UPDATE bookbrainz.achievement_type SET "badge_url" = '/images/workerbeeIII.svg'
	WHERE name = 'Worker Bee III';
INSERT INTO bookbrainz.achievement_type ("name", "description", "badge_url") VALUES
	('Explorer I', 'View 10 entities', '/images/explorerI.svg'),
	('Explorer II', 'View 100 entities', '/images/explorerII.svg'),
	('Explorer III', 'View 1000 entities', '/images/explorerIII.svg');
COMMIT;
