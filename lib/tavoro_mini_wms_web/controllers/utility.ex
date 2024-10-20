# Unfortunately, I had to full specify the function calls - could import or user properly.

defmodule TavoroMiniWms.Utility do
  import Plug.Conn
  import Phoenix.Controller

  def handle_error(conn, error_msg) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: error_msg})
  end
end
