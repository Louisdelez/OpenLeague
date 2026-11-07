package com.riotgames.pvpnet.tracker
{
   public interface ITreeOfTrackers extends ITracker
   {
      
      function has(param1:String) : Boolean;
      
      function add(param1:String, param2:Boolean = false, param3:Number = NaN, param4:Number = NaN, param5:Number = NaN) : ITracker;
      
      function get(param1:String, param2:Boolean = false) : ITracker;
      
      function removeChildByName(param1:String) : ITracker;
      
      function remove(param1:Array) : ITracker;
      
      function removeAllChildren() : ITracker;
      
      function addAndStartNewSegmentAndStopLast(param1:String) : ITracker;
      
      function startAll() : ITracker;
      
      function resetAll() : ITracker;
      
      function stopAll() : ITracker;
   }
}

