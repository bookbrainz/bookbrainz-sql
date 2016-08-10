BEGIN;

DELETE FROM bookbrainz.achievement_type WHERE name = 'Explorer I';
DELETE FROM bookbrainz.achievement_type WHERE name = 'Explorer II';
DELETE FROM bookbrainz.achievement_type WHERE name = 'Explorer III';

COMMIT;
