package com.riotgames.pvpnet.tracker
{
   import blix.signals.ISignal;
   
   public interface ITracker
   {
      
      function getName() : String;
      
      function setName(param1:String) : void;
      
      function getFullName(param1:Boolean = false) : String;
      
      function get hasBeenSent() : Boolean;
      
      function set hasBeenSent(param1:Boolean) : void;
      
      function send() : ITracker;
      
      function clearAllProperties() : ITracker;
      
      function getProperty(param1:String) : Object;
      
      function setProperty(param1:String, param2:Object = null) : ITracker;
      
      function addTimeStampedEvent(param1:String) : ITracker;
      
      function clearAllCounters() : ITracker;
      
      function removeCounter(param1:String) : ITracker;
      
      function incrementCounter(param1:String, param2:Number = 1, param3:Boolean = true) : ITracker;
      
      function decrementCounter(param1:String, param2:Number = 1, param3:Boolean = true) : ITracker;
      
      function setCounterValue(param1:String, param2:Number = 0, param3:Boolean = true) : ITracker;
      
      function getCounterValue(param1:String) : Number;
      
      function hasCounter(param1:String) : Boolean;
      
      function setIfMaxCounter(param1:String, param2:Number, param3:Boolean = true) : ITracker;
      
      function setIfMinCounter(param1:String, param2:Number, param3:Boolean = true) : ITracker;
      
      function hasRecording(param1:String) : Boolean;
      
      function recordValue(param1:String, param2:Number = 0, param3:Boolean = true, param4:Boolean = false) : ITracker;
      
      function clearAllRecordings() : ITracker;
      
      function removeRecording(param1:String) : ITracker;
      
      function toString() : String;
      
      function toJSON(param1:Boolean = true, param2:String = "", param3:Boolean = false) : *;
      
      function start() : ITracker;
      
      function stop() : ITracker;
      
      function reset() : ITracker;
      
      function stopAndSend() : ITracker;
      
      function stopAndSendAll() : ITracker;
      
      function getElapsedTimeInMS() : Number;
      
      function getElapsedTimeInHours() : Number;
      
      function getElapsedTimeInMinutes() : Number;
      
      function getDepthInHierarchy() : Number;
      
      function getParentTracker() : ITreeOfTrackers;
      
      function setParentTracker(param1:ITreeOfTrackers) : void;
      
      function getSent() : ISignal;
      
      function getStopped() : ISignal;
      
      function getStarted() : ISignal;
      
      function resetAllToDefaults() : void;
   }
}

