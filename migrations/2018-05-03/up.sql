/*
 * Copyright (C) 2018  Shivam Tripathi
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

BEGIN;

/*
 * This migration makes necessary changes in the database to avail full text search
 * feature of Postgres on BookBrainz site.
 */

CREATE EXTENSION pg_trgm;
CREATE EXTENSION unaccent;
CREATE EXTENSION btree_gin;

-- Column to cache tokenized alias names
ALTER TABLE bookbrainz.alias
	ADD COLUMN IF NOT EXISTS tokens TSVECTOR;


-- Cache tokens of all previously added alias names
UPDATE bookbrainz.alias
	SET tokens = to_tsvector('pg_catalog.simple', unaccent(name));


-- Function to unaccent the name row before tokenizing it
CREATE FUNCTION bookbrainz.token_creator() RETURNS trigger
	AS $token_creator$
	BEGIN
		new.tokens := to_tsvector('pg_catalog.simple', unaccent(new.name));
		RETURN new;
	END
$token_creator$ LANGUAGE plpgsql;


-- Trigger to automatically unaccent and insert tokens of an added alias name
CREATE TRIGGER alias_token_update BEFORE INSERT OR UPDATE
	ON bookbrainz.alias
    FOR EACH ROW
    EXECUTE PROCEDURE bookbrainz.token_creator();


-- View to extract all the master entities
CREATE VIEW bookbrainz.master_entities AS
	SELECT bbid as entity_id, default_alias_id as alias_id, 'creator' AS entity_type
		FROM bookbrainz.creator
		WHERE master=true
	UNION
	SELECT bbid as entity_id, default_alias_id as alias_id, 'edition' AS entity_type
		FROM bookbrainz.edition
		WHERE master=true
	UNION
	SELECT bbid as entity_id, default_alias_id as alias_id, 'publication' AS entity_type
		FROM bookbrainz.publication
		WHERE master=true
	UNION
	SELECT bbid as entity_id, default_alias_id as alias_id, 'publisher' AS entity_type
		FROM bookbrainz.publisher
		WHERE master=true
	UNION
	SELECT bbid as entity_id, default_alias_id as alias_id, 'work' AS entity_type
		FROM bookbrainz.work
		WHERE master=true;


/*
 * The primary materialized view which holds all the relevant information about master entities.
 * Token field is indexed for quick FTS.
 * A unique index is created to help execute REFRESH CONCURRENTLY command.
 * This unique indexing can be modified later when imports are added.
 * Sample query:
 * SELECT * FROM search_mv
 *		WHERE tokens @@ to_tsquery('pg_catalog.simple', 'Cha:* | Dar:*')
 *		ORDER BY ts_rank(search_mv.tokens, to_tsquery('english', 'Cha:* | Dar:*')) DESC;
 */
 CREATE MATERIALIZED VIEW bookbrainz.search_mv AS
	SELECT items.entity_id, alias.name, alias.tokens, items.entity_type
	FROM bookbrainz.alias AS alias
	JOIN (
		SELECT *
		FROM bookbrainz.master_entities
	) AS items
	ON alias.id = items.alias_id;

CREATE INDEX fts_search_idx ON bookbrainz.search_mv USING gin(tokens);
CREATE UNIQUE INDEX unique_search_idx ON bookbrainz.search_mv (entity_id);


/*
 * This view holds all the master entities with empty tokens, signifying unsupported
 * alphabet. An index is added on the name field of search_mv to facilitate quicker
 * ILIKE operations.
 */
CREATE VIEW bookbrainz.untokenized_names AS
	SELECT * FROM bookbrainz.search_mv WHERE tokens = '';

CREATE INDEX untokenized_names_idx ON bookbrainz.search_mv USING gin(name);


/*
 * This materialized view stores all unique tokens, used to suggest the next best query.
 * Words have been trigram indexed for quick fuzzy search.
 * A unique index has been created on words to help execute REFRESH CONCURRENTLY command.
 * Sample query:
 * select word from search_words_mv ORDER BY similarity(word, 'chales') DESC limit 10;
 */
CREATE MATERIALIZED VIEW bookbrainz.search_words_mv AS
	SELECT word FROM ts_stat($$
		SELECT alias.tokens
		FROM bookbrainz.alias AS alias
		JOIN (
			SELECT alias_id
			FROM bookbrainz.master_entities
		) AS items
		ON alias.id = items.alias_id;
	$$);

CREATE INDEX search_words_mv_idx ON search_words_mv USING gin(word gin_trgm_ops);
CREATE UNIQUE INDEX unique_word_idx ON bookbrainz.search_words_mv (word);


-- Refresh search_mv and search_words_mv materialized views
CREATE FUNCTION bookbrainz.refresh_mv() RETURNS TRIGGER
	AS $refresh_mv$
	BEGIN
		REFRESH MATERIALIZED VIEW CONCURRENTLY bookbrainz.search_mv;
		REFRESH MATERIALIZED VIEW CONCURRENTLY bookbrainz.search_words_mv;
		RETURN NULL;
	END
$refresh_mv$ LANGUAGE plpgsql;


/*
 * Triggers which call refresh_mv function to refresh all materialized views
 * upon any update or addition of entities.
 */
CREATE TRIGGER mv_creator_update AFTER INSERT OR UPDATE
	ON bookbrainz.creator_header FOR EACH ROW EXECUTE PROCEDURE
	bookbrainz.refresh_mv();

CREATE TRIGGER mv_edition_update AFTER INSERT OR UPDATE
	ON bookbrainz.edition_header FOR EACH ROW EXECUTE PROCEDURE
	bookbrainz.refresh_mv();

CREATE TRIGGER mv_publication_update AFTER INSERT OR UPDATE
	ON bookbrainz.publication_header FOR EACH ROW EXECUTE PROCEDURE
	bookbrainz.refresh_mv();

CREATE TRIGGER mv_publisher_update AFTER INSERT OR UPDATE
	ON bookbrainz.publisher_header FOR EACH ROW EXECUTE PROCEDURE
	bookbrainz.refresh_mv();

CREATE TRIGGER mv_work_update AFTER INSERT OR UPDATE
	ON bookbrainz.work_header FOR EACH ROW EXECUTE PROCEDURE
	bookbrainz.refresh_mv();


ALTER MATERIALIZED VIEW IF EXISTS bookbrainz.search_mv OWNER TO bookbrainz;
ALTER MATERIALIZED VIEW IF EXISTS bookbrainz.search_words_mv OWNER TO bookbrainz;
ALTER VIEW IF EXISTS bookbrainz.master_entities OWNER TO bookbrainz;
ALTER VIEW IF EXISTS bookbrainz.untokenized_names OWNER TO bookbrainz;

END;
