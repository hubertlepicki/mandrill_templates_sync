defmodule MandrillTemplatesSync.Cli do
  alias MandrillTemplatesSync.Publisher
  alias MandrillTemplatesSync.TemplatesList
  alias MandrillTemplatesSync.AccountTemplatesDuplicator

  def run(argv) do
    argv
      |> parse_args
      |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean ],
                                     aliases: [ h: :help ])
    case parse do
      { [help: true], _, _ } -> :help
      { [ source_key: source, destination_key: dest ], _, _ } -> [ source, dest ]
      { [ account_key: key, from_env: from, to_env: to ], _, _ } -> [ key, from, to ]
      _                      -> :help
    end
  end

  def process(:help) do
    IO.puts """
    Usage: mandrill_template_sync --souce-key=<KEY1> --destination_key=<KEY2>
       or: mandrill_template_sync --account-key=<KEY> --from-env=<ENV1> --to-env=<ENV2>

    Examples:
      Copy all templates from source to destination account:
        mandrill_templates_sync --source-key=KEY1 --destination-key=KEY2

      Duplicate templates postfixed by "[staging]" and change postfix to "[production]" within one account:
        mandrill_templates_sync --account-key=KEY --from-env=staging --to-env=production
    """
  end

  def process([source_key, destination_key]) do
    TemplatesList.fetch(source_key)
      |> Publisher.publish(destination_key)
  end

  def process([key, from, to]) do
    AccountTemplatesDuplicator.duplicate(key, from, to)
  end
end
