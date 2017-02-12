defmodule Webclient.Router do
  use Plug.Router

  alias Webclient.Plug.VerifyRequest

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  #plug VerifyRequest, fields: ["content", "mimetype"],
  #                    paths:  ["/upload"]

  plug :match
  plug :dispatch

  	get "/", do: send_resp(conn, 200, "Welcome")
  	get "/on" do
  		# send the post to the internet device
  		resp = HTTPoison.post "https://api.particle.io/v1/devices/250046000747343232363230/led?access_token=7a6153bc703e39f361dc1a00f9afa0ec09d79520", "{\"arg\": \"on\"}", [{"Content-Type", "application/json"}]
  		case resp do
  			{:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
   			IO.inspect body
   			send_resp(conn, 200, "LED on #{body}")
   		end
   		IO.inspect resp
   		
	end
  	get "/off" do
  		# send the post to the internet device
  		HTTPoison.post "https://api.particle.io/v1/devices/250046000747343232363230/led?access_token=7a6153bc703e39f361dc1a00f9afa0ec09d79520", "{\"arg\": \"off\"}", [{"Content-Type", "application/json"}]

   		send_resp(conn, 200, "LED off")
	end
  	match _, do: send_resp(conn, 404, "Oops!")
end


