import bluetooth
import socket
from os import system
server_address = "98:D3:31:90:12:02"
# port = get_available_port( RFCOMM )
# noinspection PyBroadException
try:
    sockBluetooth = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
    sockBluetooth.connect((server_address, 1))
except bluetooth.btcommon.BluetoothError:
    print("Bluetooth Unreachable.")
    exit()
else:
    print("connected")


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


def client(host, port, datatoserver):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect((host, port))
        print('client has been assigned socket name ', sock.getsockname())
        sock.sendall(datatoserver)
        reply = recvall(sock, 2)
        print('the server said ', repr(reply))
        sock.close()
    except:
        print("Failed to send data to server.")
        exit()


while 1:

    try:
        data = sockBluetooth.recv(1)
    except bluetooth.btcommon.BluetoothError:
        print("Bluetooth Disconnected.")
        exit()

    if data == b' ':
        print("Connection down...")

    elif data==b'A' or data==b'B' or data==b'C' or data==b'D' or data==b'E' or data==b'F' or data==b'G' or data==b'H' or data==b'I' or data==b'J' or data==b'K' or data==b'L' or data==b'M' or data==b'N' or data==b'O' or data==b'P':

        print("'" + data.decode() + "'" + " received.")
        client('127.0.0.1', 3077, data)

        if data == b'A':
            system("clementine -r")
            print(repr(data))
        elif data == b'B':
            system("clementine -t")
            print(repr(data))
        elif data == b'C':
            system("clementine -s")
            print(repr(data))
        elif data == b'D':
            system("clementine -f")
            print(repr(data))
        elif data == b'E':
            print(repr(data))
        elif data == b'F':
            print(repr(data))
        elif data == b'G':
            print(repr(data))
        elif data == b'H':
            print(repr(data))
        elif data == b'I':
            print(repr(data))
        elif data == b'J':
            print(repr(data))
        elif data == b'K':
            print(repr(data))
        elif data == b'L':
            print(repr(data))
        elif data == b'M':
            print(repr(data))
        elif data == b'N':
            print(repr(data))
        elif data == b'O':
            print(repr(data))
        elif data == b'P':
            print(repr(data))

sockBluetooth.close()
sockBluetooth = None
del sockBluetooth
