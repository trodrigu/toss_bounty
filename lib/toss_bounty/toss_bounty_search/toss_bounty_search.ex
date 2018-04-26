defmodule TossBountySearch do
  import Ecto.Query

  def run(query, search_string) do
    _run(query, normalize(search_string))
  end

  defmacro matching_toss_bounty_search_ids_and_ranks(search_string) do
    quote do
      fragment(
        """
        SELECT toss_bounty_search.id AS id,
        ts_rank(
          toss_bounty_search.document, plainto_tsquery(unaccent(?))
        ) AS rank
        FROM toss_bounty_search
        WHERE toss_bounty_search.document @@ plainto_tsquery(unaccent(?))
        OR toss_bounty_search.name ILIKE ?
        """,
        ^unquote(search_string),
        ^unquote(search_string),
        ^"%#{unquote(search_string)}%"
      )
    end
  end

  defp _run(query, ""), do: query
  defp _run(query, search_string) do
    from campaign in query,
      join: id_and_rank in matching_toss_bounty_search_ids_and_ranks(search_string),
      on: id_and_rank.id == campaign.id,
      order_by: [desc: id_and_rank.rank]
  end

  defp normalize(search_string) do
    search_string
    |> String.replace(~r/\n/, " ")
    |> String.replace(~r/\t/, " ")
    |> String.replace(~r/\s{2,}/, " ")
    |> String.trim
  end
end
