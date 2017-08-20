defmodule Luggas.Application do
    use Application

    def start(_type, _args) do
      import Supervisor.Spec, warn: false

      children = [
        worker(Luggas, []),
      ]

      opts = [strategy: :one_for_one, name: Post.Supervisor]
      Supervisor.start_link(children, opts)
    end
  end
