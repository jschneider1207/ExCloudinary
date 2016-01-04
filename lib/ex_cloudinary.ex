defmodule ExCloudinary do
  use HTTPoison.Base
  @base_url ~S(https://api.cloudinary.com/v1_1)
  @signed_params ~w(callback eager format public_id tags timestamp transformation type)

  @doc """
  Upload an image to your Cloudinary library.
  """
  def upload_image(path) do
    body = %{:file => path, "api_key" => get_api_key, "timestamp" => get_timestamp}
    response = post!("image/upload", body)
    response.body
  end

  ## HTTPoison.Base extensions

  @doc false
  def process_url(url), do: "#{@base_url}/#{get_name}/#{url}"

  @doc false
  def process_request_body(body) do
    body
    |> sign_body()
    |> multipart_encode()
  end

  @doc false
  def process_response_body(body), do: Poison.decode!(body)

  ## Private helpers

  defp get_name, do: Application.get_env(:ex_cloudinary, :name)

  defp get_api_key, do: Application.get_env(:ex_cloudinary, :api_key)

  defp get_api_secret, do: Application.get_env(:ex_cloudinary, :api_secret)

  defp get_timestamp, do: :os.system_time(:seconds) |> Integer.to_string()

  defp sign_body(body) do
    body
    |> generate_signature
    |> add_signature_to_body(body)
  end

  defp generate_signature(body) do
    body
    |> Map.take(@signed_params)
    |> URI.encode_query()
    |> append_secret()
    |> hash_signature()
    |> Base.encode16()
  end

  defp append_secret(signature), do: signature <> get_api_secret

  defp hash_signature(signature), do: :crypto.hash(:sha, signature)

  defp add_signature_to_body(signature, body), do: Map.put(body, "signature", signature)

  defp multipart_encode(body), do: {:multipart, Enum.to_list(body)}
end
