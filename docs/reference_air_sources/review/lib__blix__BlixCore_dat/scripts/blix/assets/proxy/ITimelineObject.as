package blix.assets.proxy
{
   public interface ITimelineObject
   {
      
      function getIsPlaying() : Boolean;
      
      function getCurrentFrame() : int;
      
      function getCurrentFrameLabel() : String;
      
      function getCurrentLabel() : String;
      
      function getCurrentLabels() : Array;
      
      function getTotalFrames() : int;
      
      function gotoAndPlay(param1:Object, param2:String = null) : void;
      
      function gotoAndStop(param1:Object, param2:String = null) : void;
      
      function nextFrame() : void;
      
      function play() : void;
      
      function prevFrame() : void;
      
      function stop() : void;
   }
}

