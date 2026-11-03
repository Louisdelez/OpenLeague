package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.gameclient.domain.inventory.RuneBookUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.spellbook.SpellBookDTO")]
   public class SpellBookDTO extends AbstractBook implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SpellBookDTO()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removePage(param1:SpellBookPageDTO) : void
      {
         var _loc2_:int = int(this.bookPages.getItemIndex(param1));
         if(_loc2_ >= 0)
         {
            this.bookPages.removeItemAt(_loc2_);
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      private function localizePageNames() : void
      {
         var _loc1_:SpellBookPageDTO = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc2_:ArrayCollection = new ArrayCollection();
         for each(_loc1_ in _bookPages)
         {
            _loc2_.addItem(_loc1_.name);
         }
         _loc3_ = 1;
         for each(_loc1_ in _bookPages)
         {
            if(_loc1_.name.indexOf(RuneBookUtils.PAGE_NAME_TOKEN) >= 0)
            {
               _loc1_.name = _loc3_.toString();
               _loc4_ = _loc1_.name;
               _loc5_ = 1;
               while(_loc2_.getItemIndex(_loc1_.name) >= 0)
               {
                  _loc1_.name = _loc4_ + "(" + _loc5_ + ")";
                  _loc5_++;
               }
            }
            _loc3_++;
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function addPage(param1:SpellBookPageDTO) : void
      {
         var _loc4_:SpellBookPageDTO = null;
         var _loc2_:int = int(this.bookPages.length);
         var _loc3_:int = 0;
         while(_loc3_ < this.bookPages.length)
         {
            _loc4_ = this.bookPages[_loc3_] as SpellBookPageDTO;
            if(param1.pageId < _loc4_.pageId)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         this.bookPages.addItemAt(param1,_loc2_);
      }
      
      public function get bookPages() : ArrayCollection
      {
         return _bookPages;
      }
      
      private function set _437083024defaultPage(param1:SpellBookPageDTO) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:SpellBookPageDTO = this.defaultPage;
         if(_loc2_ != null)
         {
            _loc2_.current = false;
         }
         param1.current = true;
      }
      
      public function replacePage(param1:SpellBookPageDTO, param2:SpellBookPageDTO) : void
      {
         var _loc3_:int = int(this.bookPages.getItemIndex(param1));
         if(_loc3_ >= 0)
         {
            this.bookPages.setItemAt(param2,_loc3_);
         }
      }
      
      public function getPageWithId(param1:Number) : SpellBookPageDTO
      {
         var _loc3_:SpellBookPageDTO = null;
         var _loc2_:SpellBookPageDTO = null;
         for each(_loc3_ in this.bookPages)
         {
            if(_loc3_.pageId == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      [Bindable(event="propertyChange")]
      public function set defaultPage(param1:SpellBookPageDTO) : void
      {
         var _loc2_:Object = this.defaultPage;
         if(_loc2_ !== param1)
         {
            this._437083024defaultPage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"defaultPage",_loc2_,param1));
         }
      }
      
      private function set _2010394203bookPages(param1:ArrayCollection) : void
      {
         _bookPages = param1;
         this.sortSpellBook();
         this.localizePageNames();
      }
      
      [Bindable(event="propertyChange")]
      public function set bookPages(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.bookPages;
         if(_loc2_ !== param1)
         {
            this._2010394203bookPages = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bookPages",_loc2_,param1));
         }
      }
      
      public function get defaultPage() : SpellBookPageDTO
      {
         var _loc2_:SpellBookPageDTO = null;
         var _loc1_:SpellBookPageDTO = null;
         for each(_loc2_ in this.bookPages)
         {
            if(_loc2_.current)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      private function sortSpellBook() : void
      {
         this.bookPages.sort = sortByPageId;
         this.bookPages.refresh();
      }
      
      public function hasPageNamed(param1:String) : Boolean
      {
         var _loc3_:SpellBookPageDTO = null;
         var _loc2_:Boolean = false;
         for each(_loc3_ in this.bookPages)
         {
            if(_loc3_.name == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
   }
}

