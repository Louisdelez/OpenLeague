package mx.controls.videoClasses
{
   import flash.net.NetConnection;
   
   [ExcludeClass]
   public interface INCManager
   {
      
      function get timeout() : uint;
      
      function set timeout(param1:uint) : void;
      
      function get streamWidth() : Number;
      
      function get streamHeight() : Number;
      
      function connectToURL(param1:String) : Boolean;
      
      function get streamName() : String;
      
      function get streamLength() : Number;
      
      function isRTMP() : Boolean;
      
      function get bitrate() : Number;
      
      function connectAgain() : Boolean;
      
      function reconnect() : void;
      
      function set videoPlayer(param1:VideoPlayer) : void;
      
      function set bitrate(param1:Number) : void;
      
      function get netConnection() : NetConnection;
      
      function get videoPlayer() : VideoPlayer;
      
      function close() : void;
   }
}

