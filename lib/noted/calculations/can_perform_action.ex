defmodule Noted.Calculations.CanPerformAction do
  use Ash.Resource.Calculation

  @impl true
  def calculate(records, [action: action] = _opts, context)
      when action in [:create, :read, :update, :destroy] do
    Enum.map(records, fn record ->
      Ash.can?({record, action}, context.actor, tenant: context.tenant)
    end)
  end
end
