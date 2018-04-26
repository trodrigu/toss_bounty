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
      CREATE MATERIALIZED VIEW toss_bounty_search AS
      SELECT
        github_repos.id AS id,
        github_repos.name AS name,
        (
        setweight(to_tsvector(unaccent(github_repos.name)), 'A') ||
        setweight(to_tsvector(unaccent(campaigns.long_description)), 'B')
        ) AS document
        FROM github_repos
        LEFT JOIN campaigns
        ON campaigns.github_repo_id = github_repos.id
        GROUP BY github_repos.id;
      """
    )

    create index("toss_bounty_search", ["document"], using: :gin)

    execute("CREATE INDEX toss_bounty_search_github_repo_name_trgm_index ON toss_bounty_search USING gin (title gin_trgm_ops)")

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
      CREATE TRIGGER refresh_toss_bounty_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON campaigns
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_toss_bounty_search();
      """
    )

    execute(
      """
      CREATE TRIGGER refresh_toss_bounty_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON github_repos
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_toss_bounty_search();
      """
    )
  end
end
