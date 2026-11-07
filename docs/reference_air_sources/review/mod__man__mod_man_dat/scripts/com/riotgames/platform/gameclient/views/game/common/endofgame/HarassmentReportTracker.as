package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.IReportTracker;
   import mx.collections.ArrayCollection;
   
   public class HarassmentReportTracker implements IReportTracker
   {
      
      private var changeListeners:ArrayCollection = new ArrayCollection();
      
      private var reportedUsers:ArrayCollection = new ArrayCollection();
      
      public function HarassmentReportTracker()
      {
         super();
      }
      
      public function addReport(param1:String) : void
      {
         this.reportedUsers.addItem(param1);
         this.notifyListeners();
      }
      
      private function notifyListeners() : void
      {
         var _loc3_:Function = null;
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < this.changeListeners.length)
         {
            _loc3_ = this.changeListeners.getItemAt(_loc2_) as Function;
            _loc3_.apply(null,_loc1_);
            _loc2_++;
         }
      }
      
      public function reset() : void
      {
         this.changeListeners.removeAll();
      }
      
      public function resetReportedUsers() : void
      {
         this.reportedUsers.removeAll();
      }
      
      public function addListener(param1:Function) : void
      {
         this.changeListeners.addItem(param1);
      }
      
      public function isReported(param1:String) : Boolean
      {
         return this.reportedUsers.contains(param1);
      }
   }
}

