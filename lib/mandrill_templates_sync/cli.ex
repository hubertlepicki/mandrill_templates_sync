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
    IO.puts "Usage: mandrill_templates_sync --source-key=KEY1 --destination-key=KEY2"
  end

  def process([source_key, destination_key]) do
    TemplatesList.fetch(source_key)
      |> Publisher.publish(destination_key)
  end

  def process([key, from, to]) do
    AccountTemplatesDuplicator.duplicate(key, from, to)
  end
end
