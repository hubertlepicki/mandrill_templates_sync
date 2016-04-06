defmodule MandrillTemplatesSync.TemplatesList do
  alias MandrillTemplatesSync.Template
  @api_endpoint "https://mandrillapp.com/api/1.0/"


  def fetch(key) do
    list_url(key)
      |> HTTPoison.get()
      |> handle_response()
  end

  def fetch_for_env(env, key) do
    fetch(key)
      |> select_for_env(env)
  end

  defp select_for_env(templates, env) do
    Enum.filter(templates, &String.ends_with?(&1.name, "[#{env}]"))
  end

  defp list_url(key) do
    "#{@api_endpoint}/templates/list.json?key=#{key}"
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Poison.decode!(body, as: [Template])
  end

  defp handle_response({:ok, _}) do
    IO.puts "Error fetching list of templates from Mandrill. Possible reasons:"
    IO.puts "- Mandrill API is down (check http://status.mandrillapp.com)"
    IO.puts "- Your Internet connection is down"
    IO.puts "- The key you passed is invalid"

    System.halt(2)
  end
end

