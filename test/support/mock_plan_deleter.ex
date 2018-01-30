defmodule TossBounty.StripeProcessing.MockStripePlanDeleter do
  @behaviour TossBountyWeb.PlanController.Behaviour

  def delete(conn, plan_id) do
    errors = conn.assigns[:errors]

    case errors do
      :none_found ->
        {:error,
         %Stripe.APIErrorResponse{
           code: nil,
           message: "No such plan: plan_CDYHNRRzrjnVTO",
           status_code: 404,
           type: "invalid_request_error"
         }}

      _ ->
        {:ok, %{deleted: true, id: "plan_CDYHNRRzrjnVTO"}}
    end
  end
end
