defmodule ExCloudinary.GenerateTextLayerResponse do
  defstruct [bytes: 0, created_at: "", 
    format: "", height: 0, public_id: "", resource_type: "", 
    secure_url: "", signature: "", tags: [], type: "", 
    url: "", version: 0, width: 0]
  @type t :: %ExCloudinary.GenerateTextLayerResponse{bytes: integer, created_at: String.t, 
    format: String.t, height: integer, public_id: String.t, resource_type: String.t, 
    secure_url: String.t, signature: String.t, tags: [String.t], 
    type: String.t, url: String.t, version: integer, width: integer}
end