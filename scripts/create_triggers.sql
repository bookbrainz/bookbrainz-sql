-- Provides functionality for create, update and delete operations on composite
-- entity views
CREATE OR REPLACE FUNCTION bookbrainz.process_creator() RETURNS TRIGGER
	AS $process_creator$
	DECLARE
		creator_data_id INT;
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			IF (NEW.bbid IS NULL) THEN
				INSERT INTO bookbrainz.entity(type) VALUES('Creator') RETURNING bookbrainz.entity.bbid INTO NEW.bbid;
			ELSE
				INSERT INTO bookbrainz.entity(bbid, type) VALUES(NEW.bbid, 'Creator');
			END IF;
			INSERT INTO bookbrainz.creator_header(bbid) VALUES(NEW.bbid);
		END IF;

		IF (NEW.ended IS NULL) THEN
			NEW.ended = false;
		END IF;

		-- If we're not deleting, create new entity data rows as necessary
		IF (TG_OP <> 'DELETE') THEN
			INSERT INTO bookbrainz.creator_data(
				alias_set_id, identifier_set_id, relationship_set_id, annotation_id,
				disambiguation_id, begin_year, begin_month, begin_day, begin_area_id,
				end_year, end_month, end_day, end_area_id, ended, area_id, gender_id,
				type_id
			) VALUES (
				NEW.alias_set_id, NEW.identifier_set_id, NEW.relationship_set_id,
				NEW.annotation_id, NEW.disambiguation_id, NEW.begin_year,
				NEW.begin_month, NEW.begin_day, NEW.begin_area_id, NEW.end_year,
				NEW.end_month, NEW.end_day, NEW.end_area_id, NEW.ended, NEW.area_id, NEW.gender_id,
				NEW.type_id
			) RETURNING bookbrainz.creator_data.id INTO creator_data_id;

			INSERT INTO bookbrainz.creator_revision VALUES(NEW.revision_id, NEW.bbid, creator_data_id);
		ELSE
			INSERT INTO bookbrainz.creator_revision VALUES(NEW.revision_id, NEW.bbid, NULL);
		END IF;

		UPDATE bookbrainz.creator_header
			SET master_revision_id = NEW.revision_id
			WHERE bbid = NEW.bbid;

		IF (TG_OP = 'DELETE') THEN
			RETURN OLD;
		ELSE
			RETURN NEW;
		END IF;
	END;
$process_creator$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION bookbrainz.process_edition() RETURNS TRIGGER
	AS $process_edition$
	DECLARE
		edition_data_id INT;
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			IF (NEW.bbid IS NULL) THEN
				INSERT INTO bookbrainz.entity(type) VALUES('Edition') RETURNING bookbrainz.entity.bbid INTO NEW.bbid;
			ELSE
				INSERT INTO bookbrainz.entity(bbid, type) VALUES(NEW.bbid, 'Edition');
			END IF;
			INSERT INTO bookbrainz.edition_header(bbid) VALUES(NEW.bbid);
		END IF;

		-- If we're not deleting, create new entity data rows as necessary
		IF (TG_OP <> 'DELETE') THEN
			INSERT INTO bookbrainz.edition_data(
				alias_set_id, identifier_set_id, relationship_set_id, annotation_id,
				disambiguation_id, publication_bbid, creator_credit_id,
				publisher_set_id, release_event_set_id, language_set_id, width,
				height, depth, weight, pages, format_id, status_id
			) VALUES (
				NEW.alias_set_id, NEW.identifier_set_id, NEW.relationship_set_id,
				NEW.annotation_id, NEW.disambiguation_id, NEW.publication_bbid,
				NEW.creator_credit_id, NEW.publisher_set_id,
				NEW.release_event_set_id, NEW.language_set_id, NEW.width,
				NEW.height, NEW.depth, NEW.weight, NEW.pages, NEW.format_id,
				NEW.status_id
			) RETURNING bookbrainz.edition_data.id INTO edition_data_id;

			INSERT INTO bookbrainz.edition_revision VALUES(NEW.revision_id, NEW.bbid, edition_data_id);
		ELSE
			INSERT INTO bookbrainz.edition_revision VALUES(NEW.revision_id, NEW.bbid, NULL);
		END IF;

		UPDATE bookbrainz.edition_header
			SET master_revision_id = NEW.revision_id
			WHERE bbid = NEW.bbid;

		IF (TG_OP = 'DELETE') THEN
			RETURN OLD;
		ELSE
			RETURN NEW;
		END IF;
	END;
