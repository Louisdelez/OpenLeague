package com.riotgames.platform.gameclient.domain.inventory.reroll
{
   import com.riotgames.platform.common.provider.IRerollProvider;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.reroll.PointSummary;
   import com.riotgames.platform.gameclient.domain.reroll.RollResult;
   import flash.events.EventDispatcher;
   
   public class RerollProvider extends EventDispatcher implements IRerollProvider
   {
      
      private var _rerollCached:Boolean;
      
      private var _pointSummary:PointSummary;
      
      private var _onRerollSuccess:Function;
      
      private var _onRerollError:Function;
      
      private var _onRerollComplete:Function;
      
      private var _onPointsBalanceSuccess:Function;
      
      private var _onPointsBalanceError:Function;
      
      private var _rerollEnabled:Boolean;
      
      private var _onPointsBalanceComplete:Function;
      
      public function RerollProvider()
      {
         super();
         this._rerollEnabled = false;
      }
      
      public function updateRerollCache() : void
      {
         this._rerollCached = false;
      }
      
      public function getRerollEnabled() : Boolean
      {
         return this._rerollEnabled;
      }
      
      public function getPointsBalance(param1:Function, param2:Function, param3:Function) : void
      {
         this._onPointsBalanceSuccess = param1;
         this._onPointsBalanceComplete = param2;
         this._onPointsBalanceError = param3;
         ServiceProxy.instance.rerollService.getPointsBalance(this.onPointsBalanceSuccessImpl,this.onPointsBalanceCompleteImpl,this.onPointsBalanceErrorImpl);
      }
      
      private function onRerollCompleteImpl(param1:Object = null) : void
      {
         if(Boolean(this._onRerollComplete))
         {
            this._onRerollComplete(param1);
         }
      }
      
      private function onPointsBalanceSuccessImpl(param1:Object = null) : void
      {
         this.setPointSummary(param1.result as PointSummary);
         if(Boolean(this._onPointsBalanceSuccess))
         {
            this._onPointsBalanceSuccess(param1);
         }
      }
      
      public function getMaxRerollProgress() : uint
      {
         if(this._pointSummary)
         {
            return this._pointSummary.pointsCostToRoll;
         }
         return 0;
      }
      
      private function onRerollSuccessImpl(param1:Object = null) : void
      {
         var _loc2_:RollResult = param1.result as RollResult;
         this.setPointSummary(_loc2_._pointSummary);
         if(Boolean(this._onRerollSuccess))
         {
            this._onRerollSuccess(param1);
         }
      }
      
      public function useReroll(param1:Function, param2:Function, param3:Function) : void
      {
         this._onRerollSuccess = param1;
         this._onRerollComplete = param2;
         this._onRerollError = param3;
         ServiceProxy.instance.rerollService.useReroll(this.onRerollSuccessImpl,this.onRerollCompleteImpl,this.onRerollErrorImpl);
      }
      
      public function getRerollCount() : uint
      {
         if(this._pointSummary)
         {
            return this._pointSummary.numberOfRolls;
         }
         return 0;
      }
      
      private function onRerollErrorImpl(param1:Object = null) : void
      {
         this._rerollEnabled = false;
         if(Boolean(this._onRerollError))
         {
            this._onRerollError(param1);
         }
      }
      
      private function onPointsBalanceErrorImpl(param1:Object = null) : void
      {
         this._rerollEnabled = false;
         if(Boolean(this._onPointsBalanceError))
         {
            this._onPointsBalanceError(param1);
         }
      }
      
      public function getRerollPoints() : uint
      {
         if(this._pointSummary)
         {
            return this._pointSummary.currentPoints;
         }
         return 0;
      }
      
      public function getPointSummary() : PointSummary
      {
         return this._pointSummary;
      }
      
      private function onPointsBalanceCompleteImpl(param1:Object = null) : void
      {
         if(Boolean(this._onPointsBalanceComplete))
         {
            this._onPointsBalanceComplete(param1);
         }
      }
      
      public function getRerollCached() : Boolean
      {
         return this._rerollCached;
      }
      
      public function getMaxRerollCount() : uint
      {
         if(this._pointSummary)
         {
            return this._pointSummary.maxRolls;
         }
         return 0;
      }
      
      public function getRerollProgress() : uint
      {
         if(this._pointSummary)
         {
            return this._pointSummary.rerollProgress;
         }
         return 0;
      }
      
      public function setPointSummary(param1:PointSummary) : void
      {
         this._pointSummary = param1;
         this._rerollCached = true;
         this._rerollEnabled = true;
      }
   }
}

