import socket,select,threading,time,json
class BatchProxy:
 def __init__(self):
  self.front=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);self.front.bind(('127.0.0.1',10502))
  self.back=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);self.back.connect(('127.0.0.1',10501))
  self.welcomes={};self.peer=None;self.pending=[];self.hold_until=0.;self.done=threading.Event();self.error=None;self.batches=[]
  self.thread=threading.Thread(target=self.run,daemon=True);self.thread.start()
 def hold(self,seconds):self.hold_until=time.monotonic()+seconds
 def run(self):
  try:
   while not self.done.is_set():
    for sock in select.select([self.front,self.back],[],[],.002)[0]:
     if sock is self.front:
      data,self.peer=self.front.recvfrom(65535);self.back.send(data)
     else:
      data=self.back.recv(65535)
      if not data.startswith(b'OLST'):
       try:
        welcome=json.loads(data).get('Welcome')
        if welcome:self.welcomes[welcome['session']]=data
       except (ValueError,AttributeError):pass
      if self.peer:
       if time.monotonic()<self.hold_until:self.pending.append(data)
       else:
        if self.pending:
         self.batches.append({'datagrams':len(self.pending),'released_at':time.monotonic()})
         for packet in self.pending:self.front.sendto(packet,self.peer)
         self.pending.clear()
        self.front.sendto(data,self.peer)
  except Exception as error:self.error=repr(error)
 def close(self):
  self.done.set();self.thread.join(2);self.front.close();self.back.close()
