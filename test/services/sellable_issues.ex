defmodule TossBounty.SellableIssues do

  @valid_attrs %{repo: 'trodrigu/test_repo.ex'}
  @invalid_attrs %{}

  describe "perform" do

    test "without an argument" do
      {:errors, error_message} = service.perform
      assert error_message == "Argument Missing"
    end

    test "when there are zero issues" do
      assert service.count == 0
    end

    test "when there is one issues" do
      assert service.count == 1
    end

    test "when there are ten issues" do
      assert service.count == 10
    end
  end
end
