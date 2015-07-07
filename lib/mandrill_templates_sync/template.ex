defmodule MandrillTemplatesSync.Template do
  defstruct [ :name, :publish_code, :publish_subject,
              :publish_from_email, :publish_from_name, :publish_text
  ]
end
