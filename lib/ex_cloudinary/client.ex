defmodule ExCloudinary.Client do
  @moduledoc false  
  use HTTPoison.Base
  @after_compile __MODULE__
  @base_url ~S(https://api.cloudinary.com/v1_1)
  @signed_params ~w(callback eager format from_public_id public_id tags timestamp to_public_id text transformation type)a
  @cloud_name Application.get_env(:ex_cloudinary, :cloud_name)
  @api_key Application.get_env(:ex_cloudinary, :api_key)
  @api_secret Application.get_env(:ex_cloudinary, :api_secret, <<0>>)
  
  ## HTTPoison.Base extensions

  @doc false
  def process_url(url), do: "#{@base_url}/#{@cloud_name}/#{url}"

  @doc false
  def process_request_body(body) do
    body
    |> Keyword.merge([api_key: @api_key, timestamp: get_timestamp])
    |> sign_body()
    |> multipart_encode()
  end

  @doc false
  #def process_response_body(body), do: Poison.decode!(body)

  ## Private helpers
  
  defp get_timestamp, do: :os.system_time(:seconds) |> Integer.to_string()

  defp sign_body(body) do
    body
    |> generate_signature()
    |> add_signature_to_body(body)
  end

  defp generate_signature(body) do
    body
    |> Keyword.take(@signed_params)
    |> List.keysort(0)
    |> join_query()
    |> append_secret()
    |> hash_signature()
    |> Base.encode16()
  end

  defp join_query(params) do
    Enum.map_join(params, "&", fn {k, v} -> "#{k}=#{v}" end)
  end

  defp append_secret(signature), do: signature <> @api_secret

  defp hash_signature(signature), do: :crypto.hash(:sha, signature)

  defp add_signature_to_body(signature, body), do: Keyword.put(body, :signature, signature)

  defp multipart_encode(body) do
    body = Enum.map(body, fn {:file, path} -> {:file, path}
                              {key, value} -> {to_string(key), value} end)
    {:multipart, body}
  end
  
  def __after_compile__(env, _bytecode) do
    if is_nil(@cloud_name), do: raise error_msg("cloud name")
    if is_nil(@api_key), do: raise error_msg("api_key")
    if @api_secret == <<0>>, do: raise error_msg("api_secret")
  end
  
  defp error_msg(missing) do
  ~s"""
  Missing config for `#{missing}`.
  
  Ensure your `config.exs` is set according to the following:
    config :ex_cloudinary,
      cloud_name: "",
      api_key: "",
      api_secret: ""
  """
  end
end
