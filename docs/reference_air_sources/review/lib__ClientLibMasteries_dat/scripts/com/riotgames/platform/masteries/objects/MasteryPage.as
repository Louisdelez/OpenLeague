package com.riotgames.platform.masteries.objects
{
   import com.riotgames.platform.gameclient.domain.MasteryBookPageDTO;
   import com.riotgames.platform.gameclient.masteries.TalentEntry;
   import com.riotgames.platform.masteries.events.MasteryEvent;
   import flash.events.EventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.utils.ObjectUtil;
   
   public class MasteryPage extends EventDispatcher
   {
      
      private var _pageDTO:MasteryBookPageDTO;
      
      private var _volatileEntries:ArrayCollection;
      
      private var _dirty:Boolean;
      
      private var _name:String = "";
      
      private var _index:int;
      
      public function MasteryPage(param1:MasteryBookPageDTO, param2:int)
      {
         super();
         this._pageDTO = param1;
         this._index = param2;
         this._name = this._pageDTO.name;
         this._volatileEntries = ObjectUtil.copy(this._pageDTO.talentEntries) as ArrayCollection;
         this._volatileEntries.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPageEntriesCollectionChange);
      }
      
      public function get isDirty() : Boolean
      {
         return this._dirty;
      }
      
      public function set isDirty(param1:Boolean) : void
      {
         if(this._dirty == param1)
         {
            return;
         }
         this._dirty = param1;
         this.dispatchEvent(new MasteryEvent(MasteryEvent.PAGE_DIRTY_CHANGED,true));
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         if(this._name == param1)
         {
            return;
         }
         this._name = param1;
         this.isDirty = true;
      }
      
      public function getEntries() : ArrayCollection
      {
         return this._volatileEntries;
      }
      
      public function set isCurrent(param1:Boolean) : void
      {
         this._pageDTO.current = param1;
      }
      
      public function get isCurrent() : Boolean
      {
         return this._pageDTO.current;
      }
      
      public function get rawDTO() : MasteryBookPageDTO
      {
         return this._pageDTO;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function savePageToDTO() : void
      {
         if(this.isDirty == false)
         {
            return;
         }
         this._pageDTO.name = this._name;
         this._pageDTO.talentEntries = ObjectUtil.copy(this._volatileEntries) as ArrayCollection;
         this.isDirty = false;
      }
      
      public function revertPageChanges() : void
      {
         if(this.isDirty == false)
         {
            return;
         }
         this._name = this._pageDTO.name;
         if(this._volatileEntries != null)
         {
            this._volatileEntries.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPageEntriesCollectionChange);
         }
         this._volatileEntries = ObjectUtil.copy(this._pageDTO.talentEntries) as ArrayCollection;
         this._volatileEntries.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPageEntriesCollectionChange);
         this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,false,CollectionEventKind.REPLACE));
         this.isDirty = false;
      }
      
      public function getRankOfMastery(param1:int) : int
      {
         var _loc2_:TalentEntry = this.getEntryByMasteryID(param1);
         if(_loc2_ != null)
         {
            return _loc2_.rank;
         }
         return 0;
      }
      
      public function getEntryByIndex(param1:int) : TalentEntry
      {
         if(this._volatileEntries == null)
         {
            return null;
         }
         return this._volatileEntries.getItemAt(param1) as TalentEntry;
      }
      
      public function addEntry(param1:TalentEntry) : void
      {
         if(this._volatileEntries == null)
         {
            this._volatileEntries = new ArrayCollection();
         }
         this._volatileEntries.addItem(param1);
      }
      
      public function getEntryByMasteryID(param1:int) : TalentEntry
      {
         var _loc3_:TalentEntry = null;
         if(this._volatileEntries == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._volatileEntries.length)
         {
            _loc3_ = this._volatileEntries.getItemAt(_loc2_) as TalentEntry;
            if(_loc3_ != null && _loc3_.talentId == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getNumberOfEntries() : int
      {
         if(this._volatileEntries == null)
         {
            return 0;
         }
         return this._volatileEntries.length;
      }
      
      public function getSpentPoints() : int
      {
         var _loc3_:TalentEntry = null;
         var _loc1_:int = 0;
         if(this._volatileEntries == null)
         {
            return _loc1_;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._volatileEntries.length)
         {
            _loc3_ = this._volatileEntries.getItemAt(_loc2_) as TalentEntry;
            if(_loc3_ != null)
            {
               _loc1_ += _loc3_.rank;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function onPageEntriesCollectionChange(param1:CollectionEvent) : void
      {
         this.isDirty = true;
         this.dispatchEvent(param1);
      }
   }
}

