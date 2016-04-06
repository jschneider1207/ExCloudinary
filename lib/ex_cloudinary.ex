defmodule ExCloudinary do
  @moduledoc """
  A wrapper around the [HTTPoison](https://github.com/edgurgel/httpoison).Base module for the image CDN service [Cloudinary](http://cloudinary.com/).
  """
  alias ExCloudinary.{Client, UploadResponse, DeleteResponse, RenameResponse, UploadRawResponse, GenerateTextLayerResponse}

  @upload_image_opts ~w"""
    public_id resource_type type tags context transformation format allowed_formats
    eager eager_async proxy notification_url eager_notification_url backup
    return_delete_token return_delete_token faces exif colors image_metadata phash
    invalidate use_filename unique_filename folder overwrite discard_original_filename
    face_coordinates custom_coordinates raw_convert auto_tagging background_removal
    moderation upload_preset
    """a
  @generate_text_layer_opts ~w(public_id font_family font_size font_color font_weight font_style background opacity text_decoration)a

  @doc """
  Upload an image to your Cloudinary library.

  ## Examples

        iex> ExCloudinary.upload_image("/path/to/image.jpeg")
        response

        iex> ExCloudinary.upload_image("https://www.internet.com/image.jpeg")
        response

  ## Parameters

    * `file` - Either the local path to an image or the http url of a public image resource.
    * `opts` - Keyword list of upload options (see below).

  ## Options

    * `public_id` - The identifier that is used for accessing the uploaded resource. A randomly generated ID is assigned if not specified. The public ID may contain a full path including folders separated by `/`.
    * `resource_type` - Valid values: `image`, `raw` and `auto`. Default: `image`.
    * `type` - Allows uploading images as `private` or `authenticated`. Valid values: `upload`, `private` and `authenticated`. Default: `upload`.
    * `tags` - A comma-separated list of tag names to assign to the uploaded image for later group reference.
    * `context` - A pipe separated list of key-value pairs of general textual context metadata to attach to an uploaded resource. The context values of uploaded files are available for fetching using the Admin API. For example: `alt=My image|caption=Profile Photo`.
    * `transformation` - A transformation to run on the uploaded image before saving it in the cloud. For example: limit the dimension of the uploaded image to 512x512 pixels.
    * `format` - An optional format to convert the uploaded image to before saving in the cloud. For example: `jpg`.
    * `allowed_formats` - A comma-separated list of file formats that are allowed for uploading. The default is any supported image kind and any type of raw file. Files of other types will be rejected. The formats can be image types or raw file extensions. For example: `jpg,gif,doc`.
    * `eager` - A list of transformations to create for the uploaded image during the upload process, instead of lazily creating them when being accessed by your site's visitors. The transformation strings are separated by `|`.
    * `eager_async` - (boolean) Whether to generate the eager transformations asynchronously in the background after the upload request is completed rather than online as part of the upload call. Default: false.
    * `proxy` - Tells Cloudinary to upload images from remote URLs through the given proxy. Format: `http://hostname:post`.
    * `notification_url` - An HTTP URL to send notification to (a webhook) when the upload is completed or any requested asynchronous action is completed.
    * `eager_notification_url` - An HTTP URL to send notification to (a webhook) when the generation of eager transformations is completed.
    * `backup` - (boolean) Tell Cloudinary whether to backup the uploaded image. Overrides the default backup settings of your account.
    * `return_delete_token` - (boolean) Whether to return a deletion token in the upload response. The token can be used to delete the uploaded image within 10 minutes using an unauthenticated API request.
    * `faces` - (boolean) Whether to retrieve a list of coordinates of automatically detected faces in the uploaded photo. Default: false.
    * `exif` - (boolean)Whether to retrieve the Exif metadata of the uploaded photo. Default: false.
    * `colors` - (boolean) Whether to retrieve predominant colors & color histogram of the uploaded image. Default: false.
    * `image_metadata` - (boolean) Whether to retrieve IPTC and detailed Exif metadata of the uploaded photo. Default: false.
    * `phash` - (boolean) Whether to return the perceptual hash (pHash) on the uploaded image. The pHash acts as a fingerprint that allows checking image similarity. Default: false.
    * `invalidate` - (boolean) Whether to invalidate CDN cache copies of a previously uploaded image that shares the same public ID. Default: false.
    * `use_filename` - (boolean) Whether to use the original file name of the uploaded image if available for the public ID. The file name is normalized and random characters are appended to ensure uniqueness. Default: false.
    * `unique_filename` - (boolean) Only relevant if use_filename is true. When set to false, should not add random characters at the end of the filename that guarantee its uniqueness. Default: true.
    * `folder` - An optional folder name where the uploaded resource will be stored. The public ID contains the full path of the uploaded resource, including the folder name.
    * `overwrite` - (boolean) Whether to overwrite existing resources with the same public ID. When set to false, return immediately if a resource with the same public ID was found. Default: true.
    * `discard_original_filename` - (boolean) Whether to discard the name of the original uploaded file. Relevant when delivering images as attachments (setting the `flags` transformation parameter to `attachment`). Default: false.
    * `face_coordinates` - List of coordinates of faces contained in an uploaded image. The given coordinates are used for cropping uploaded images using the face or faces gravity mode. The specified coordinates override the automatically detected faces. Each face is specified by the X & Y coordinates of the top left corner and the width & height of the face. The coordinates are comma separated while faces are concatenated with `|`. For example: `10,20,150,130|213,345,82,61`.
    * `custom_coordinates` - Coordinates of an interesting region contained in an uploaded image. The given coordinates are used for cropping uploaded images using the custom gravity mode. The region is specified by the X & Y coordinates of the top left corner and the width & height of the region. For example: `85,120,220,310`.
    * `raw_convert` - Set to `aspose` to automatically convert Office documents to PDF files and other image formats using the Aspose Document Conversion add-on.
    * `auto_tagging` - (0.0..1.0) Whether to assign tags to an image according to detected scene categories with confidence score higher than the given value.
    * `background_removal` - Set to `remove_the_background` to automatically clear the background of an uploaded photo using the Remove-The-Background Editing add-on.
    * `moderation` - Set to `manual` to add the uploaded image to a queue of pending moderation images. Set to `webpurify` to automatically moderate the uploaded image using the WebPurify Image Moderation add-on.
    * `upload_preset` - Name of an upload preset that you defined for your Cloudinary account. An upload preset consists of upload parameters centrally managed using the Admin API or from the settings page of the management console. An upload preset may be marked as `unsigned`, which allows unsigned uploading directly from the browser and restrict the directly allowed parameters to: public_id, folder, tags, context, face_coordinates and custom_coordinates.
  """
  def upload_image(path, opts \\ []) do
    body = Keyword.take(opts, @upload_image_opts)
            |> Keyword.put(:file, path)
    with {:ok, response} <- Client.post("image/upload", body),
      do: decode_as(response, %UploadResponse{})
  end

  @doc "See `&upload_image/2`"
  def upload_image!(path, opts \\ []) do
    body = Keyword.take(opts, @upload_image_opts)
            |> Keyword.put(:file, path)
    Client.post!("image/upload", body)
    |> decode_as!(%UploadResponse{})
  end

  @doc """
  Delete an image from your Cloudinary library.

  ## Examples

      iex> ExCloudinary.delete_image("mlqonaj2pbelfn8sbxgz")
      response

  ## Params

    * `public_id` - The identifier of the uploaded image.
    * `type` - (optional) The type of the image you want to delete. Default: `upload`
  """
  def delete_image(public_id, type \\ "upload") do
    with {:ok, response} <- Client.post("image/destroy", [public_id: public_id, type: type]),
      do: decode_as(response, %DeleteResponse{})
  end

  @doc "See `delete_image/2`"
  def delete_image!(public_id, type \\ "upload") do
    Client.post!("image/destroy", [public_id: public_id, type: type])
    |> decode_as!(%DeleteResponse{})
  end



  @doc """
  Rename the public ID of an image in your Cloudinary library.

  ## Examples

      iex> ExCloudinary.rename_image("mlqonaj2pbelfn8sbxgz", "hw2nr1ivdsnfwotueadh")
      response

  ## Params

    * `from_public_id` - The current identifier of the uploaded image.
    * `to_public_id` - The new identifier to assign to the uploaded image.
    * `opts` - Keyword list of options (see below).

  ## Options

    * `type` - The type of the image you want to rename. Default: `upload`.
    * `overwrite` - (boolean) Whether to overwrite an existing image with the target public ID. Default: false.

  """
  def rename_image(from_public_id, to_public_id, opts \\ []) do
    body = Keyword.take(opts, [:type, :overwrite])
            |> Keyword.merge([from_public_id: from_public_id, to_public_id: to_public_id])
    with {:ok, response} <- Client.post("image/rename", body),
      do: decode_as(response, %RenameResponse{})
  end

  @doc "See `rename_image/3`"
  def rename_image!(from_public_id, to_public_id, opts \\ []) do
    body = Keyword.take(opts, [:type, :overwrite])
            |> Keyword.merge([from_public_id: from_public_id, to_public_id: to_public_id])
    Client.post!("image/rename", body)
    |> decode_as!(%RenameResponse{})
  end

  @doc """
  Upload any type of file to your Cloudinary library.

  ## Examples

      iex> ExCloudinary.upload_raw("/path/to/file")
      response

  ## Params

    * `path` - The local path to a file.
    * `public_id` - The identifier that is used for accessing the uploaded resource. A randomly generated ID is assigned if not specified.
  """
  def upload_raw(path, public_id \\ nil)
  def upload_raw(path, nil), do: do_upload_raw([file: path])
  def upload_raw(path, public_id), do: do_upload_raw([file: path, public_id: public_id])
  
  defp do_upload_raw(args) do
    with {:ok, response} <- Client.post("raw/upload", args),
      do: decode_as(response, %UploadRawResponse{})
  end

  @doc "See `upload_raw/2`"
  def upload_raw!(path, public_id \\ nil)
  def upload_raw!(path, nil), do: do_upload_raw!([file: path])
  def upload_raw!(path, public_id), do: do_upload_raw!([file: path, public_id: public_id])
  
  defp do_upload_raw!(args) do
    Client.post!("raw/upload", args)
    |> decode_as!(%UploadRawResponse{})
  end

  @doc """
  Generate an image of a given textual string.

  ## Examples

      iex> ExCloudinary.generate_text_layer("watermark")
      response

  ## Params

    * `text` - The text to generate an image for.
    * `opts` - Keyword list of options (see below).

  ## Options

    * `public_id` - The identifier that is used for accessing the generated image. If not specified, a unique identifier is generated, persistently mapped to the given text and style settings. This way, you can keep using Cloudinary’s API for generating texts. Cloudinary will make sure not to generate multiple images for the same text and style.
    * `font_family` - The name of the font family. [List of supported font families.](http://cloudinary.com/documentation/upload_images#)
    * `font_size` - Font size in points. Default: 12.
    * `font_color` - Name or RGB representation of the font's color. For example: `red`, `#ff0000`. Default: `black`.
    * `font_weight` - Whether to use a `normal` or a `bold` font. Default: `normal`.
    * `font_style` - Whether to use a `normal` or an `italic` font. Default: `normal`.
    * `background` - Name or RGB representation of the background color of the generated image. For example: `red`, `#ff0000`. Default: `transparent`.
    * `opacity` - Text opacity value between 0 (invisible) and 100. Default: 100.
    * `text_decoration` - Optionally add an `underline` to the text. Default: `none`.
  """
  def generate_text_layer(text, opts \\ []) do
    body = Keyword.take(opts, @generate_text_layer_opts)
            |> Keyword.put(:text, text)
    with {:ok, response} <- Client.post("image/text", body),
      do: decode_as(response, %GenerateTextLayerResponse{})
  end

  @doc "See `generate_text_layer/2`"
  def generate_text_layer!(text, opts \\ []) do
    body = Keyword.take(opts, @generate_text_layer_opts)
            |> Keyword.put(:text, text)
    Client.post!("image/text", body)
    |> decode_as!(%GenerateTextLayerResponse{})
  end
  
  ## Private Helpers
  
  defp decode_as(%HTTPoison.Response{body: body, status_code: 200}, as), do: Poison.decode(body, as: as)
  defp decode_as(%HTTPoison.Response{body: body, status_code: 400}, _as), do: decode_error(body)
  defp decode_as(%HTTPoison.Response{body: body, status_code: 404}, _as), do: decode_error(body)
  defp decode_as(_resp, _as), do: {:error, :unknown_cloudinary_response}
  
  defp decode_error(body) do
    with {:ok, json} <- Poison.decode(body),
      do: {:error, get_in(json, ["error", "message"])}
  end
  
  defp decode_as!(%HTTPoison.Response{body: body, status_code: 200}, as), do: Poison.decode!(body, as: as)  
  defp decode_as!(%HTTPoison.Response{body: body, status_code: 400}, _as), do: decode_error!(body)
  defp decode_as!(%HTTPoison.Response{body: body, status_code: 404}, _as), do: decode_error!(body)
  defp decode_as!(_resp, _as), do: raise "unknown cloudinary response"
  
  defp decode_error!(body) do
    body
    |> Poison.decode!
    |> get_in(["error", "message"])
    |> raise
  end 
end