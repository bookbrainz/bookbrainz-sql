BEGIN;

CREATE TABLE bookbrainz._editor_referral (
	id SERIAL PRIMARY KEY,
	recruiter_id INT NOT NULL,
	editor_id INT NOT NULL
);

ALTER TABLE bookbrainz._editor_referral ADD FOREIGN KEY (recruiter_id) REFERENCES bookbrainz.editor (id);

ALTER TABLE bookbrainz._editor_referral ADD FOREIGN KEY (editor_id) REFERENCES bookbrainz.editor (id);

COMMIT;
