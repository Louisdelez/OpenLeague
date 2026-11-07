package com.riotgames.platform.masteries.objects
{
   import com.riotgames.platform.gameclient.domain.AbstractBook;
   import com.riotgames.platform.gameclient.domain.MasteryBookDTO;
   import com.riotgames.platform.gameclient.domain.MasteryBookPageDTO;
   import com.riotgames.platform.gameclient.masteries.TalentEntry;
   import com.riotgames.platform.masteries.events.MasteryEvent;
   import com.riotgames.platform.masteries.utilities.MasteriesUtils;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class MasteryBook extends EventDispatcher
   {
      
      public static var maxMasteryPagesAllowed:int = 10;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _bookDTO:MasteryBookDTO;
      
      private var _voPages:ArrayCollection;
      
      private var _totalPointsToSpend:int = 0;
      
      private var _currentPageIndex:int = -1;
      
      public function MasteryBook(param1:MasteryBookDTO)
      {
         var _loc4_:MasteryBookPageDTO = null;
         var _loc5_:MasteryPage = null;
         super();
         this._bookDTO = param1;
         this.sortMasteryBook();
         var _loc2_:ArrayCollection = new ArrayCollection();
         var _loc3_:int = 0;
         for each(_loc4_ in this._bookDTO.bookPages)
         {
            _loc5_ = new MasteryPage(_loc4_,_loc3_);
            _loc2_.addItem(_loc5_);
            _loc3_++;
         }
         this._voPages = _loc2_;
      }
      
      public function get isDirty() : Boolean
      {
         var _loc1_:MasteryPage = null;
         for each(_loc1_ in this._voPages)
         {
            if(_loc1_.isDirty)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get bookDTO() : MasteryBookDTO
      {
         return this._bookDTO;
      }
      
      public function get totalPointsToSpend() : int
      {
         return this._totalPointsToSpend;
      }
      
      public function set totalPointsToSpend(param1:int) : void
      {
         this._totalPointsToSpend = param1;
      }
      
      public function deleteCurrentPage() : Boolean
      {
         if(this._voPages.length == 1)
         {
            return false;
         }
         this._bookDTO.bookPages.removeItemAt(this._currentPageIndex);
         this._voPages.removeItemAt(this._currentPageIndex);
         if(this._currentPageIndex >= this._voPages.length)
         {
            this.currentPageIndex = this._voPages.length - 1;
         }
         else
         {
            this.currentPageIndex = this._currentPageIndex;
         }
         return true;
      }
      
      public function createPage() : Boolean
      {
         if(this._voPages.length >= maxMasteryPagesAllowed)
         {
            return false;
         }
         var _loc1_:MasteryBookPageDTO = new MasteryBookPageDTO();
         _loc1_.current = false;
         _loc1_.pageId = (this._bookDTO.bookPages.getItemAt(this._bookDTO.bookPages.length - 1) as MasteryBookPageDTO).pageId + 1;
         _loc1_.summonerId = (this._bookDTO.bookPages.getItemAt(this._bookDTO.bookPages.length - 1) as MasteryBookPageDTO).summonerId;
         _loc1_.name = AbstractBook.PAGE_NAME_TOKEN + _loc1_.pageId;
         this._bookDTO.bookPages.addItem(_loc1_);
         this._voPages.addItem(new MasteryPage(_loc1_,this._voPages.length));
         this._bookDTO.bookPages.refresh();
         this._voPages.refresh();
         this.currentPageIndex = this._voPages.length - 1;
         return true;
      }
      
      public function saveBook() : void
      {
         var _loc1_:MasteryPage = null;
         for each(_loc1_ in this._voPages)
         {
            _loc1_.savePageToDTO();
         }
      }
      
      public function revertBook() : void
      {
         var _loc1_:MasteryPage = null;
         for each(_loc1_ in this._voPages)
         {
            _loc1_.revertPageChanges();
         }
      }
      
      public function returnPointsFromCurrentPage() : void
      {
         if(Boolean(this.currentPage))
         {
            this.currentPage.getEntries().removeAll();
         }
      }
      
      public function returnPointsFromGroupOnCurrentPage(param1:uint) : void
      {
         var _loc3_:TalentEntry = null;
         var _loc2_:Array = new Array();
         if(Boolean(this.currentPage))
         {
            for each(_loc3_ in this.currentPage.getEntries())
            {
               if(MasteriesUtils.getMasteryByID(_loc3_.talentId).talentGroupId == param1)
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         for each(_loc3_ in _loc2_)
         {
            this.currentPage.getEntries().removeItemAt(this.currentPage.getEntries().getItemIndex(_loc3_));
         }
      }
      
      public function currentPageNameIsUnique() : Boolean
      {
         var _loc2_:MasteryPage = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._voPages)
         {
            if(_loc1_ != this._currentPageIndex)
            {
               if(this.currentPage.name == _loc2_.name)
               {
                  return false;
               }
            }
            _loc1_++;
         }
         return true;
      }
      
      public function get bookPages() : ArrayCollection
      {
         return this._voPages;
      }
      
      public function get currentPage() : MasteryPage
      {
         return this._voPages.getItemAt(this._currentPageIndex) as MasteryPage;
      }
      
      public function get currentPageIndex() : int
      {
         return this._currentPageIndex;
      }
      
      public function set currentPageIndex(param1:int) : void
      {
         if(param1 < 0 || param1 >= MasteryBook.maxMasteryPagesAllowed)
         {
            this.logger.warn("MasteryBook :: Tried to set currentPage to an invalid value.");
            return;
         }
         if(this._currentPageIndex >= 0 && this._currentPageIndex < this._voPages.length)
         {
            this.currentPage.isCurrent = false;
         }
         this._currentPageIndex = param1;
         this.currentPage.isCurrent = true;
         this.dispatchEvent(new MasteryEvent(MasteryEvent.CURRENT_PAGE_CHANGED,false,true,param1));
      }
      
      private function sortMasteryBook() : void
      {
         if(this._bookDTO.bookPages != null)
         {
            this._bookDTO.bookPages.sort = this._bookDTO.sortByPageId;
            this._bookDTO.bookPages.refresh();
         }
      }
      
      public function isEmpty() : Boolean
      {
         var _loc1_:MasteryPage = null;
         if(this.bookPages.length == 0)
         {
            return true;
         }
         if(this.bookPages.length == 1)
         {
            _loc1_ = this.currentPage;
            return _loc1_.getSpentPoints() == 0;
         }
         return false;
      }
   }
}

