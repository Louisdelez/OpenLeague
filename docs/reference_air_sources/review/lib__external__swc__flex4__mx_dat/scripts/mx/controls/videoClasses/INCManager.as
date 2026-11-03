package mx.controls.videoClasses
{
   import flash.net.NetConnection;
   
   [ExcludeClass]
   public interface INCManager
   {
      
      function get bitrate() : Number;
      
      function set bitrate(param1:Number) : void;
      
      function get netConnection() : NetConnection;
      
      function get streamHeight() : Number;
      
      function get streamLength() : Number;
      
      function get streamName() : String;
      
      function get streamWidth() : Number;
      
      function get timeout() : uint;
      
      function set timeout(param1:uint) : void;
      
      function get videoPlayer() : VideoPlayer;
      
      function set videoPlayer(param1:VideoPlayer) : void;
      
      function connectToURL(param1:String) : Boolean;
      
      function connectAgain() : Boolean;
      
      function reconnect() : void;
      
      function close() : void;
      
      function isRTMP() : Boolean;
   }
}

