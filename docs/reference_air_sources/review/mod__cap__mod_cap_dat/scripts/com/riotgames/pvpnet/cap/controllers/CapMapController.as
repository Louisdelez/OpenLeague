package com.riotgames.pvpnet.cap.controllers
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapPositionTargets;
   import mx.collections.ArrayCollection;
   
   public class CapMapController
   {
      
      private var positionTargetData:CapPositionTargets;
      
      private var playerSelections:ArrayCollection;
      
      private var positions:Array;
      
      public function CapMapController(param1:ArrayCollection, param2:CapPositionTargets, param3:Array)
      {
         super();
         this.playerSelections = param1;
         this.positionTargetData = param2;
         this.positions = param3;
         this.watchForPositionChanges();
      }
      
      private function watchForPositionChanges() : void
      {
         var _loc1_:CapPlayerSelection = null;
         for each(_loc1_ in this.playerSelections.source)
         {
            _loc1_.positionChanged.add(this.handlePositionChanged);
         }
      }
      
      private function handlePositionChanged(param1:CapPlayerSelection, param2:CapPosition, param3:CapPosition) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         if(param2)
         {
            _loc4_ = this.getPlayersAtPosition(param2);
            this.repositionPlayersAtPosition(_loc4_,param2);
         }
         if(param3)
         {
            _loc5_ = this.getPlayersAtPosition(param3);
            this.repositionPlayersAtPosition(_loc5_,param3);
         }
      }
      
      private function unwatchForPositionChanges() : void
      {
         var _loc1_:CapPlayerSelection = null;
         for each(_loc1_ in this.playerSelections.source)
         {
            _loc1_.positionChanged.remove(this.handlePositionChanged);
         }
      }
      
      public function updateAllPositions() : void
      {
         var _loc1_:CapPosition = null;
         for each(_loc1_ in this.positions)
         {
            this.repositionPlayersAtPosition(this.getPlayersAtPosition(_loc1_),_loc1_);
         }
      }
      
      private function getPlayersAtPosition(param1:CapPosition) : Array
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.playerSelections.source)
         {
            if(_loc3_.position == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function repositionPlayersAtPosition(param1:Array, param2:CapPosition) : void
      {
         var _loc5_:int = 0;
         var _loc6_:CapPlayerSelection = null;
         var _loc3_:int = int(param1.length);
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:int = 0;
         for each(_loc6_ in param1)
         {
            _loc5_ = _loc4_ + 1;
            _loc6_.mapCoordinates = this.positionTargetData.getCoordinates(param2,_loc3_,_loc5_);
            _loc4_++;
         }
      }
      
      public function destroy() : void
      {
         this.unwatchForPositionChanges();
      }
   }
}

