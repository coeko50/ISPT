import socket

HOST = "192.168.24.227"  # The server's hostname or IP address
PORT = 40117  # The port used by the server


#sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#sock.connect((HOST,PORT))
#sock.send(b"GET /emplj/query HTTP/1.1\r\nHost:www.example.com\r\n\r\n")
#response = sock.recv(4096)
#sock.close()
#print(response.decode())


with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    print("Dialog Premap - send:GET /emplj/query HTTP")
    s.sendall(b"GET /emplj/query HTTP/1.1\r\nHost:www.example.com\r\n\r\n")
    data = s.recv(4096)
    print(f"Received {data!r}")
    data = s.recv(4096)
    print(f"Received {data!r}")
    print("dialog send Enter response  send:GET /emplj/query/enter?empid=1 HTTP")
    s.sendall(b"GET /emplj/query/enter?empid=1 HTTP")
    data = s.recv(4096)
    print(f"Received {data!r}")
    data = s.recv(1024)
    print(data.decode())
    print("send Clear send:GET /emplj/query/clear HTTP")
    s.sendall(b"GET /emplj/query/clear HTTP")
    data = s.recv(1024)
    print(f"Received {data!r}")
#print(f"Received {data!r}")