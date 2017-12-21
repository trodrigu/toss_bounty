defmodule TossBountyWeb.SellableIssuesTest do
  use TossBountyWeb.DataCase
  alias TossBountyWeb.SellableIssues
  alias TossBountyWeb.User
  alias TossBountyWeb.SellableIssues.MockIssuesGrabber

  describe "call/3" do

    test "when there are no issues it returns empty" do
      SellableIssues.MockIssuesGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "trodriguez91@icloud.com"}), do: user
      owner = "elm-lang"
      repo_name = "html"
      result = SellableIssues.call(owner, repo_name, user)
      assert [] == result
    end

    test "when there is 1 issue with 3 reactions it includes the body" do
      SellableIssues.MockIssuesGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "trodriguez91@icloud.com"}), do: user
      issues =
        [%{"assignee" => nil, "assignees" => [], "author_association" => "NONE",
            "body" => "Hi, I noticed these `<video>` attributes are missing from the `Attributes` module:\r\n- `crossorigin`\r\n- `mediagroup`\r\n- `muted`\r\nhttps://www.w3.org/TR/html5/embedded-content-0.html#the-video-element\r\n\r\nWould you be interested in a PR?\r\n",
            "closed_at" => nil, "comments" => 1,
            "comments_url" => "https://api.github.com/repos/elm-lang/html/issues/154/comments",
            "created_at" => "2017-11-21T15:01:34Z",
            "events_url" => "https://api.github.com/repos/elm-lang/html/issues/154/events",
            "html_url" => "https://github.com/elm-lang/html/issues/154",
            "id" => 275743372, "labels" => [],
            "labels_url" => "https://api.github.com/repos/elm-lang/html/issues/154/labels{/name}",
            "locked" => false, "milestone" => nil, "number" => 154,
            "reactions" => %{"+1" => 3, "-1" => 0, "confused" => 0, "heart" => 0,
              "hooray" => 0, "laugh" => 0, "total_count" => 3,
              "url" => "https://api.github.com/repos/elm-lang/html/issues/154/reactions"},
            "repository_url" => "https://api.github.com/repos/elm-lang/html",
            "state" => "open", "title" => "video attributes missing",
            "updated_at" => "2017-11-21T15:01:34Z",
            "url" => "https://api.github.com/repos/elm-lang/html/issues/154",
            "user" => %{"avatar_url" => "https://avatars2.githubusercontent.com/u/78849?v=4",
              "events_url" => "https://api.github.com/users/kwijibo/events{/privacy}",
              "followers_url" => "https://api.github.com/users/kwijibo/followers",
              "following_url" => "https://api.github.com/users/kwijibo/following{/other_user}",
              "gists_url" => "https://api.github.com/users/kwijibo/gists{/gist_id}",
              "gravatar_id" => "", "html_url" => "https://github.com/kwijibo",
              "id" => 78849, "login" => "kwijibo",
              "organizations_url" => "https://api.github.com/users/kwijibo/orgs",
              "received_events_url" => "https://api.github.com/users/kwijibo/received_events",
              "repos_url" => "https://api.github.com/users/kwijibo/repos",
              "site_admin" => false,
              "starred_url" => "https://api.github.com/users/kwijibo/starred{/owner}{/repo}",
              "subscriptions_url" => "https://api.github.com/users/kwijibo/subscriptions",
              "type" => "User", "url" => "https://api.github.com/users/kwijibo"}}]

      SellableIssues.MockIssuesGrabber.insert_issues issues
      owner = "elm-lang"
      repo_name = "html"
      result = SellableIssues.call(owner, repo_name, user)
      expected_bodies =
        [
          %{
            title: "video attributes missing",
            body: "Hi, I noticed these `<video>` attributes are missing from the `Attributes` module:\r\n- `crossorigin`\r\n- `mediagroup`\r\n- `muted`\r\nhttps://www.w3.org/TR/html5/embedded-content-0.html#the-video-element\r\n\r\nWould you be interested in a PR?\r\n",
            avatar_url:  "https://avatars2.githubusercontent.com/u/78849?v=4",
            login: "kwijibo"
          }
        ]
      assert expected_bodies == result
    end

    test "when there are 3 issues with more than 2 reactions it returns all three bodies" do
      SellableIssues.MockIssuesGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "trodriguez91@icloud.com"}), do: user
      issues =
        [%{"assignee" => nil, "assignees" => [], "author_association" => "NONE",
            "body" => "Hi, I noticed these `<video>` attributes are missing from the `Attributes` module:\r\n- `crossorigin`\r\n- `mediagroup`\r\n- `muted`\r\nhttps://www.w3.org/TR/html5/embedded-content-0.html#the-video-element\r\n\r\nWould you be interested in a PR?\r\n",
            "closed_at" => nil, "comments" => 1,
            "comments_url" => "https://api.github.com/repos/elm-lang/html/issues/154/comments",
            "created_at" => "2017-11-21T15:01:34Z",
            "events_url" => "https://api.github.com/repos/elm-lang/html/issues/154/events",
            "html_url" => "https://github.com/elm-lang/html/issues/154",
            "id" => 275743372, "labels" => [],
            "labels_url" => "https://api.github.com/repos/elm-lang/html/issues/154/labels{/name}",
            "locked" => false, "milestone" => nil, "number" => 154,
            "reactions" => %{"+1" => 3, "-1" => 0, "confused" => 0, "heart" => 0,
              "hooray" => 0, "laugh" => 0, "total_count" => 3,
              "url" => "https://api.github.com/repos/elm-lang/html/issues/154/reactions"},
            "repository_url" => "https://api.github.com/repos/elm-lang/html",
            "state" => "open", "title" => "video attributes missing",
            "updated_at" => "2017-11-21T15:01:34Z",
            "url" => "https://api.github.com/repos/elm-lang/html/issues/154",
            "user" => %{"avatar_url" => "https://avatars2.githubusercontent.com/u/78849?v=4",
              "events_url" => "https://api.github.com/users/kwijibo/events{/privacy}",
              "followers_url" => "https://api.github.com/users/kwijibo/followers",
              "following_url" => "https://api.github.com/users/kwijibo/following{/other_user}",
              "gists_url" => "https://api.github.com/users/kwijibo/gists{/gist_id}",
              "gravatar_id" => "", "html_url" => "https://github.com/kwijibo",
              "id" => 78849, "login" => "kwijibo",
              "organizations_url" => "https://api.github.com/users/kwijibo/orgs",
              "received_events_url" => "https://api.github.com/users/kwijibo/received_events",
              "repos_url" => "https://api.github.com/users/kwijibo/repos",
              "site_admin" => false,
              "starred_url" => "https://api.github.com/users/kwijibo/starred{/owner}{/repo}",
              "subscriptions_url" => "https://api.github.com/users/kwijibo/subscriptions",
              "type" => "User", "url" => "https://api.github.com/users/kwijibo"}},
          %{"assignee" => nil, "assignees" => [], "author_association" => "NONE",
            "body" => "A simple 2 pages view is provided as an example.\r\n\r\nTo reproduce the problem:\r\n- type some string to input field of *page1*\r\n- click on \"page2\" button\r\n\r\nExpected result: Input field on *page2* is suppose to be empty.\r\nActual result: Input field on *page2* contains the value from the *page1*.\r\n\r\nElm version: 0.18.0 (installed via nix package manager)\r\nOS: Ubuntu 16.04\r\nbrowser: firefox 56.0 (64-bit)\r\n\r\nTestfile:\r\n\r\n```\r\nimport Html exposing (..)\r\nimport Html.Attributes exposing (..)\r\nimport Html.Events exposing (..)\r\n\r\ntype Page\r\n    = Page1\r\n    | Page2\r\n\r\ntype Msg\r\n    = NewPage Page\r\n    | Query1 String\r\n    | Query2 String\r\n\r\ntype alias Model =\r\n    { selectedPage      : Page\r\n    , query1            : String\r\n    , query2            : String\r\n    }\r\n\r\nmain : Program Never Model Msg\r\nmain =\r\n    beginnerProgram\r\n        { model = (Model Page1 \"\" \"\")\r\n        , view = view\r\n        , update = update\r\n        }\r\n\r\nview : Model -> Html Msg\r\nview model =\r\n    div []\r\n        [ fieldset []\r\n            [ button [ onClick (NewPage Page1) ] [ text \"page1\" ]\r\n            , button [ onClick (NewPage Page2) ] [ text \"page2\" ]\r\n            ]\r\n        , text \"this is page: \"\r\n        , text (toString model.selectedPage)\r\n        , viewLevel2 model\r\n        ]\r\n\r\nviewLevel2 : Model -> Html Msg\r\nviewLevel2 model =\r\n    case model.selectedPage of\r\n        Page1 ->\r\n            div []\r\n                [ input\r\n                    [ placeholder \"query for page1\"\r\n                    , defaultValue model.query1\r\n                    , onInput Query1\r\n                    ] []\r\n                , text \"copy of the query: \"\r\n                , text model.query1\r\n                ]\r\n        Page2 ->\r\n            div []\r\n                [ input\r\n                    [ placeholder \"query for page2\"\r\n                    , defaultValue model.query2\r\n                    , onInput Query2\r\n                    ] []\r\n                , text \"copy of the query: \"\r\n                , text model.query2\r\n                ]\r\n\r\nupdate : Msg -> Model -> Model\r\nupdate msg model =\r\n    case msg of\r\n        NewPage page -> {model | selectedPage = page}\r\n        Query1 s -> {model | query1 = s}\r\n        Query2 s -> {model | query2 = s}\r\n```\r\n\r\n\r\n",
            "closed_at" => nil, "comments" => 4,
            "comments_url" => "https://api.github.com/repos/elm-lang/html/issues/152/comments",
            "created_at" => "2017-11-14T13:46:48Z",
            "events_url" => "https://api.github.com/repos/elm-lang/html/issues/152/events",
            "html_url" => "https://github.com/elm-lang/html/issues/152",
            "id" => 273797905, "labels" => [],
            "labels_url" => "https://api.github.com/repos/elm-lang/html/issues/152/labels{/name}",
            "locked" => false, "milestone" => nil, "number" => 152,
            "reactions" => %{"+1" => 3, "-1" => 0, "confused" => 0, "heart" => 0,
              "hooray" => 0, "laugh" => 0, "total_count" => 3,
              "url" => "https://api.github.com/repos/elm-lang/html/issues/152/reactions"},
            "repository_url" => "https://api.github.com/repos/elm-lang/html",
            "state" => "open",
            "title" => "Html.input defaultValue does not update properly when switching pages",
            "updated_at" => "2017-11-14T15:44:21Z",
            "url" => "https://api.github.com/repos/elm-lang/html/issues/152",
            "user" => %{"avatar_url" => "https://avatars0.githubusercontent.com/u/9718081?v=4",
              "events_url" => "https://api.github.com/users/zoranbosnjak/events{/privacy}",
              "followers_url" => "https://api.github.com/users/zoranbosnjak/followers",
              "following_url" => "https://api.github.com/users/zoranbosnjak/following{/other_user}",
              "gists_url" => "https://api.github.com/users/zoranbosnjak/gists{/gist_id}",
              "gravatar_id" => "", "html_url" => "https://github.com/zoranbosnjak",
              "id" => 9718081, "login" => "zoranbosnjak",
              "organizations_url" => "https://api.github.com/users/zoranbosnjak/orgs",
              "received_events_url" => "https://api.github.com/users/zoranbosnjak/received_events",
              "repos_url" => "https://api.github.com/users/zoranbosnjak/repos",
              "site_admin" => false,
              "starred_url" => "https://api.github.com/users/zoranbosnjak/starred{/owner}{/repo}",
              "subscriptions_url" => "https://api.github.com/users/zoranbosnjak/subscriptions",
              "type" => "User", "url" => "https://api.github.com/users/zoranbosnjak"}},
          %{"assignee" => nil, "assignees" => [], "author_association" => "NONE",
            "body" => "Followup from #149:\r\n\r\nI was using Javascript to add nodes as children of a node created by Elm. The Elm-created parent node and the JS-created nodes were both entirely dependent on a single field in the Elm model that I sent to JS via a port.\r\n\r\nThe command to add the child nodes in JS is sent if and only if the field they depend on is updated. I wanted to guarantee that Elm would redraw the parent node only under the same circumstances, so the nodes created by JS wouldn't get clobbered.\r\n\r\n`lazy`'s documentation suggests, to me, that it's a good tool for this job:\r\n- \"It checks to see if all the arguments are equal. If so, it skips calling the function!\"\r\n- \"During diffing, we can check to see if `model` is referentially equal to the previous value used, and if so, we just stop. No need to build up the tree structure and diff it\"\r\n\r\nThese do broadly describe how `lazy` works, but neither is AFAICT *necessarily* true. It would have been useful to me to know that using `lazy` won't *guarantee* that things work that way *all the time*, and that there are other mechanisms that may still result in your function being called.\r\n\r\nThe note about `lazy` being a performance optimization is a nod in that direction, and it would help to firmly make the point that it's *only* for performance optimization, and you shouldn't rely on it for correctness. Replacing \"If so, it skips calling the function\" with \"If so, we might be able to skip calling the function\" would help make that point, as would \"During diffing, sometimes we can check...\"\r\n\r\nI don't think that `lazy`'s docs explicitly claim that it does what I wanted, but they don't not claim it, and that's basically what would have helped me.",
            "closed_at" => nil, "comments" => 1,
            "comments_url" => "https://api.github.com/repos/elm-lang/html/issues/150/comments",
            "created_at" => "2017-10-03T19:00:26Z",
            "events_url" => "https://api.github.com/repos/elm-lang/html/issues/150/events",
            "html_url" => "https://github.com/elm-lang/html/issues/150",
            "id" => 262547772, "labels" => [],
            "labels_url" => "https://api.github.com/repos/elm-lang/html/issues/150/labels{/name}",
            "locked" => false, "milestone" => nil, "number" => 150,
            "reactions" => %{"+1" => 3, "-1" => 0, "confused" => 0, "heart" => 0,
              "hooray" => 0, "laugh" => 0, "total_count" => 3,
              "url" => "https://api.github.com/repos/elm-lang/html/issues/150/reactions"},
            "repository_url" => "https://api.github.com/repos/elm-lang/html",
            "state" => "open", "title" => "Html.Lazy documentation could be clearer",
            "updated_at" => "2017-10-03T19:00:27Z",
            "url" => "https://api.github.com/repos/elm-lang/html/issues/150",
            "user" => %{"avatar_url" => "https://avatars3.githubusercontent.com/u/1322287?v=4",
              "events_url" => "https://api.github.com/users/wohanley/events{/privacy}",
              "followers_url" => "https://api.github.com/users/wohanley/followers",
              "following_url" => "https://api.github.com/users/wohanley/following{/other_user}",
              "gists_url" => "https://api.github.com/users/wohanley/gists{/gist_id}",
              "gravatar_id" => "", "html_url" => "https://github.com/wohanley",
              "id" => 1322287, "login" => "wohanley",
              "organizations_url" => "https://api.github.com/users/wohanley/orgs",
              "received_events_url" => "https://api.github.com/users/wohanley/received_events",
              "repos_url" => "https://api.github.com/users/wohanley/repos",
              "site_admin" => false,
              "starred_url" => "https://api.github.com/users/wohanley/starred{/owner}{/repo}",
              "subscriptions_url" => "https://api.github.com/users/wohanley/subscriptions",
              "type" => "User", "url" => "https://api.github.com/users/wohanley"}}
        ]
      SellableIssues.MockIssuesGrabber.insert_issues issues
      owner = "elm-lang"
      repo_name = "html"
      result = SellableIssues.call(owner, repo_name, user)
      expected_bodies =
        [
          %{
            title: "video attributes missing",
            body: "Hi, I noticed these `<video>` attributes are missing from the `Attributes` module:\r\n- `crossorigin`\r\n- `mediagroup`\r\n- `muted`\r\nhttps://www.w3.org/TR/html5/embedded-content-0.html#the-video-element\r\n\r\nWould you be interested in a PR?\r\n",
            avatar_url:  "https://avatars2.githubusercontent.com/u/78849?v=4",
            login: "kwijibo"
          },
          %{
            title: "Html.input defaultValue does not update properly when switching pages",
            body: "A simple 2 pages view is provided as an example.\r\n\r\nTo reproduce the problem:\r\n- type some string to input field of *page1*\r\n- click on \"page2\" button\r\n\r\nExpected result: Input field on *page2* is suppose to be empty.\r\nActual result: Input field on *page2* contains the value from the *page1*.\r\n\r\nElm version: 0.18.0 (installed via nix package manager)\r\nOS: Ubuntu 16.04\r\nbrowser: firefox 56.0 (64-bit)\r\n\r\nTestfile:\r\n\r\n```\r\nimport Html exposing (..)\r\nimport Html.Attributes exposing (..)\r\nimport Html.Events exposing (..)\r\n\r\ntype Page\r\n    = Page1\r\n    | Page2\r\n\r\ntype Msg\r\n    = NewPage Page\r\n    | Query1 String\r\n    | Query2 String\r\n\r\ntype alias Model =\r\n    { selectedPage      : Page\r\n    , query1            : String\r\n    , query2            : String\r\n    }\r\n\r\nmain : Program Never Model Msg\r\nmain =\r\n    beginnerProgram\r\n        { model = (Model Page1 \"\" \"\")\r\n        , view = view\r\n        , update = update\r\n        }\r\n\r\nview : Model -> Html Msg\r\nview model =\r\n    div []\r\n        [ fieldset []\r\n            [ button [ onClick (NewPage Page1) ] [ text \"page1\" ]\r\n            , button [ onClick (NewPage Page2) ] [ text \"page2\" ]\r\n            ]\r\n        , text \"this is page: \"\r\n        , text (toString model.selectedPage)\r\n        , viewLevel2 model\r\n        ]\r\n\r\nviewLevel2 : Model -> Html Msg\r\nviewLevel2 model =\r\n    case model.selectedPage of\r\n        Page1 ->\r\n            div []\r\n                [ input\r\n                    [ placeholder \"query for page1\"\r\n                    , defaultValue model.query1\r\n                    , onInput Query1\r\n                    ] []\r\n                , text \"copy of the query: \"\r\n                , text model.query1\r\n                ]\r\n        Page2 ->\r\n            div []\r\n                [ input\r\n                    [ placeholder \"query for page2\"\r\n                    , defaultValue model.query2\r\n                    , onInput Query2\r\n                    ] []\r\n                , text \"copy of the query: \"\r\n                , text model.query2\r\n                ]\r\n\r\nupdate : Msg -> Model -> Model\r\nupdate msg model =\r\n    case msg of\r\n        NewPage page -> {model | selectedPage = page}\r\n        Query1 s -> {model | query1 = s}\r\n        Query2 s -> {model | query2 = s}\r\n```\r\n\r\n\r\n",
            avatar_url: "https://avatars0.githubusercontent.com/u/9718081?v=4",
            login: "zoranbosnjak"
          },
          %{
            title: "Html.Lazy documentation could be clearer",
            body: "Followup from #149:\r\n\r\nI was using Javascript to add nodes as children of a node created by Elm. The Elm-created parent node and the JS-created nodes were both entirely dependent on a single field in the Elm model that I sent to JS via a port.\r\n\r\nThe command to add the child nodes in JS is sent if and only if the field they depend on is updated. I wanted to guarantee that Elm would redraw the parent node only under the same circumstances, so the nodes created by JS wouldn't get clobbered.\r\n\r\n`lazy`'s documentation suggests, to me, that it's a good tool for this job:\r\n- \"It checks to see if all the arguments are equal. If so, it skips calling the function!\"\r\n- \"During diffing, we can check to see if `model` is referentially equal to the previous value used, and if so, we just stop. No need to build up the tree structure and diff it\"\r\n\r\nThese do broadly describe how `lazy` works, but neither is AFAICT *necessarily* true. It would have been useful to me to know that using `lazy` won't *guarantee* that things work that way *all the time*, and that there are other mechanisms that may still result in your function being called.\r\n\r\nThe note about `lazy` being a performance optimization is a nod in that direction, and it would help to firmly make the point that it's *only* for performance optimization, and you shouldn't rely on it for correctness. Replacing \"If so, it skips calling the function\" with \"If so, we might be able to skip calling the function\" would help make that point, as would \"During diffing, sometimes we can check...\"\r\n\r\nI don't think that `lazy`'s docs explicitly claim that it does what I wanted, but they don't not claim it, and that's basically what would have helped me.",
            avatar_url: "https://avatars3.githubusercontent.com/u/1322287?v=4",
            login: "wohanley"
          }
        ]
      assert expected_bodies == result
    end
  end
end
