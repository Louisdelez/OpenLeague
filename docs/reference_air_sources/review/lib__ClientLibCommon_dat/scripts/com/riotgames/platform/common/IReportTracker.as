package com.riotgames.platform.common
{
   public interface IReportTracker
   {
      
      function addReport(param1:String) : void;
      
      function resetReportedUsers() : void;
      
      function addListener(param1:Function) : void;
      
      function isReported(param1:String) : Boolean;
      
      function reset() : void;
   }
}

