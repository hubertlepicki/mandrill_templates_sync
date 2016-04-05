defmodule MandrillTemplatesSync.AccountTemplatesDuplicator do
  def duplicate(key, from, to) do
    templates_with_postfix(from, key)
      |> rename_templates(from, to)
      |> publish(key)
  end

  defp templates_with_postfix(postfix, key) do
    TemplatesList.fetch_with_postfix(postfix, key)
  end

  defp rename_templates(templates, from_postfix, to_postfix) do
    Enum.map(templates, &(rename_template(&1, from_postfix, to_postfix)))
  end

  defp rename_template(template, from_postfix, to_postfix) do
    %{ template | 
      name: String.replace_suffix(template.name, from_postfix, to_postfix) }
  end

  defp publish(templates, key) do
    Publisher.publish(templates, key)
  end
end
