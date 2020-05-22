defmodule MusicVoterWeb.MusicVoterView do
  use MusicVoterWeb, :view

  def render_controls(songs, vid) do
    content_tag(:footer, id: "controls", "data-vid": vid) do
      previous_button = 
        if Enum.count(songs) > 1 do
          [content_tag(:button, "phx-click": "Previous", "phx-value":  vid) do
            "Previous"
          end]
        end

      play_button = 
        if Enum.count(songs) > 0 && !vid do
          [content_tag(:button, "phx-click": "play") do
            "Play"
          end]
        end

      stop_button = 
        if Enum.count(songs) > 0 && vid do
          [content_tag(:button, "phx-click": "stop") do
            "Stop"
          end]
        end

      next_button = if Enum.count(songs) > 1 do
        [content_tag(:button, "phx-click": "next", "phx-value": vid) do
          "Next"
        end]
      end

      Enum.filter([previous_button, play_button, stop_button, next_button], & !is_nil(&1))
    end
  end
end
