defmodule MandrillTemplatesSync.Template do
  defstruct [ :name, :publish_code, :publish_subject, :labels,
              :publish_from_email, :publish_from_name, :publish_text
  ]
end
