#!/usr/bin/env python
import bluetooth
import socket
from os import system
from termcolor import colored
server_address = "98:D3:31:90:12:02"
# port = get_available_port( RFCOMM )
# noinspection PyBroadException
try:
    try:
        sockBluetooth = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
        sockBluetooth.connect((server_address, 1))
    except bluetooth.btcommon.BluetoothError:
        print(colored("Bluetooth Unreachable.",'red'))
        exit(1)
    else:
        print(colored("Bluetooth connected",'green'))


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
            print(colored("Failed to send data to server.",'red'))
            pass
        else:
            print(colored("Send data to server finished.",'green'))

    while 1:

        try:
            data = sockBluetooth.recv(1)
        except bluetooth.btcommon.BluetoothError:
            print(colored("Bluetooth Disconnected.",'red'))
            exit(1)
        else:
            print(colored(repr(data)[1:]+" recieved.",'green'))

        if data == b' ':
            print(colored("Connection down...",'red'))

        elif data==b'A' or data==b'B' or data==b'C' or data==b'D' or \
        data==b'E' or data==b'F' or data==b'G' or data==b'H' or \
        data==b'I' or data==b'J' or data==b'K' or data==b'L' or \
        data==b'M' or data==b'N' or data==b'O' or data==b'P':

            client('127.0.0.1', 3077, data)

            if data == b'A':
                system("clementine -r")
            elif data == b'B':
                system("clementine -t")
            elif data == b'C':
                system("clementine -s")
            elif data == b'D':
                system("clementine -f")
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
except KeyboardInterrupt as err:
    print(colored("Program exited as per user's request.",'green'))
except Exception as err:
    print(colored("An unexpected error happened: "+str(err),'red'))
    exit(1)