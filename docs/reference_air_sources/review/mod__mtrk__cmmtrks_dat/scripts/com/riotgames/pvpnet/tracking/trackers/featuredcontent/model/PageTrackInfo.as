package com.riotgames.pvpnet.tracking.trackers.featuredcontent.model
{
   import com.riotgames.pvpnet.tracker.ITracker;
   import com.riotgames.pvpnet.tracker.Tracker;
   
   public class PageTrackInfo
   {
      
      public var hasCompletedPage:Boolean = false;
      
      public var replayedPageImmediately:Number = NaN;
      
      public var name:String;
      
      public var autoplayed_fully:Boolean = false;
      
      public var isLastPage:Boolean = false;
      
      public var entries:int = 0;
      
      public var duration:Number;
      
      public var exits:int = 0;
      
      public var id:int = -1;
      
      public var incompleteView:Boolean = false;
      
      public var isInPage:Boolean = false;
      
      public var hasExitedPage:Boolean = false;
      
      public var hasEnteredPage:Boolean = false;
      
      public var total_views:int = 0;
      
      public var clickedButton:Boolean = false;
      
      public var timeOnPageTracker:ITracker;
      
      public function PageTrackInfo(param1:int, param2:String)
      {
         super();
         this.timeOnPageTracker = new Tracker(param2);
         this.name = param2;
      }
   }
}

