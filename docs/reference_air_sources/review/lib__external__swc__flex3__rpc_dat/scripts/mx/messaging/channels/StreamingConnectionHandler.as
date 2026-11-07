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
      
      private static const HEX_DIGITS:Object = {
         "48":"0",
         "49":"1",
         "50":"2",
         "51":"3",
         "52":"4",
         "53":"5",
         "54":"6",
         "55":"7",
         "56":"8",
         "57":"9",
         "65":"a",
         "97":"a",
         "66":"b",
         "98":"b",
         "67":"c",
         "99":"c",
         "68":"d",
         "100":"d",
         "69":"e",
         "101":"e",
         "70":"f",
         "102":"f"
      };
      
      private static const HEX_VALUES:Object = {
         "0":0,
         "1":1,
         "2":2,
         "3":3,
         "4":4,
         "5":5,
         "6":6,
         "7":7,
         "8":8,
         "9":9,
         "a":10,
         "b":11,
         "c":12,
         "d":13,
         "e":14,
         "f":15
      };
      
      private static const INIT_STATE:int = 0;
      
      private static const CR_STATE:int = 1;
      
      private static const LF_STATE:int = 2;
      
      private static const SIZE_STATE:int = 3;
      
      private static const TEST_CHUNK_STATE:int = 4;
      
      private static const SKIP_STATE:int = 5;
      
      private static const DATA_STATE:int = 6;
      
      private static const RESET_BUFFER_STATE:int = 7;
      
      private static const CLOSED_STATE:int = 8;
      
      protected var streamId:String;
      
      protected var channel:Channel;
      
      protected var _log:ILogger;
      
      private var streamingConnectionCloser:URLStream;
      
      protected var chunkBuffer:ByteArray;
      
      private var state:int = 0;
      
      protected var dataOffset:int;
      
      private var streamingConnection:URLStream;
      
      protected var dataBytesToRead:int = -1;
      
      private var hexChunkSize:String;
      
      private var _appendToURL:String;
      
      public function StreamingConnectionHandler(channel:Channel, log:ILogger)
      {
         super();
         this.channel = channel;
         this._log = log;
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
         if(chunkBuffer == null)
         {
            chunkBuffer = new ByteArray();
            chunkBuffer.objectEncoding = ObjectEncoding.AMF3;
         }
         var n:int = int(streamingConnection.bytesAvailable);
         if(n > 0)
         {
            streamingConnection.readBytes(chunkBuffer,chunkBuffer.length,n);
            while(chunkBuffer.bytesAvailable > 0)
            {
               if(state == INIT_STATE)
               {
                  value = chunkBuffer.readByte();
                  if(value == NULL_BYTE)
                  {
                     continue;
                  }
                  dataBytesToRead = -1;
                  hexChunkSize = "";
                  --chunkBuffer.position;
                  state = CR_STATE;
               }
               if(state == CR_STATE)
               {
                  value = chunkBuffer.readByte();
                  if(value == CR_BYTE)
                  {
                     state = LF_STATE;
                  }
                  else
                  {
                     --chunkBuffer.position;
                     value = chunkBuffer.readByte();
                     if(value == LF_BYTE)
                     {
                        state = dataBytesToRead == -1 ? SIZE_STATE : TEST_CHUNK_STATE;
                     }
                     else
                     {
                        --chunkBuffer.position;
                        state = SIZE_STATE;
                     }
                  }
                  if(chunkBuffer.bytesAvailable == 0)
                  {
                     break;
                  }
               }
               if(state == LF_STATE)
               {
                  value = chunkBuffer.readByte();
                  if(value == LF_BYTE)
                  {
                     state = dataBytesToRead == -1 ? SIZE_STATE : TEST_CHUNK_STATE;
                  }
                  if(chunkBuffer.bytesAvailable == 0)
                  {
                     break;
                  }
               }
               if(state == SIZE_STATE)
               {
                  value = chunkBuffer.readByte();
                  if(value == NULL_BYTE)
                  {
                     continue;
                  }
                  if(value == CR_BYTE)
                  {
                     dataBytesToRead = convertHexToDecimal(hexChunkSize);
                     state = LF_STATE;
                  }
                  else
                  {
                     hexChunkSize += HEX_DIGITS[value];
                  }
                  if(chunkBuffer.bytesAvailable == 0)
                  {
                     break;
                  }
               }
               if(state == TEST_CHUNK_STATE)
               {
                  value = chunkBuffer.readByte();
                  dataOffset = chunkBuffer.position;
                  state = value == NULL_BYTE ? SKIP_STATE : DATA_STATE;
                  --chunkBuffer.position;
                  if(chunkBuffer.bytesAvailable == 0)
                  {
                     break;
                  }
               }
               if(state == SKIP_STATE)
               {
                  if(chunkBuffer.bytesAvailable < dataBytesToRead)
                  {
                     break;
                  }
                  chunkBuffer.position += dataBytesToRead;
                  state = RESET_BUFFER_STATE;
               }
               if(state == DATA_STATE)
               {
                  if(chunkBuffer.bytesAvailable < dataBytesToRead)
                  {
                     break;
                  }
                  message = readMessage();
                  if(message != null)
                  {
                     if(Log.isDebug())
                     {
                        _log.debug("\'{0}\' channel got message\n{1}\n",channel.id,message.toString());
                     }
                     if(message is AcknowledgeMessage && AcknowledgeMessage(message).correlationId == OPEN_COMMAND)
                     {
                        streamId = String(message.body);
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
                        channel.dispatchEvent(MessageEvent.createEvent(MessageEvent.MESSAGE,message));
                     }
                     if(state == CLOSED_STATE)
                     {
                        return;
                     }
                  }
                  state = RESET_BUFFER_STATE;
               }
               if(state == RESET_BUFFER_STATE)
               {
                  if(chunkBuffer.bytesAvailable > 0)
                  {
                     for(j = 0; j < chunkBuffer.bytesAvailable; j++)
                     {
                        x = int(chunkBuffer[j]);
                     }
                     tempBuffer = new ByteArray();
                     tempBuffer.objectEncoding = ObjectEncoding.AMF3;
                     chunkBuffer.readBytes(tempBuffer,0,chunkBuffer.bytesAvailable);
                     chunkBuffer = tempBuffer;
                  }
                  else
                  {
                     chunkBuffer = new ByteArray();
                     chunkBuffer.objectEncoding = ObjectEncoding.AMF3;
                  }
                  state = INIT_STATE;
                  if(chunkBuffer.bytesAvailable == 0)
                  {
                     break;
                  }
               }
               if(state == CLOSED_STATE)
               {
                  return;
               }
            }
         }
      }
      
      private function streamOpenHandler(event:Event) : void
      {
      }
      
      public function closeStreamingConnection() : void
      {
         var process:Function = null;
         var ignore:Function = null;
         var request:URLRequest = null;
         var url:String = null;
         var postParams:URLVariables = null;
         state = CLOSED_STATE;
         chunkBuffer = null;
         hexChunkSize = null;
         dataBytesToRead = -1;
         dataOffset = 0;
         if(streamingConnection != null)
         {
            if(streamingConnection.connected)
            {
               try
               {
                  streamingConnection.close();
               }
               catch(ignore:Error)
               {
               }
            }
         }
         if(streamId != null)
         {
            if(streamingConnectionCloser == null)
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
               streamingConnectionCloser = new URLStream();
               streamingConnectionCloser.addEventListener(Event.COMPLETE,process);
               streamingConnectionCloser.addEventListener(IOErrorEvent.IO_ERROR,process);
               streamingConnectionCloser.addEventListener(HTTPStatusEvent.HTTP_STATUS,ignore);
               streamingConnectionCloser.addEventListener(SecurityErrorEvent.SECURITY_ERROR,ignore);
            }
            if(!streamingConnectionCloser.connected)
            {
               request = new URLRequest();
               url = channel.endpoint;
               if(_appendToURL != null)
               {
                  url += _appendToURL;
               }
               request.url = url + "?" + COMMAND_PARAM_NAME + "=" + CLOSE_COMMAND + "&" + STREAM_ID_PARAM_NAME + "=" + streamId + "&" + VERSION_PARAM_NAME + "=" + VERSION_1;
               request.method = URLRequestMethod.POST;
               postParams = new URLVariables();
               postParams[AbstractMessage.FLEX_CLIENT_ID_HEADER] = FlexClient.getInstance().id;
               request.data = postParams;
               streamingConnectionCloser.load(request);
            }
         }
      }
      
      public function openStreamingConnection(appendToURL:String = null) : void
      {
         var request:URLRequest = null;
         var url:String = null;
         var postParams:URLVariables = null;
         state = INIT_STATE;
         _appendToURL = appendToURL;
         if(streamingConnection == null)
         {
            streamingConnection = new URLStream();
            streamingConnection.addEventListener(Event.OPEN,streamOpenHandler);
            streamingConnection.addEventListener(ProgressEvent.PROGRESS,streamProgressHandler);
            streamingConnection.addEventListener(Event.COMPLETE,streamCompleteHandler);
            streamingConnection.addEventListener(HTTPStatusEvent.HTTP_STATUS,streamHttpStatusHandler);
            streamingConnection.addEventListener(IOErrorEvent.IO_ERROR,streamIoErrorHandler);
            streamingConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,streamSecurityErrorHandler);
         }
         if(!streamingConnection.connected)
         {
            request = new URLRequest();
            url = channel.endpoint;
            if(_appendToURL != null)
            {
               url += _appendToURL;
            }
            request.url = url + "?" + COMMAND_PARAM_NAME + "=" + OPEN_COMMAND + "&" + VERSION_PARAM_NAME + "=" + VERSION_1;
            request.method = URLRequestMethod.POST;
            postParams = new URLVariables();
            postParams[AbstractMessage.FLEX_CLIENT_ID_HEADER] = FlexClient.getInstance().id;
            request.data = postParams;
            streamingConnection.load(request);
         }
      }
      
      private function streamIoErrorHandler(event:IOErrorEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function convertHexToDecimal(value:String) : int
      {
         var digit:int = 0;
         var result:int = 0;
         var powerOfSixteen:int = 0;
         for(var i:int = value.length - 1; i >= 0; i--)
         {
            if(powerOfSixteen == 0)
            {
               powerOfSixteen = 1;
            }
            else
            {
               powerOfSixteen *= 16;
            }
            digit = int(HEX_VALUES[value.charAt(i)]);
            result += digit * powerOfSixteen;
         }
         return result;
      }
      
      protected function readMessage() : IMessage
      {
         return null;
      }
      
      private function streamSecurityErrorHandler(event:SecurityErrorEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function streamHttpStatusHandler(event:HTTPStatusEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function streamCompleteHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
   }
}

