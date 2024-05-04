import socket

def send_tcp(ip, port):
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((ip, port))
        while True:
            data = b"Test TCP!" * 1024
            s.send(data)
    except Exception as e:
        print("Error:", e)
    finally:
        s.close()

if __name__ == "__main__":
    # 目标IP地址，默认德国
    target_ip = "88.198.248.254"  # 美国:135.148.100.133 香港:43.249.36.49
    target_port = 80
    send_tcp(target_ip, target_port)
