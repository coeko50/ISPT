import socket
import ssl

HOST = "192.168.24.227"  # The server's hostname or IP address
PORT = 40117  # The port used by the server
SSLPORT=10015
credentials="SVNQREM6RElSSzEyMw=="
context = ssl.create_default_context();
context.check_hostname=False
context.verify_mode=ssl.CERT_NONE
headers={'Authorization' : 'Basic ' + credentials, "Content-Type": "application/json"  }
 
#GET / HTTP/1.1\r\nHost:www.example.com\r\n\r\n
getb=b"GET /api/v1/empsql/empCoverage/SYSDEMO/0022 HTTP@/1.1\r\nHost:192.168.24.227\r\n\r\n"

#req = urllib.request.Request(upd_url, headers=headers,method="PUT")#
with socket.create_connection((HOST, SSLPORT)) as sock:
#with socket.socket(socket.AF_INET, socket.SOCK_STREAM, SSLPORT) as sock:
    with context.wrap_socket(sock, server_hostname=HOST) as ssock:
        print(ssock.version())
        ssock.sendall(getb)
        data = ssock.recv(1024)
        print(f"Received {data!r}")

print("out of it")
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    s.sendall(b"GET /api/v1/empsql/empCoverage/SYSDEMO/0023 HTTP/1.1\r\nHost:www.example.com\r\n\r\n")
    data = s.recv(1024)
    print(f"Received {data!r}")
    data = s.recv(1024)
    print(f"Received {data!r}")
    s.sendall(b"GET /emplj/query/enter?empid=1 HTTP")
    data = s.recv(1024)
    print(f"Received {data!r}")
    data = s.recv(1024)
    print(f"Received {data!r}")
#print(f"Received {data!r}