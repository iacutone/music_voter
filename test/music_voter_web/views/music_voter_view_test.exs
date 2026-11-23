defmodule MusicVoterWeb.MusicVoterViewTest do
  use ExUnit.Case, async: true

  import Phoenix.HTML, only: [safe_to_string: 1]
  alias MusicVoterWeb.MusicVoterView

  defp html(songs, vid), do: songs |> MusicVoterView.render_controls(vid) |> safe_to_string()

  test "playing with multiple songs shows previous, stop and next with handler event names" do
    out = html([1, 2], "abc")

    assert out =~ ~s(phx-click="previous")
    assert out =~ ~s(phx-click="stop")
    assert out =~ ~s(phx-click="next")
    refute out =~ ~s(phx-click="Previous")
  end

  test "stopped with songs shows play" do
    assert html([1], nil) =~ ~s(phx-click="play")
  end
end
