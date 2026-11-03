package mx.messaging.channels
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.net.ObjectEncoding;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLStream;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.Channel;
   import mx.messaging.FlexClient;
   import mx.messaging.events.MessageEvent;
   import mx.messaging.messages.AbstractMessage;
   import mx.messaging.messages.AcknowledgeMessage;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.IMessage;
   
   [Event(name="status",type="flash.events.StatusEvent")]
   public class StreamingConnectionHandler extends EventDispatcher
   {
      
      public static const DISCONNECT_CODE:String = "disconnect";
      
      private static const COMMAND_PARAM_NAME:String = "command";
      
      private static const OPEN_COMMAND:String = "open";
      
      private static const CLOSE_COMMAND:String = "close";
      
      private static const STREAM_ID_PARAM_NAME:String = "streamId";
      
      private static const VERSION_PARAM_NAME:String = "version";
      
      private static const VERSION_1:String = "1";
      
      private static const CR_BYTE:int = 13;
      
      private static const LF_BYTE:int = 10;
      
      private static const NULL_BYTE:int = 0;
      
      private static const INIT_STATE:int = 0;
      
      private static const CR_STATE:int = 1;
      
      private static const LF_STATE:int = 2;
      
      private static const SIZE_STATE:int = 3;
      
      private static const TEST_CHUNK_STATE:int = 4;
      
      private static const SKIP_STATE:int = 5;
      
      private static const DATA_STATE:int = 6;
      
      private static const RESET_BUFFER_STATE:int = 7;
      
      private static const CLOSED_STATE:int = 8;
      
      protected var channel:Channel;
      
      protected var chunkBuffer:ByteArray;
      
      protected var dataBytesToRead:int = -1;
      
      protected var dataOffset:int;
      
      protected var _log:ILogger;
      
      protected var streamId:String;
      
      private var _appendToURL:String;
      
      private var hexChunkSize:String;
      
      private var state:int = 0;
      
      private var streamingConnection:URLStream;
      
      private var streamingConnectionCloser:URLStream;
      
      public function StreamingConnectionHandler(channel:Channel, log:ILogger)
      {
         super();
         this.channel = channel;
         this._log = log;
      }
      
      public function openStreamingConnection(appendToURL:String = null) : void
      {
         var request:URLRequest = null;
         var url:String = null;
         var postParams:URLVariables = null;
         this.state = INIT_STATE;
         this._appendToURL = appendToURL;
         if(this.streamingConnection == null)
         {
            this.streamingConnection = new URLStream();
            this.streamingConnection.addEventListener(Event.OPEN,this.streamOpenHandler);
            this.streamingConnection.addEventListener(ProgressEvent.PROGRESS,this.streamProgressHandler);
            this.streamingConnection.addEventListener(Event.COMPLETE,this.streamCompleteHandler);
            this.streamingConnection.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.streamHttpStatusHandler);
            this.streamingConnection.addEventListener(IOErrorEvent.IO_ERROR,this.streamIoErrorHandler);
            this.streamingConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.streamSecurityErrorHandler);
         }
         if(!this.streamingConnection.connected)
         {
            request = new URLRequest();
            url = this.channel.endpoint;
            if(url.charAt(url.length - 1) == "/")
            {
               url = url.substring(0,url.length - 1);
            }
            if(this._appendToURL != null)
            {
               url += this._appendToURL;
            }
            request.url = url + "?" + COMMAND_PARAM_NAME + "=" + OPEN_COMMAND + "&" + VERSION_PARAM_NAME + "=" + VERSION_1;
            request.method = URLRequestMethod.POST;
            postParams = new URLVariables();
            postParams[AbstractMessage.FLEX_CLIENT_ID_HEADER] = FlexClient.getInstance().id;
            request.data = postParams;
            this.streamingConnection.load(request);
         }
      }
      
      public function closeStreamingConnection() : void
      {
         var process:Function = null;
         var ignore:Function = null;
         var request:URLRequest = null;
         var url:String = null;
         var postParams:URLVariables = null;
         this.state = CLOSED_STATE;
         this.chunkBuffer = null;
         this.hexChunkSize = null;
         this.dataBytesToRead = -1;
         this.dataOffset = 0;
         if(this.streamingConnection != null)
         {
            if(this.streamingConnection.connected)
            {
               try
               {
                  this.streamingConnection.close();
               }
               catch(ignore:Error)
               {
               }
            }
         }
         if(this.streamId != null)
         {
            if(this.streamingConnectionCloser == null)
            {
               process = function(event:Event):void
               {
                  if(streamingConnectionCloser.connected)
                  {
                     try
                     {
                        streamId = null;
                        streamingConnectionCloser.close();
                     }
                     catch(ignore:Error)
                     {
                     }
                  }
               };
               ignore = function(event:Event):void
               {
               };
               this.streamingConnectionCloser = new URLStream();
               this.streamingConnectionCloser.addEventListener(Event.COMPLETE,process);
               this.streamingConnectionCloser.addEventListener(IOErrorEvent.IO_ERROR,process);
               this.streamingConnectionCloser.addEventListener(HTTPStatusEvent.HTTP_STATUS,ignore);
               this.streamingConnectionCloser.addEventListener(SecurityErrorEvent.SECURITY_ERROR,ignore);
            }
            if(!this.streamingConnectionCloser.connected)
            {
               request = new URLRequest();
               url = this.channel.endpoint;
               if(this._appendToURL != null)
               {
                  url += this._appendToURL;
               }
               request.url = url + "?" + COMMAND_PARAM_NAME + "=" + CLOSE_COMMAND + "&" + STREAM_ID_PARAM_NAME + "=" + this.streamId + "&" + VERSION_PARAM_NAME + "=" + VERSION_1;
               request.method = URLRequestMethod.POST;
               postParams = new URLVariables();
               postParams[AbstractMessage.FLEX_CLIENT_ID_HEADER] = FlexClient.getInstance().id;
               request.data = postParams;
               this.streamingConnectionCloser.load(request);
            }
         }
      }
      
      protected function readMessage() : IMessage
      {
         return null;
      }
      
      private function streamCompleteHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      private function streamHttpStatusHandler(event:HTTPStatusEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function streamIoErrorHandler(event:IOErrorEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function streamOpenHandler(event:Event) : void
      {
      }
      
      private function streamProgressHandler(event:ProgressEvent) : void
      {
         var value:int = 0;
         var message:IMessage = null;
         var openEvent:Event = null;
         var statusEvent:StatusEvent = null;
         var j:int = 0;
         var tempBuffer:ByteArray = null;
         var x:int = 0;
         if(this.chunkBuffer == null)
         {
            this.chunkBuffer = new ByteArray();
            this.chunkBuffer.objectEncoding = ObjectEncoding.AMF3;
         }
         var n:int = int(this.streamingConnection.bytesAvailable);
         if(n > 0)
         {
            this.streamingConnection.readBytes(this.chunkBuffer,this.chunkBuffer.length,n);
            while(this.chunkBuffer.bytesAvailable > 0)
            {
               if(this.state == INIT_STATE)
               {
                  value = this.chunkBuffer.readByte();
                  if(value == NULL_BYTE)
                  {
                     continue;
                  }
                  this.dataBytesToRead = -1;
                  this.hexChunkSize = "";
                  --this.chunkBuffer.position;
                  this.state = CR_STATE;
               }
               if(this.state == CR_STATE)
               {
                  value = this.chunkBuffer.readByte();
                  if(value == CR_BYTE)
                  {
                     this.state = LF_STATE;
                  }
                  else
                  {
                     --this.chunkBuffer.position;
                     value = this.chunkBuffer.readByte();
                     if(value == LF_BYTE)
                     {
                        this.state = this.dataBytesToRead == -1 ? SIZE_STATE : TEST_CHUNK_STATE;
                     }
                     else
                     {
                        --this.chunkBuffer.position;
                        this.state = SIZE_STATE;
                     }
                  }
                  if(this.chunkBuffer.bytesAvailable == 0)
                  {
                     break;
                  }
               }
               if(this.state == LF_STATE)
               {
                  value = this.chunkBuffer.readByte();
                  if(value == LF_BYTE)
                  {
                     this.state = this.dataBytesToRead == -1 ? SIZE_STATE : TEST_CHUNK_STATE;
                  }
                  if(this.chunkBuffer.bytesAvailable == 0)
                  {
                     break;
                  }
               }
               if(this.state == SIZE_STATE)
               {
                  value = this.chunkBuffer.readByte();
                  if(value == NULL_BYTE)
                  {
                     continue;
                  }
                  if(value == CR_BYTE)
                  {
                     this.dataBytesToRead = parseInt(this.hexChunkSize,16);
                     this.state = LF_STATE;
                  }
                  else
                  {
                     this.hexChunkSize += String.fromCharCode(value);
                  }
                  if(this.chunkBuffer.bytesAvailable == 0)
                  {
                     break;
                  }
               }
               if(this.state == TEST_CHUNK_STATE)
               {
                  value = this.chunkBuffer.readByte();
                  this.dataOffset = this.chunkBuffer.position;
                  this.state = value == NULL_BYTE ? SKIP_STATE : DATA_STATE;
                  --this.chunkBuffer.position;
                  if(this.chunkBuffer.bytesAvailable == 0)
                  {
                     break;
                  }
               }
               if(this.state == SKIP_STATE)
               {
                  if(this.chunkBuffer.bytesAvailable < this.dataBytesToRead)
                  {
                     break;
                  }
                  this.chunkBuffer.position += this.dataBytesToRead;
                  this.state = RESET_BUFFER_STATE;
               }
               if(this.state == DATA_STATE)
               {
                  if(this.chunkBuffer.bytesAvailable < this.dataBytesToRead)
                  {
                     break;
                  }
                  message = this.readMessage();
                  if(message != null)
                  {
                     if(Log.isDebug())
                     {
                        this._log.debug("\'{0}\' channel got message\n{1}\n",this.channel.id,message.toString());
                     }
                     if(message is AcknowledgeMessage && AcknowledgeMessage(message).correlationId == OPEN_COMMAND)
                     {
                        this.streamId = String(message.body);
                        openEvent = new Event(Event.OPEN);
                        dispatchEvent(openEvent);
                     }
                     else
                     {
                        if(message is CommandMessage && CommandMessage(message).operation == CommandMessage.DISCONNECT_OPERATION)
                        {
                           statusEvent = new StatusEvent(StatusEvent.STATUS,false,false,DISCONNECT_CODE,"status");
                           dispatchEvent(statusEvent);
                           return;
                        }
                        this.channel.dispatchEvent(MessageEvent.createEvent(MessageEvent.MESSAGE,message));
                     }
                     if(this.state == CLOSED_STATE)
                     {
                        return;
                     }
                  }
                  this.state = RESET_BUFFER_STATE;
               }
               if(this.state == RESET_BUFFER_STATE)
               {
                  if(this.chunkBuffer.bytesAvailable > 0)
                  {
                     for(j = 0; j < this.chunkBuffer.bytesAvailable; j++)
                     {
                        x = int(this.chunkBuffer[j]);
                     }
                     tempBuffer = new ByteArray();
                     tempBuffer.objectEncoding = ObjectEncoding.AMF3;
                     this.chunkBuffer.readBytes(tempBuffer,0,this.chunkBuffer.bytesAvailable);
                     this.chunkBuffer = tempBuffer;
                  }
                  else
                  {
                     this.chunkBuffer = new ByteArray();
                     this.chunkBuffer.objectEncoding = ObjectEncoding.AMF3;
                  }
                  this.state = INIT_STATE;
                  if(this.chunkBuffer.bytesAvailable == 0)
                  {
                     break;
                  }
               }
               if(this.state == CLOSED_STATE)
               {
                  return;
               }
            }
         }
      }
      
      private function streamSecurityErrorHandler(event:SecurityErrorEvent) : void
      {
         dispatchEvent(event);
      }
   }
}

