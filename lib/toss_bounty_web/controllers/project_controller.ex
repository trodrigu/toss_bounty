defmodule TossBountyWeb.ProjectController do
  use TossBountyWeb.Web, :controller

  alias TossBountyWeb.Projects
  alias TossBountyWeb.Projects.Project
  alias JaSerializer.Params

  action_fallback TossBountyWeb.FallbackController

  def index(conn, _params) do
    projects = Projects.list_projects()
    render(conn, "index.json-api", data: projects)
  end

  def create(conn, %{"data" => data = %{"type" => "project", "attributes" => project_params}}) do
    attrs = Params.to_attributes(data)
    with {:ok, %Project{} = project} <- Projects.create_project(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", project_path(conn, :show, project))
      |> render("show.json-api", data: project)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Projects.get_project!(id)
    render(conn, "show.json-api", data: project)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "project", "attributes" => project_params}}) do
    project = Projects.get_project!(id)
    attrs = Params.to_attributes(data)

    with {:ok, %Project{} = project} <- Projects.update_project(project, attrs) do
      render(conn, "show.json-api", data: project)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Projects.get_project!(id)
    with {:ok, %Project{}} <- Projects.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end
end
