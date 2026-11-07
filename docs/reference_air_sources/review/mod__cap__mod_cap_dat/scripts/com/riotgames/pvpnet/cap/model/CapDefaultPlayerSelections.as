package com.riotgames.pvpnet.cap.model
{
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   
   public class CapDefaultPlayerSelections
   {
      
      public function CapDefaultPlayerSelections()
      {
         super();
      }
      
      private static function defaultPlayerSelectionsFilterFunction(param1:CapPlayerSelection) : Boolean
      {
         return param1.visible;
      }
      
      public static function createDefaultPlayerSelections(param1:int) : ArrayCollection
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc2_:Array = [];
         var _loc4_:int;
         var _loc5_:int = _loc4_ = 1;
         while(_loc5_ <= param1)
         {
            _loc3_ = new CapPlayerSelection();
            if(_loc5_ == _loc4_)
            {
               _loc3_.isLocalPlayer = true;
               _loc3_.visible = true;
            }
            _loc2_.push(_loc3_);
            _loc5_++;
         }
         var _loc6_:ArrayCollection = new ArrayCollection(_loc2_);
         _loc6_.filterFunction = defaultPlayerSelectionsFilterFunction;
         var _loc7_:Sort = new Sort();
         _loc7_.compareFunction = defaultPlayerSelectionsSortCompareFunction;
         _loc6_.sort = _loc7_;
         _loc6_.refresh();
         return _loc6_;
      }
      
      private static function defaultPlayerSelectionsSortCompareFunction(param1:CapPlayerSelection, param2:CapPlayerSelection, param3:String) : int
      {
         var _loc4_:int = int(param1.isCaptain);
         var _loc5_:int = int(param2.isCaptain);
         if(_loc4_ < _loc5_)
         {
            return 1;
         }
         if(_loc4_ > _loc5_)
         {
            return -1;
         }
         var _loc6_:int = int(param1.isInvitedPlayer);
         var _loc7_:int = int(param2.isInvitedPlayer);
         if(_loc6_ < _loc7_)
         {
            return 1;
         }
         if(_loc6_ > _loc7_)
         {
            return -1;
         }
         var _loc8_:int = CapPlayerSelection.NO_INDEX;
         var _loc9_:int = param1.slotId;
         var _loc10_:int = param2.slotId;
         if(_loc9_ == _loc8_ && _loc10_ == _loc8_)
         {
            return 0;
         }
         if(_loc9_ == _loc8_)
         {
            return 1;
         }
         if(_loc10_ == _loc8_)
         {
            return -1;
         }
         if(_loc9_ < _loc10_)
         {
            return -1;
         }
         if(_loc9_ > _loc10_)
         {
            return 1;
         }
         return 0;
      }
   }
}

