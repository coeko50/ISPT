import http.client

def main():
    # Send an HTTP GET request to a server
    host = "192.168.24.227"
    port = 40117
    get_url = "http://192.168.24.227:40117/emplj/query"
    get_url2 = "https://192.168.24.227:10015/emplj/query"
    
    conn = http.client.HTTPConnection(host,port,timeout=3)
    print("connected")
    conn.request("GET", "/emplj/query")
    response = conn.getresponse()
    print(response.status, response.reason)
    data1 = response.read()
    print(data1)
    conn.request("GET", "/emplj/query?emplid=31")
    response = conn.getresponse()
    print(response.status, response.reason)
    print(response.read())
    conn.close();
    
    
def resp(url ):    	
    response = requests.get(get_url2)

    # Print the HTTP response status
    print(f"Response status: {response.status_code} {response.reason}")

    # Print the first 5 lines of the response body
    lines = response.text.splitlines()
    for line in lines[:5]:
        print(line)

if __name__ == "__main__":
    main()