defmodule Webclient.Plug.VerifyRequest do

  defmodule IncompleteRequestError do
    @moduledoc """
    Error raised when a required field is missing.
    """

    defexception message: "IncompleteRequestError", plug_status: 400
  end

  def init(options), do: options

  def call(%Plug.Conn{request_path: path} = conn, opts) do
    IO.inspect opts
    if path in opts[:paths], do: verify_request!(conn.body_params, opts[:fields])
    conn
  end

  defp verify_request!(body_params, fields) do
    verified = 
                #IO.inspect body_params
                body_params
               |> Map.keys
               |> contains_fields?(fields)
    IO.inspect verified           
    unless verified, do: raise IncompleteRequestError
  end

  defp contains_fields?(keys, fields), do: Enum.all?(fields, &(&1 in keys))
end

