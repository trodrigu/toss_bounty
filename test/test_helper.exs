ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(TossBounty.Repo, :manual)

TossBounty.Github.SellableRepos.MockReposGrabber.start_link()
TossBounty.Github.SellableIssues.MockIssuesGrabber.start_link()
