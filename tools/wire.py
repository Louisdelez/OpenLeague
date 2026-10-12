"""Decoder for the actual bounded Rust state datagrams; does not inject simulation state."""
import json,struct
frames={}
def packet(client):
 data=client.recv(65535)
 if not data.startswith(b'OLST'):return json.loads(data)
 if len(data)<28 or len(data)>1200:return None
 magic,session,tick,index,count,length=struct.unpack_from('<4sQQHHI',data)
 chunk=1172
 if not 1200<length<=1024*1024 or count!=(length+chunk-1)//chunk or index>=count:return None
 if len(data)-28!=min(chunk,length-index*chunk):return None
 previous=frames.get(client)
 if previous and previous['session']==session and previous['tick']>tick:return None
 if not previous or (previous['session'],previous['tick'])!=(session,tick):
  previous={'session':session,'tick':tick,'parts':{},'count':count,'length':length};frames[client]=previous
 previous['parts'][index]=data[28:]
 if len(previous['parts'])!=count:return None
 payload=b''.join(previous['parts'][i] for i in range(count));previous['parts']={}
 return json.loads(payload)
