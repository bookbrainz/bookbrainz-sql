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

DROP VIEW IF EXISTS bookbrainz.untokenized_names;
DROP MATERIALIZED VIEW IF EXISTS bookbrainz.search_mv;
DROP MATERIALIZED VIEW IF EXISTS bookbrainz.search_words_mv;
DROP VIEW IF EXISTS bookbrainz.master_entities;

DROP TRIGGER IF EXISTS alias_token_update ON bookbrainz.alias;

DROP TRIGGER IF EXISTS mv_publisher_update ON bookbrainz.publisher_header;
DROP TRIGGER IF EXISTS mv_creator_update ON bookbrainz.creator_header;
DROP TRIGGER IF EXISTS mv_work_update ON bookbrainz.work_header;
DROP TRIGGER IF EXISTS mv_edition_update ON bookbrainz.edition_header;
DROP TRIGGER IF EXISTS mv_publication_update ON bookbrainz.publication_header;

DROP FUNCTION IF EXISTS bookbrainz.token_creator;
DROP FUNCTION IF EXISTS bookbrainz.refresh_mv cascade;

ALTER TABLE bookbrainz.alias DROP COLUMN tokens;

DROP EXTENSION IF EXISTS pg_trgm;
DROP EXTENSION IF EXISTS unaccent;
DROP EXTENSION IF EXISTS btree_gin;

END;
