package com.riotgames.pvpnet.tracking.trackers.featuredcontent
{
   import com.riotgames.pvpnet.tracker.SessionTimeframedTracker;
   import com.riotgames.pvpnet.tracking.trackers.featuredcontent.model.BookTrackInfo;
   
   public class FeaturedContentTracker extends SessionTimeframedTracker implements IFeaturedContentTracker
   {
      
      protected var curBookVisit:BookTrackInfo;
      
      protected var isInMatchmakingQueue:Boolean = false;
      
      protected var allBookVisits:Array = [];
      
      public function FeaturedContentTracker(param1:Boolean = true)
      {
         super("client_featured_content",param1);
         isTimer = false;
      }
      
      public function enteredBook(param1:String) : void
      {
         this.curBookVisit = new BookTrackInfo(param1);
         if(this.isInMatchmakingQueue)
         {
            this.curBookVisit.enteredMatchmakingQueue();
         }
         this.allBookVisits.push(this.curBookVisit);
         ++BookTrackInfo.enteredAnyBookCount;
         this.curBookVisit.viewNumber = BookTrackInfo.enteredAnyBookCount;
         this.curBookVisit.inBook = true;
         this.curBookVisit.enteredTimestamp = getNow();
         this.startThisRecording();
      }
      
      public function exitedBook(param1:String) : void
      {
         ++BookTrackInfo.exitedAnyBookCount;
         this.curBookVisit.inBook = false;
         this.curBookVisit.exitedTimestamp = getNow();
         this.stopThisViewRecording();
         this.curBookVisit = null;
      }
      
      public function clickedButton(param1:String, param2:String) : void
      {
         if(this.curBookVisit != null)
         {
            this.curBookVisit.clickedButton(param1,param2);
         }
      }
      
      public function mouseOutButton(param1:String, param2:String) : void
      {
         if(this.curBookVisit != null)
         {
            this.curBookVisit.mouseOutButton(param1,param2);
         }
      }
      
      protected function stopThisViewRecording() : void
      {
         this.curBookVisit.timeOnBook.stop();
         get("total").stop();
      }
      
      public function setPages(param1:Array) : void
      {
         this.curBookVisit.setPages(param1);
      }
      
      override public function sessionClosed() : void
      {
         var _loc1_:BookTrackInfo = null;
         var _loc2_:BookTrackInfo = null;
         var _loc3_:int = 0;
         if(this.allBookVisits.length > 0)
         {
            setProperty("total.duration",get("total").getElapsedTimeInMS());
            setProperty("book_entered_count",BookTrackInfo.enteredAnyBookCount);
            setProperty("book_exited_count",BookTrackInfo.exitedAnyBookCount);
            removeChildByName("total");
            _loc1_ = this.allBookVisits[0];
            _loc1_.sessionClosed(this,"first_view");
            setProperty("pages_count",_loc1_.pages.length);
            setProperty(".id",_loc1_.id);
            if(this.allBookVisits.length == 1)
            {
               _loc2_ = this.allBookVisits[0];
               _loc2_.sessionClosed(this,"furthest_view");
            }
            else
            {
               this.allBookVisits.sortOn("totalTimeOnBook",Array.NUMERIC | Array.DESCENDING);
               _loc3_ = 0;
               while(_loc3_ < this.allBookVisits.length)
               {
                  _loc2_ = this.allBookVisits[_loc3_];
                  if(_loc2_.hasCompletedAllPages)
                  {
                     break;
                  }
                  _loc3_++;
               }
               if(_loc2_ != null)
               {
                  _loc2_.sessionClosed(this,"furthest_view");
               }
               else
               {
                  _loc1_.sessionClosed(this,"furthest_view");
               }
            }
            super.sessionClosed();
         }
      }
      
      public function enteredPage(param1:String) : void
      {
         if(this.curBookVisit != null)
         {
            this.curBookVisit.enteredPage(param1);
         }
      }
      
      public function setInMatchMakingQueue(param1:Boolean) : void
      {
         this.isInMatchmakingQueue = param1;
         if(this.curBookVisit != null)
         {
            this.curBookVisit.enteredMatchmakingQueue();
         }
      }
      
      public function mouseOverButton(param1:String, param2:String) : void
      {
         if(this.curBookVisit != null)
         {
            this.curBookVisit.mouseOverButton(param1,param2);
         }
      }
      
      public function exitedPage(param1:String) : void
      {
         if(this.curBookVisit != null)
         {
            this.curBookVisit.exitedPage(param1);
         }
      }
      
      protected function startThisRecording() : void
      {
         this.curBookVisit.timeOnBook.start();
         get("total",true).start();
      }
      
      public function closedBook(param1:String, param2:String, param3:Boolean) : void
      {
         if(this.curBookVisit != null)
         {
            if(this.curBookVisit.curPage != null)
            {
               if(!param3)
               {
                  this.curBookVisit.interruptedViewing = true;
               }
               this.curBookVisit.exitedPage(this.curBookVisit.curPage.name);
            }
            this.curBookVisit.closedReason = param2;
            this.stopThisViewRecording();
         }
      }
      
      public function setContentId(param1:String) : void
      {
         this.curBookVisit.id = param1;
      }
      
      public function completedPage(param1:String) : void
      {
         if(this.curBookVisit != null)
         {
            this.curBookVisit.completedPage(param1);
         }
      }
   }
}

