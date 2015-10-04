import socket

UDP_IP = "192.168.1.23"
UDP_PORT = 7536

sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))

while True:
    data, addr = sock.recvfrom(268) # buffer size is 16*1024 bytes
    print "received message:", data
