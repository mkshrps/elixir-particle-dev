defmodule Webclient.Router do
    import Plug.Conn
	use Plug.Router

  alias Webclient.Plug.VerifyRequest


#  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug Plug.Parsers, parsers: [:urlencoded, :json],
					pass: ["text/*"],
					json_decoder: Poison
					

  #plug VerifyRequest, fields: ["content", "mimetype"],
  #                    paths:  ["/upload"]

    plug Plug.Logger
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
	end
  	get "/off" do
  		# send the post to the internet device
  		HTTPoison.post "https://api.particle.io/v1/devices/250046000747343232363230/led?access_token=7a6153bc703e39f361dc1a00f9afa0ec09d79520", "{\"arg\": \"off\"}", [{"Content-Type", "application/json"}]

   		send_resp(conn, 200, "LED off")
	end

  	get "/devices" do
  		# send the post to the internet device
  		headers = ["Accept": "application/json; Charset=utf-8"]  
		url = "https://api.particle.io/v1/devices/250046000747343232363230/?access_token=7a6153bc703e39f361dc1a00f9afa0ec09d79520"
		resp = HTTPoison.get url,headers,[] 
  		case resp do
  			{:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
   			IO.inspect body
   			send_resp(conn, 200, "Device Data #{body}")
   		end
	end
   	
	post "/photon/measurements" do
  	    # IO.puts "/photon/measurements post"
        #IO.inspect conn # Prints JSON POST body
   		#{:ok,body,conn} = read_body(conn,[])
		#IO.inspect body
		%Plug.conn{body_params: body} = conn
		send_resp(conn, 200, "Posted Measurement")
	end
    
	get "/photon/measurements" do
  	    #IO.puts "/photon/measurement get"
        # IO.inspect conn.body_params # Prints JSON POST body
   		send_resp(conn, 200, "Get measurements")
	end

  	


	match _ do
		 IO.inspect conn
		 send_resp(conn, 404, "Oops!") 
	end
end


