package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.cap.model.CapEstimatedWaitTime;
   import com.riotgames.pvpnet.cap.model.CapEstimatedWaitTimeCache;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class CapEstimatedWaitTimeRetrievedV1 extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "estimatedWaitTimeRetrievedV1";
      
      private static const ESTIMATED_WAIT_TIME_KEY:String = "estimatedWaitTime";
      
      private static const CHAMPION_ID_KEY:String = "championId";
      
      private static const ROLE_ID_KEY:String = "role";
      
      private static const POSITION_ID_KEY:String = "position";
      
      private static const MMA_ENABLED_KEY:String = "mmaEnabled";
      
      private var _estimatedWaitTimeCache:CapEstimatedWaitTimeCache;
      
      private var _model:CapModel;
      
      public function CapEstimatedWaitTimeRetrievedV1(param1:CapModel, param2:IDecode, param3:CapEstimatedWaitTimeCache, param4:String = null)
      {
         this._model = param1;
         this._estimatedWaitTimeCache = param3;
         super(METHOD_NAME,param2,param4);
      }
      
      protected function getPositionById(param1:String) : CapPosition
      {
         var _loc2_:CapPosition = null;
         for each(_loc2_ in this._model.positions)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      protected function getEstimatedWaitTimeById(param1:int) : CapEstimatedWaitTime
      {
         var _loc2_:CapEstimatedWaitTime = null;
         for each(_loc2_ in this._model.estimatedWaitTimes)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      protected function getChampionById(param1:int) : Champion
      {
         var _loc2_:Champion = null;
         for each(_loc2_ in this._model.availableChampions)
         {
            if(_loc2_.championId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc2_:int = int(param1[ESTIMATED_WAIT_TIME_KEY]);
         var _loc3_:int = int(param1[CHAMPION_ID_KEY]);
         var _loc4_:String = param1[ROLE_ID_KEY];
         var _loc5_:String = param1[POSITION_ID_KEY];
         var _loc6_:CapEstimatedWaitTime = this.getEstimatedWaitTimeById(_loc2_);
         var _loc7_:Champion = this.getChampionById(_loc3_);
         var _loc8_:CapRole = this.getRoleById(_loc4_);
         var _loc9_:CapPosition = this.getPositionById(_loc5_);
         if(Boolean(_loc7_ && _loc8_) && Boolean(_loc9_) && Boolean(_loc6_))
         {
            this._estimatedWaitTimeCache.cacheEstimatedWaitTime(_loc7_,_loc8_,_loc9_,_loc6_);
         }
         this._model.currentEstimatedWaitTime = _loc6_;
         super.doDecode(param1);
      }
      
      protected function getRoleById(param1:String) : CapRole
      {
         var _loc2_:CapRole = null;
         for each(_loc2_ in this._model.allRoles)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

