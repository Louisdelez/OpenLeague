package org.igniterealtime.xiff.data.im
{
   import mx.collections.ArrayCollection;
   import mx.utils.ObjectUtil;
   import org.igniterealtime.xiff.data.Presence;
   
   public class RosterGroup extends ArrayCollection
   {
      
      public static const UNDEFINED_PRIORITY:int = int.MIN_VALUE;
      
      public var label:String;
      
      public var priority:int;
      
      public var shared:Boolean = false;
      
      public function RosterGroup(param1:String, param2:int)
      {
         super();
         refresh();
         this.label = param1;
         this.priority = param2;
      }
      
      public static function sortContacts(param1:RosterItemVO, param2:RosterItemVO, param3:Array = null) : int
      {
         if(param1.displayName.toLowerCase() < param2.displayName.toLowerCase())
         {
            return -1;
         }
         if(param1.displayName.toLowerCase() > param2.displayName.toLowerCase())
         {
            return 1;
         }
         return 0;
      }
      
      public static function compareRosterItemsByStatus(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc6_:int = 0;
         var _loc4_:RosterItemVO = param1 as RosterItemVO;
         var _loc5_:RosterItemVO = param2 as RosterItemVO;
         _loc6_ = int(ObjectUtil.numericCompare(rankShow(_loc4_.show),rankShow(_loc5_.show)));
         var _loc7_:String = _loc4_.comparableDisplayName.toLowerCase();
         var _loc8_:String = _loc5_.comparableDisplayName.toLowerCase();
         if(_loc6_ == 0 && _loc7_ != _loc8_)
         {
            _loc6_ = _loc7_ > _loc8_ ? 1 : -1;
         }
         return _loc6_;
      }
      
      public static function rankShow(param1:String) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case Presence.SHOW_DND:
               _loc2_ = 1;
               break;
            case Presence.UNAVAILABLE_TYPE:
               _loc2_ = 2;
               break;
            default:
               _loc2_ = 0;
         }
         return _loc2_;
      }
      
      override public function addItem(param1:Object) : void
      {
         if(!param1 is RosterItemVO)
         {
            throw new Error("Assertion Failure: attempted to add something other than a RosterItemVO to a RosterGroup");
         }
         if(source.indexOf(param1) == -1)
         {
            super.addItem(param1);
         }
      }
      
      public function removeItem(param1:RosterItemVO) : void
      {
         var _loc2_:int = int(getItemIndex(param1));
         if(_loc2_ >= 0)
         {
            removeItemAt(_loc2_);
         }
         else
         {
            _loc2_ = int(source.indexOf(param1));
            if(_loc2_ >= 0)
            {
               source.splice(_loc2_,1);
            }
         }
      }
      
      override public function set filterFunction(param1:Function) : void
      {
         throw new Error("Setting the filterFunction on RosterGroup is not allowed; Wrap it in a ListCollectionView and filter that.");
      }
   }
}

