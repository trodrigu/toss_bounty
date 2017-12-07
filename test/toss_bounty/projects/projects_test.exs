defmodule TossBountyWeb.ProjectsTest do
  use TossBountyWeb.ModelCase

  alias TossBountyWeb.Projects
  alias TossBountyWeb.User

  setup do
    user = with {:ok, user} <- Repo.insert!(%User{email: "test@test.com"}), do: user
    {:ok, user: user}
  end

  describe "projects" do
    alias TossBountyWeb.Projects.Project

    @valid_attrs %{
      current_funding: 120.5,
      funding_end_date: ~N[2010-04-17 14:00:00.000000],
      funding_goal: 120.5,
      long_description: "some long_description",
      short_description: "some short_description",
    }
    @update_attrs %{
      current_funding: 456.7,
      funding_end_date: ~N[2011-05-18 15:01:01.000000],
      funding_goal: 456.7,
      long_description: "some updated long_description",
      short_description: "some updated short_description",
    }
    @invalid_attrs %{
      current_funding: nil,
      funding_end_date: nil,
      funding_goal: nil,
      long_description: nil,
      short_description: nil,
    }

    def project_fixture(attrs \\ %{}) do
      user = attrs[:user]
      attrs = Map.put(@valid_attrs, :user_id, user.id)
      {:ok, project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Projects.create_project()

      project
    end

    test "list_projects/0 returns all projects", %{user: user} do
      project = project_fixture(%{user: user})
      assert Projects.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id", %{user: user} do
      project = project_fixture(%{user: user})
      assert Projects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project", %{user: user} do
      attrs = Map.put(@valid_attrs, :user_id, user.id)
      assert {:ok, %Project{} = project} = Projects.create_project(attrs)
      assert project.current_funding == 120.5
      assert project.funding_end_date == ~N[2010-04-17 14:00:00.000000]
      assert project.funding_goal == 120.5
      assert project.long_description == "some long_description"
      assert project.short_description == "some short_description"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project", %{user: user} do
      project = project_fixture(%{user: user})
      assert {:ok, project} = Projects.update_project(project, @update_attrs)
      assert %Project{} = project
      assert project.current_funding == 456.7
      assert project.funding_end_date == ~N[2011-05-18 15:01:01.000000]
      assert project.funding_goal == 456.7
      assert project.long_description == "some updated long_description"
      assert project.short_description == "some updated short_description"
    end

    test "update_project/2 with invalid data returns error changeset", %{user: user} do
      project = project_fixture(%{user: user})
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project", %{user: user} do
      project = project_fixture(%{user: user})
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset", %{user: user}  do
      project = project_fixture(%{user: user})
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end
end
