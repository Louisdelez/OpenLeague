package com.riotgames.pvpnet.tracking.trackers.featuredcontent.model
{
   import com.riotgames.pvpnet.tracker.ITracker;
   import com.riotgames.pvpnet.tracker.Tracker;
   
   public class BookTrackInfo
   {
      
      public static var enteredAnyBookCount:int = 0;
      
      public static var exitedAnyBookCount:int = 0;
      
      public var curBookPagesIdx:Object = new Object();
      
      public var pages:Array = [];
      
      public var farthestPageId:int = 0;
      
      private var lastPage:PageTrackInfo;
      
      public var closedReason:String = "";
      
      public var bookName:String;
      
      public var viewNumber:Number = 0;
      
      public var exitedTimestamp:Number = NaN;
      
      public var id:String;
      
      public var enteredTimestamp:Number = NaN;
      
      public var timeOnBook:ITracker;
      
      public var viewedInMatchmaking:Boolean = false;
      
      public var hasCompletedAllPages:Boolean = true;
      
      public var inBook:Boolean;
      
      public var curPage:PageTrackInfo;
      
      public var totalTimeOnBook:Number = 0;
      
      public var interruptedViewing:Boolean = false;
      
      private var hasSetPages:Boolean = false;
      
      public var hasAutoplayedAllPages:Boolean = true;
      
      public function BookTrackInfo(param1:String)
      {
         super();
         param1 = param1;
         this.timeOnBook = new Tracker("book");
      }
      
      public function clickedButton(param1:String, param2:String) : void
      {
         if(param2.indexOf("panel") == 0)
         {
            if(this.curPage == this.curBookPagesIdx[param1])
            {
               this.curPage.clickedButton = true;
               this.curPage.autoplayed_fully = false;
            }
         }
         else if(param2.indexOf("pageThumbnail") == 0)
         {
         }
      }
      
      public function setPages(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PageTrackInfo = null;
         if(!this.hasSetPages)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = new PageTrackInfo(_loc2_,param1[_loc2_]);
               _loc3_.id = _loc2_ + 1;
               if(_loc2_ == param1.length - 1)
               {
                  _loc3_.isLastPage = true;
               }
               this.curBookPagesIdx[_loc3_.name] = _loc3_;
               this.pages.push(_loc3_);
               _loc2_++;
            }
            this.hasSetPages = true;
         }
      }
      
      public function updateDetails() : void
      {
         var _loc2_:PageTrackInfo = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.pages.length)
         {
            _loc2_ = this.pages[_loc1_];
            if(!_loc2_.hasCompletedPage)
            {
               this.hasCompletedAllPages = false;
            }
            if(!_loc2_.autoplayed_fully)
            {
               this.hasAutoplayedAllPages = false;
            }
            _loc1_++;
         }
      }
      
      public function mouseOutButton(param1:String, param2:String) : void
      {
      }
      
      public function enteredMatchmakingQueue() : void
      {
         if(this.inBook)
         {
            this.viewedInMatchmaking = true;
         }
      }
      
      public function sessionClosed(param1:ITracker, param2:String) : void
      {
         var _loc4_:PageTrackInfo = null;
         param1.setProperty(param2 + ".view_number",this.viewNumber);
         param1.setProperty(param2 + "_session_time_when_opened.timestamp",this.enteredTimestamp);
         if(!isNaN(this.exitedTimestamp))
         {
            param1.setProperty(param2 + "_session_time_when_closed.timestamp",this.exitedTimestamp);
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.pages.length)
         {
            _loc4_ = this.pages[_loc3_];
            if(_loc4_.hasEnteredPage)
            {
               param1.setProperty(param2 + "_duration.page_" + (_loc3_ + 1),_loc4_.duration);
               if(!isNaN(_loc4_.replayedPageImmediately))
               {
                  param1.setProperty(param2 + "_replayed_page_immediately_count",_loc4_.replayedPageImmediately);
               }
            }
            else
            {
               param1.setProperty(param2 + "_duration.page_" + (_loc3_ + 1),0);
            }
            param1.setProperty(param2 + "_autoplayed.page_" + (_loc3_ + 1),_loc4_.autoplayed_fully);
            if(_loc4_.clickedButton && !_loc4_.hasCompletedPage)
            {
               param1.setProperty(param2 + "_skipped_ahead_on.page_" + (_loc3_ + 1),_loc4_.autoplayed_fully);
            }
            _loc3_++;
         }
         param1.setProperty(param2 + ".duration",this.timeOnBook.getElapsedTimeInMS());
         param1.setProperty(param2 + "_in_matchmaking.boolean",this.viewedInMatchmaking);
         param1.setProperty(param2 + "_finished_comic.boolean",this.hasCompletedAllPages);
         param1.setProperty(param2 + "_furthest_page_viewed",this.farthestPageId);
         param1.setProperty(param2 + "_interrupted_viewing",this.interruptedViewing);
         param1.incrementCounter("closed_book_reason_" + this.closedReason);
         param1.setProperty(param2 + "_autoplayed.fully",this.hasAutoplayedAllPages);
      }
      
      public function exitedPage(param1:String) : void
      {
         if(this.curPage == this.curBookPagesIdx[param1])
         {
            this.curPage.isInPage = false;
            this.curPage.hasExitedPage = true;
            this.curPage.timeOnPageTracker.stop();
            this.curPage.duration = this.curPage.timeOnPageTracker.getElapsedTimeInMS();
            this.timeOnBook.stop();
            this.totalTimeOnBook = this.timeOnBook.getElapsedTimeInMS();
            ++this.curPage.exits;
            if(!this.curPage.hasCompletedPage)
            {
               this.curPage.incompleteView = true;
            }
            if(this.curPage.isLastPage)
            {
            }
            this.lastPage = this.curPage;
            this.curPage = null;
         }
         this.updateDetails();
      }
      
      public function enteredPage(param1:String) : void
      {
         var _loc2_:PageTrackInfo = this.curBookPagesIdx[param1];
         if(_loc2_)
         {
            if(this.lastPage != null && this.lastPage == _loc2_)
            {
               ++_loc2_.replayedPageImmediately;
            }
            _loc2_.timeOnPageTracker.start();
            this.timeOnBook.start();
            ++_loc2_.total_views;
            ++_loc2_.entries;
            _loc2_.hasEnteredPage = true;
            _loc2_.isInPage = true;
            if(_loc2_.id > this.farthestPageId)
            {
               this.farthestPageId = _loc2_.id;
            }
            this.curPage = _loc2_;
         }
      }
      
      public function mouseOverButton(param1:String, param2:String) : void
      {
      }
      
      public function completedPage(param1:String) : void
      {
         if(this.curPage == this.curBookPagesIdx[param1])
         {
            this.curPage.hasCompletedPage = true;
            if(!this.curPage.clickedButton)
            {
               this.curPage.autoplayed_fully = true;
            }
         }
      }
   }
}