$process_edition$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION bookbrainz.process_work() RETURNS TRIGGER
	AS $process_work$
	DECLARE
		work_data_id INT;
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			IF (NEW.bbid IS NULL) THEN
				INSERT INTO bookbrainz.entity(type) VALUES('Work') RETURNING bookbrainz.entity.bbid INTO NEW.bbid;
			ELSE
				INSERT INTO bookbrainz.entity(bbid, type) VALUES(NEW.bbid, 'Work');
			END IF;
			INSERT INTO bookbrainz.work_header(bbid) VALUES(NEW.bbid);
		END IF;

		-- If we're not deleting, create new entity data rows as necessary
		IF (TG_OP <> 'DELETE') THEN
			INSERT INTO bookbrainz.work_data(
				alias_set_id, identifier_set_id, relationship_set_id, annotation_id,
				disambiguation_id, language_set_id, type_id
			) VALUES (
				NEW.alias_set_id, NEW.identifier_set_id, NEW.relationship_set_id,
				NEW.annotation_id, NEW.disambiguation_id, NEW.language_set_id,
				NEW.type_id
			) RETURNING bookbrainz.work_data.id INTO work_data_id;

			INSERT INTO bookbrainz.work_revision VALUES(NEW.revision_id, NEW.bbid, work_data_id);
		ELSE
			INSERT INTO bookbrainz.work_revision VALUES(NEW.revision_id, NEW.bbid, NULL);
		END IF;

		UPDATE bookbrainz.work_header
			SET master_revision_id = NEW.revision_id
			WHERE bbid = NEW.bbid;

		IF (TG_OP = 'DELETE') THEN
			RETURN OLD;
		ELSE
			RETURN NEW;
		END IF;
	END;
$process_work$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION bookbrainz.process_publisher() RETURNS TRIGGER
	AS $process_publisher$
	DECLARE
		publisher_data_id INT;
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			IF (NEW.bbid IS NULL) THEN
				INSERT INTO bookbrainz.entity(type) VALUES('Publisher') RETURNING bookbrainz.entity.bbid INTO NEW.bbid;
			ELSE
				INSERT INTO bookbrainz.entity(bbid, type) VALUES(NEW.bbid, 'Publisher');
			END IF;
			INSERT INTO bookbrainz.publisher_header(bbid) VALUES(NEW.bbid);
		END IF;

		IF (NEW.ended IS NULL) THEN
			NEW.ended = false;
		END IF;

		-- If we're not deleting, create new entity data rows as necessary
		IF (TG_OP <> 'DELETE') THEN
			INSERT INTO bookbrainz.publisher_data(
				alias_set_id, identifier_set_id, relationship_set_id, annotation_id,
				disambiguation_id, type_id, begin_year, begin_month, begin_day, end_year,
				end_month, end_day, ended, area_id
			) VALUES (
				NEW.alias_set_id, NEW.identifier_set_id, NEW.relationship_set_id,
				NEW.annotation_id, NEW.disambiguation_id, NEW.type_id, NEW.begin_year,
				NEW.begin_month, NEW.begin_day, NEW.end_year, NEW.end_month, NEW.end_day,
				NEW.ended, NEW.area_id
			) RETURNING bookbrainz.publisher_data.id INTO publisher_data_id;

			INSERT INTO bookbrainz.publisher_revision VALUES(NEW.revision_id, NEW.bbid, publisher_data_id);
		ELSE
			INSERT INTO bookbrainz.publisher_revision VALUES(NEW.revision_id, NEW.bbid, NULL);
		END IF;

		UPDATE bookbrainz.publisher_header
			SET master_revision_id = NEW.revision_id
			WHERE bbid = NEW.bbid;

		IF (TG_OP = 'DELETE') THEN
			RETURN OLD;
		ELSE
			RETURN NEW;
		END IF;
	END;
$process_publisher$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION bookbrainz.process_publication() RETURNS TRIGGER
	AS $process_publication$
	DECLARE
		publication_data_id INT;
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			IF (NEW.bbid IS NULL) THEN
				INSERT INTO bookbrainz.entity(type) VALUES('Publication') RETURNING bookbrainz.entity.bbid INTO NEW.bbid;
			ELSE
				INSERT INTO bookbrainz.entity(bbid, type) VALUES(NEW.bbid, 'Publication');
			END IF;
			INSERT INTO bookbrainz.publication_header(bbid) VALUES(NEW.bbid);
		END IF;

		-- If we're not deleting, create new entity data rows as necessary
		IF (TG_OP <> 'DELETE') THEN
			INSERT INTO bookbrainz.publication_data(
				alias_set_id, identifier_set_id, relationship_set_id, annotation_id,
				disambiguation_id, type_id
			) VALUES (
				NEW.alias_set_id, NEW.identifier_set_id, NEW.relationship_set_id,
				NEW.annotation_id, NEW.disambiguation_id, NEW.type_id
			) RETURNING bookbrainz.publication_data.id INTO publication_data_id;

			INSERT INTO bookbrainz.publication_revision VALUES(NEW.revision_id, NEW.bbid, publication_data_id);
		ELSE
			INSERT INTO bookbrainz.publication_revision VALUES(NEW.revision_id, NEW.bbid, NULL);
		END IF;

		UPDATE bookbrainz.publication_header
			SET master_revision_id = NEW.revision_id
			WHERE bbid = NEW.bbid;

		IF (TG_OP = 'DELETE') THEN
			RETURN OLD;
		ELSE
			RETURN NEW;
		END IF;
	END;
