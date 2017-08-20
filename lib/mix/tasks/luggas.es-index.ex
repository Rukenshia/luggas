defmodule Mix.Tasks.Luggas.EsIndex do
    use Mix.Task

    require Logger

    def run(_) do
      Logger.info "starting elastix"
      Elastix.start()

      Logger.info "creating index"
      {:ok, _} = Elastix.Index.create("http://127.0.0.1:9200", "luggas", %{})
      Logger.info "created index 'luggas'"


      Logger.info "creating mapping for 'webhook'"
      user = %{
        properties: %{
          id: %{type: "long"},
          first_name: %{type: "text"},
          last_name: %{type: "text"},
          username: %{type: "text"},
          language_code: %{type: "text"},
        },
      }

      chat = %{
        properties: %{
          id: %{type: "long"},
          type: %{type: "text"},
          title: %{type: "text"},
          username: %{type: "text"},
          first_name: %{type: "text"},
          last_name: %{type: "text"},
          description: %{type: "text"},
        },
      }

      message = %{
        properties: %{
          message_id: %{type: "long"},
          date: %{type: "long"},
          forward_from_message_id: %{type: "long"},
          forward_date: %{type: "long"},
          caption: %{type: "text"},
          new_chat_title: %{type: "text"},
          supergroup_chat_created: %{type: "boolean"},
          edit_date: %{type: "long"},
          text: %{type: "text"},from: user,
          chat: chat,
          forward_from: user,
          forward_from_chat: chat,
          reply_to_message: %{
            properties: %{
              message_id: %{type: "long"},
              text: %{type: "text"},
              from: user,
            },
          },
          audio: %{
            properties: %{
              file_id: %{type: "text"},
              title: %{type: "text"},
            },
          },
          photo: %{
            properties: %{
              file_id: %{type: "text"},
            },
          },
          document: %{
            properties: %{
              file_id: %{type: "text"},
              title: %{type: "text"},
            },
          },
          video: %{
            properties: %{
              file_id: %{type: "text"},
            },
          },
          video_note: %{
            properties: %{
              file_id: %{type: "text"},
            },
          },
          new_chat_members: user,
          new_chat_member: user,
          left_chat_member: user,
        },
      }

      mapping = %{
        properties: %{
          update_id: %{type: "text"},
          message: message,
          edited_message: message,
          channel_post: message,
          edited_channel_post: message,
        },
      }

      {:ok, res} = Elastix.Mapping.put("http://127.0.0.1:9200", "luggas", "webhook", mapping)
      if res.status_code != 200 do
        IO.inspect res
        Logger.error "could not create mapping"
      else
        Logger.info "created mapping for 'webhook'"
      end

    end
end