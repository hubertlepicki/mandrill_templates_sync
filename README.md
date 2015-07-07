MandrillTemplatesSync
=====================

This little tool syncs templates between Mandrill accounts. We use it
for syncing templates from staging to production environments, as a
deployment hook.

You'll need Erlang and Elixir to build this app. You'll need Erlang only
to run it.

Clone the repository. Then build the tool:

    mix deps.get
    mix escript.build

This results in `mandrill_sync_templates` binary.

Usage:

    ./mandrill_templates_sync --source-key=KEY1 --destination-key=KEY2

where KEY1 and KEY2 are appropriate Mandrill API keys for source and
destination accounts.

