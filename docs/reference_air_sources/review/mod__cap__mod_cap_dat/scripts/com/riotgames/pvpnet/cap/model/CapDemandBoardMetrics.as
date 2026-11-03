package com.riotgames.pvpnet.cap.model
{
   import flash.utils.describeType;
   
   public class CapDemandBoardMetrics
   {
      
      public static const STARTED_SOLO_QUERY_STATE:String = "startedSoloQuery";
      
      public static const QUIT_STATE:String = "quit";
      
      public var demandedPositions:String;
      
      public var championID:int = -1;
      
      public var slotClicks:int = 0;
      
      public var selectedPosition:String = "";
      
      public var selectedRole:String = "";
      
      public var demandedRoles:String;
      
      public var endState:String;
      
      public var summonerName:String;
      
      public function CapDemandBoardMetrics()
      {
         super();
      }
      
      public function toObject() : Object
      {
         var _loc2_:XML = null;
         var _loc4_:String = null;
         var _loc1_:XML = describeType(this);
         var _loc3_:Object = {};
         for each(_loc2_ in _loc1_.descendants())
         {
            if(_loc2_.name() == "variable")
            {
               _loc4_ = _loc2_.@name;
               _loc3_[_loc4_] = this[_loc4_];
            }
         }
         return _loc3_;
      }
   }
}

