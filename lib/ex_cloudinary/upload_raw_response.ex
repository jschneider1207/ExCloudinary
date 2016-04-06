defmodule ExCloudinary.UploadRawResponse do
  defstruct [bytes: 0, created_at: "", etag: "", 
    original_filename: "", public_id: "", resource_type: "", 
    secure_url: "", signature: "", tags: [], type: "", 
    url: "", version: 0]
  @type t :: %ExCloudinary.UploadRawResponse{bytes: integer, created_at: String.t, 
    etag: String.t, original_filename: String.t, public_id: String.t, 
    resource_type: String.t, secure_url: String.t, signature: String.t, 
    tags: [String.t], type: String.t, url: String.t, version: integer, }
end