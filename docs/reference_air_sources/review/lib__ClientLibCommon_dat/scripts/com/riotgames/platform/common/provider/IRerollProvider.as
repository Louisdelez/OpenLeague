package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.gameclient.domain.reroll.PointSummary;
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface IRerollProvider extends IProvider
   {
      
      function getPointsBalance(param1:Function, param2:Function, param3:Function) : void;
      
      function getRerollCached() : Boolean;
      
      function getRerollPoints() : uint;
      
      function getMaxRerollProgress() : uint;
      
      function getPointSummary() : PointSummary;
      
      function getRerollCount() : uint;
      
      function getMaxRerollCount() : uint;
      
      function getRerollProgress() : uint;
      
      function useReroll(param1:Function, param2:Function, param3:Function) : void;
      
      function updateRerollCache() : void;
      
      function getRerollEnabled() : Boolean;
      
      function setPointSummary(param1:PointSummary) : void;
   }
}

