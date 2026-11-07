package com.riotgames.pvpnet.cap.util
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import mx.collections.ArrayCollection;
   
   public class CapModelUtil
   {
      
      public function CapModelUtil()
      {
         super();
         throw new Error("This is a static utility class.  Do not instantiate");
      }
      
      public static function refreshCollection(param1:CapModel) : void
      {
         param1.playerSelections.refresh();
      }
      
      public static function groupHasInvitedPlayer(param1:ArrayCollection) : Boolean
      {
         var _loc2_:CapPlayerSelection = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_.isInvitedPlayer)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getPlayerSelectionSlotById(param1:CapModel, param2:int) : CapPlayerSelection
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc4_:int = 0;
         if(param1.localPlayerSelection.slotId == param2)
         {
            return param1.localPlayerSelection;
         }
         var _loc5_:ArrayCollection = param1.playerSelections;
         for each(_loc3_ in _loc5_.source)
         {
            if(_loc3_.slotId == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function getAllAvailablePlayerSelections(param1:CapModel) : Array
      {
         return param1.playerSelections.source;
      }
      
      public static function getFirstUnslottedTeammatePlayerSelection(param1:ArrayCollection) : CapPlayerSelection
      {
         var _loc2_:CapPlayerSelection = null;
         for each(_loc2_ in param1.source)
         {
            if(isUnslottedPlayerSelection(_loc2_))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function hasMinPremadeSize(param1:CapModel) : Boolean
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc2_:uint = 0;
         for each(_loc3_ in getAllAvailablePlayerSelections(param1))
         {
            if(_loc3_.isInvitedPlayer || _loc3_.isLocalPlayer)
            {
               _loc2_++;
            }
         }
         return _loc2_ >= param1.minPremadeSize;
      }
      
      public static function getFirstNonInvitedPlayer(param1:CapModel) : CapPlayerSelection
      {
         var _loc2_:CapPlayerSelection = null;
         for each(_loc2_ in getAllAvailablePlayerSelections(param1))
         {
            if(!_loc2_.isInvitedPlayer)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getPlayerBySummonerName(param1:CapModel, param2:String) : CapPlayerSelection
      {
         var _loc3_:CapPlayerSelection = null;
         for each(_loc3_ in getAllAvailablePlayerSelections(param1))
         {
            if(_loc3_.summonerName === param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function isFullPremadeGroup(param1:CapModel) : Boolean
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc2_:Boolean = true;
         var _loc4_:Array = getAllAvailablePlayerSelections(param1);
         for each(_loc3_ in _loc4_)
         {
            _loc2_ &&= _loc3_.isInvitedPlayer || _loc3_.isLocalPlayer;
         }
         return _loc2_;
      }
      
      public static function getUnslottedTeammatePlayerSelections(param1:ArrayCollection) : Array
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc2_:ArrayCollection = new ArrayCollection();
         for each(_loc3_ in param1.source)
         {
            if(isUnslottedPlayerSelection(_loc3_))
            {
               _loc2_.addItem(_loc3_);
            }
         }
         return _loc2_.source;
      }
      
      public static function canInvite(param1:CapModel) : Boolean
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc4_:Boolean = false;
         var _loc2_:uint = 0;
         for each(_loc3_ in getAllAvailablePlayerSelections(param1))
         {
            _loc4_ = CapPlayerSelectionUtil.definesSoloSpec(_loc3_) || CapPlayerSelectionUtil.isActiveInvitedPlayer(_loc3_);
            if(_loc4_)
            {
               _loc2_++;
            }
         }
         return _loc2_ >= param1.playerSelections.source.length;
      }
      
      public static function getUnpopulatedPlayerSelections(param1:CapModel) : Array
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc2_:Array = [];
         for each(_loc3_ in getAllAvailablePlayerSelections(param1))
         {
            if(!_loc3_.isPopulated)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function areAllSlotsRevealed(param1:CapModel) : Boolean
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc2_:uint = 0;
         for each(_loc3_ in getAllAvailablePlayerSelections(param1))
         {
            if(_loc3_.visible)
            {
               _loc2_++;
            }
         }
         return _loc2_ >= param1.playerSelections.source.length;
      }
      
      public static function getCaptain(param1:CapModel) : CapPlayerSelection
      {
         var _loc2_:CapPlayerSelection = null;
         for each(_loc2_ in getAllAvailablePlayerSelections(param1))
         {
            if(_loc2_.isCaptain)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function isUnslottedPlayerSelection(param1:CapPlayerSelection) : Boolean
      {
         return Boolean(param1) && param1.slotId == CapPlayerSelection.NO_INDEX;
      }
      
      public static function getInvisiblePlayerSelections(param1:CapModel) : Array
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc2_:Array = [];
         for each(_loc3_ in getAllAvailablePlayerSelections(param1))
         {
            if(!_loc3_.visible)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}

