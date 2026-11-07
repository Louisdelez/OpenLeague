package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.tracker.ITreeOfTrackers;
   
   public interface IMetricsProvider extends IProvider
   {
      
      function willTrack() : Boolean;
      
      function track(param1:String, param2:Object = null, param3:Boolean = false, param4:Number = 1) : void;
      
      function createNewTrackerByName(param1:String) : ITreeOfTrackers;
   }
}

