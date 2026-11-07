package com.riotgames.pvpnet.tracker
{
   import com.riotgames.pvpnet.tracker.model.RiotDradisRecord;
   
   public interface IMetricsSubmitter
   {
      
      function track(param1:String, param2:Object = null, param3:Boolean = false, param4:Number = 1) : void;
      
      function prepareDradisRecord(param1:String, param2:Object, param3:Number) : RiotDradisRecord;
      
      function submitJSON(param1:String) : void;
   }
}

