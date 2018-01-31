defmodule TossBounty.StripeProcessing.MockStripeSubscriptionDeleter do
  @behaviour TossBountyWeb.SubscriptionController.Behaviour

  def delete(conn, subscription_id) do
    errors = conn.assigns[:errors]

    case errors do
      :none_found ->
        {:error,
         %Stripe.APIErrorResponse{
           code: nil,
           message: "No such subscription: sub_CDYHNRRzrjnVTO",
           status_code: 404,
           type: "invalid_request_error"
         }}

      _ ->
        {:ok, %{deleted: true, id: "sub_CDYHNRRzrjnVTO"}}
    end
  end
end
