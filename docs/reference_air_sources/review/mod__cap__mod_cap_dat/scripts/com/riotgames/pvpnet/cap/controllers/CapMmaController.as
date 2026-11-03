package com.riotgames.pvpnet.cap.controllers
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class CapMmaController
   {
      
      private var _model:CapModel;
      
      public function CapMmaController(param1:CapModel)
      {
         super();
         this._model = param1;
      }
      
      public function isChampionBonusActive(param1:Champion) : Boolean
      {
         var _loc2_:int = 0;
         if(param1)
         {
            for each(_loc2_ in this._model.mmaChampionBonusIds)
            {
               if(_loc2_ == param1.championId)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function isRoleBonusActive(param1:CapRole) : Boolean
      {
         var _loc2_:String = null;
         if(param1)
         {
            for each(_loc2_ in this._model.mmaRoleBonusIds)
            {
               if(_loc2_ == param1.id)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function isPositionBonusActive(param1:CapPosition) : Boolean
      {
         var _loc2_:String = null;
         if(param1)
         {
            for each(_loc2_ in this._model.mmaPositionBonusIds)
            {
               if(_loc2_ == param1.id)
               {
                  return true;
               }
            }
         }
         return false;
      }
   }
}

