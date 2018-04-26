defmodule TossBounty.Repo.Migrations.TossBountySearch do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE EXTENSION IF NOT EXISTS unaccent;
      """
    )

    execute(
      """
      CREATE EXTENSION IF NOT EXISTS pg_trgm;

      """
    )

    execute(
      """
      CREATE MATERIALIZED VIEW toss_bounty_search AS
      SELECT
        campaigns.id AS id,
        github_repos.name AS name,
        (
        setweight(to_tsvector(unaccent(github_repos.name)), 'A') ||
        setweight(to_tsvector(unaccent(users.name)), 'B')
        ) AS document
        FROM campaigns
        LEFT JOIN github_repos
        ON campaigns.github_repo_id = github_repos.id
        LEFT JOIN users
        ON github_repos.user_id = users.id
        GROUP BY campaigns.id, github_repos.name, users.name;
      """
    )

    create index("toss_bounty_search", ["document"], using: :gin)

    execute("CREATE INDEX toss_bounty_search_github_repo_name_trgm_index ON toss_bounty_search USING gin (name gin_trgm_ops)")

    create unique_index("toss_bounty_search", [:id])

    execute(
      """
      CREATE OR REPLACE FUNCTION refresh_toss_bounty_search()
      RETURNS TRIGGER LANGUAGE plpgsql
      AS $$
      BEGIN
      REFRESH MATERIALIZED VIEW CONCURRENTLY toss_bounty_search;
      RETURN NULL;
      END $$;
      """
    )

    execute(
      """
      CREATE TRIGGER refresh_toss_bounty_search_for_campaigns
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON campaigns
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_toss_bounty_search();
      """
    )

    execute(
      """
      CREATE TRIGGER refresh_toss_bounty_for_github_repos
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON github_repos
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_toss_bounty_search();
      """
    )

    execute(
      """
      CREATE TRIGGER refresh_toss_bounty_for_users
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON users
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_toss_bounty_search();
      """
    )
  end
end
