import argparse
import socket

def recvall(sock, length):
    datarecieve = b''
    while len(datarecieve) < length:
        more = sock.recv(length - len(datarecieve))
        if not more:
            raise EOFError('was expecting %d'
                           'bytes but only received'
                           '%d bytes before the socket closed'
                           % (length, len(datarecieve)))
        datarecieve += more
    return datarecieve

def server(interface, port):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind((interface, port))
        sock.listen(1)
        print('Listening at', sock.getsockname())
        while True:
            sc, sockname = sock.accept()
            print('we have accepted a connection from', sockname)
            print(' Socket name :', sc.getsockname())
            print(' socket peer:', sc.getpeername())
            message = recvall(sc, 1)
            print(' incoming message:', repr(message))
            try:
                 keypadNum = open("/var/www/html/keypadNum.txt", "w")
                 keypadNum.write(message.decode())
                 keypadNum.close()
            except:
                print("Failed to open file.")
                exit()
            sc.sendall(b'AK')
            sc.close()
            print(' reply sent, socket closed')


if __name__ == '__main__':
    choices = {'server': server}
    parser = argparse.ArgumentParser(description='receive over tcp')
    parser.add_argument('role', choices=choices, help='which role to play')
    parser.add_argument('host', help='interface the server listens at;'
                        'host the client sends to')
    parser.add_argument('-p', metavar='PORT', type=int, default=3077,
                        help='TCP port(defaults 3077)')
    args = parser.parse_args()
    function = choices[args.role]
    function(args.host, args.p)
