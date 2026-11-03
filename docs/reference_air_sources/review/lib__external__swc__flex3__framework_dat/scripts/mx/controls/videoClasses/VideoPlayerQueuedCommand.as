package mx.controls.videoClasses
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class VideoPlayerQueuedCommand
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const PLAY:uint = 0;
      
      public static const LOAD:uint = 1;
      
      public static const PAUSE:uint = 2;
      
      public static const STOP:uint = 3;
      
      public static const SEEK:uint = 4;
      
      public var cuePoints:Array;
      
      public var isLive:Boolean;
      
      public var type:uint;
      
      public var time:Number;
      
      public var url:String;
      
      public function VideoPlayerQueuedCommand(type:uint, url:String = null, isLive:Boolean = false, time:Number = 0, cuePoints:Array = null)
      {
         super();
         this.type = type;
         this.url = url;
         this.isLive = isLive;
         this.time = time;
         this.cuePoints = cuePoints;
      }
   }
}

