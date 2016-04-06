defmodule MandrillTemplatesSync.AccountTemplatesDuplicator do
  alias MandrillTemplatesSync.TemplatesList
  alias MandrillTemplatesSync.Publisher

  def duplicate(key, from, to) do
    templates_for_env(from, key)
      |> rename_templates(from, to)
      |> amend_label(from, to)
      |> publish(key)
  end

  defp templates_for_env(env, key) do
    TemplatesList.fetch_for_env(env, key)
  end

  defp rename_templates(templates, from_env, to_env) do
    Enum.map(templates, &(rename_template(&1, from_env, to_env)))
  end

  defp rename_template(template, from_env, to_env) do
    %{ template | 
      name: String.replace_suffix(template.name, "[#{from_env}]", "[#{to_env}]") }
  end

  defp amend_label(templates, from, to) do
    templates
      |> Stream.map(fn template -> update_in(template.labels, &List.delete(&1, from)) end)
      |> Stream.map(fn template -> update_in(template.labels, &([to|&1])) end)
  end

  defp publish(templates, key) do
    Publisher.publish(templates, key)
  end
end
