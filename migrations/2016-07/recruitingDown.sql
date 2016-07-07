BEGIN;

ALTER TABLE bookbrainz._editor_referral
	DROP CONSTRAINT _editor_referral_editor_id_fkey;

ALTER TABLE bookbrainz._editor_referral
	DROP CONSTRAINT _editor_referral_recruiter_id_fkey;

DROP TABLE bookbrainz._editor_entity_visits;

COMMIT;