$process_publication$ LANGUAGE plpgsql;

CREATE FUNCTION bookbrainz.token_creator() RETURNS trigger
	AS $token_creator$
	BEGIN
		new.tokens := to_tsvector('pg_catalog.simple', unaccent(new.name));
		RETURN new;
	END
$token_creator$ LANGUAGE plpgsql;

-- Function refreshes search_mv and search_words_mv materialized views
CREATE FUNCTION bookbrainz.refresh_mv() RETURNS TRIGGER
	AS $refresh_mv$
	BEGIN
		RAISE NOTICE 'Refresh Fires!';
		REFRESH MATERIALIZED VIEW CONCURRENTLY bookbrainz.search_mv;
		REFRESH MATERIALIZED VIEW CONCURRENTLY bookbrainz.search_words_mv;
		RAISE NOTICE 'Refreshing ...';
		RETURN NULL;
	END
$refresh_mv$ LANGUAGE plpgsql;


BEGIN;

CREATE TRIGGER process_creator
	INSTEAD OF INSERT OR UPDATE OR DELETE ON bookbrainz.creator
	FOR EACH ROW EXECUTE PROCEDURE bookbrainz.process_creator();

COMMIT;

BEGIN;

CREATE TRIGGER process_edition
	INSTEAD OF INSERT OR UPDATE OR DELETE ON bookbrainz.edition
	FOR EACH ROW EXECUTE PROCEDURE bookbrainz.process_edition();

COMMIT;

BEGIN;

CREATE TRIGGER process_work
	INSTEAD OF INSERT OR UPDATE OR DELETE ON bookbrainz.work
	FOR EACH ROW EXECUTE PROCEDURE bookbrainz.process_work();

COMMIT;

BEGIN;

CREATE TRIGGER process_publisher
	INSTEAD OF INSERT OR UPDATE OR DELETE ON bookbrainz.publisher
	FOR EACH ROW EXECUTE PROCEDURE bookbrainz.process_publisher();

COMMIT;

BEGIN;

CREATE TRIGGER process_publication
	INSTEAD OF INSERT OR UPDATE OR DELETE ON bookbrainz.publication
	FOR EACH ROW EXECUTE PROCEDURE bookbrainz.process_publication();

COMMIT;

-- Trigger to unaccent and create tokens of alias name
CREATE TRIGGER alias_token_update BEFORE INSERT OR UPDATE
	ON bookbrainz.alias FOR EACH ROW EXECUTE PROCEDURE
	bookbrainz.token_creator();

COMMIT;

BEGIN;

-- Trigger to refresh views upon addition/update of creator
CREATE TRIGGER mv_creator_update AFTER INSERT OR UPDATE
	ON bookbrainz.creator_header FOR EACH ROW EXECUTE PROCEDURE
	bookbrainz.refresh_mv();

COMMIT;

BEGIN;

-- Trigger to refresh views upon addition/update of edition
CREATE TRIGGER mv_edition_update AFTER INSERT OR UPDATE
	ON bookbrainz.edition_header FOR EACH ROW EXECUTE PROCEDURE
	bookbrainz.refresh_mv();

COMMIT;

BEGIN;

-- Trigger to refresh views upon addition/update of publication
CREATE TRIGGER mv_publication_update AFTER INSERT OR UPDATE
	ON bookbrainz.publication_header FOR EACH ROW EXECUTE PROCEDURE
	bookbrainz.refresh_mv();

COMMIT;

BEGIN;

-- Trigger to refresh views upon addition/update of publisher
CREATE TRIGGER mv_publisher_update AFTER INSERT OR UPDATE
	ON bookbrainz.publisher_header FOR EACH ROW EXECUTE PROCEDURE
	bookbrainz.refresh_mv();

COMMIT;

BEGIN;

-- Trigger to refresh views upon addition/update of work
CREATE TRIGGER mv_work_update AFTER INSERT OR UPDATE
	ON bookbrainz.work_header FOR EACH ROW EXECUTE PROCEDURE
	bookbrainz.refresh_mv();

COMMIT;
