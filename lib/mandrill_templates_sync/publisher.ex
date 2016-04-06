defmodule MandrillTemplatesSync.Publisher do
  @api_endpoint "https://mandrillapp.com/api/1.0/"


  def publish(templates, key) do
    templates
      |> Enum.each( &(publish_template(&1, key)) )
  end

  defp publish_template(template, key) do
    success = handle_response(HTTPoison.post(add_url, encode(template, key))) or
      handle_response(HTTPoison.post(update_url, encode(template, key)))

    if success do
      IO.puts "Template synced successfully: #{template.name}"
    else
      IO.puts "Error while syncing template: #{template.name}"
      IO.puts "Is your destination API key valid?"
    end
  end

  defp encode(template, key) do
    to_add = %{
      key: key,
      name: template.name,
      from_email: template.publish_from_email,
      from_name: template.publish_from_name,
      subject: template.publish_subject,
      code: template.publish_code,
      text: template.publish_text,
      labels: template.labels,
      publish: true
    }

    Poison.Encoder.encode to_add, %{}
  end

  defp add_url do
    "#{@api_endpoint}/templates/add.json"
  end

  defp update_url do
    "#{@api_endpoint}/templates/update.json"
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: _}}) do
    true
  end

  defp handle_response({_, _}) do
    false
  end
end

