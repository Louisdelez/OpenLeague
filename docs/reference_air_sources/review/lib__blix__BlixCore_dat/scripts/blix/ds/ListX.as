package blix.ds
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public class ListX extends Proxy implements IListX, IDestructible
   {
      
      protected var _reset:Signal = new Signal();
      
      protected var _itemsRemoved:Signal = new Signal();
      
      protected var _itemsAdded:Signal = new Signal();
      
      protected var _itemsUpdated:Signal = new Signal();
      
      protected var source:Object;
      
      public function ListX(param1:Object = null)
      {
         super();
         this.setSource(param1);
      }
      
      public function getSource() : Object
      {
         return this.source;
      }
      
      public function setSource(param1:Object) : void
      {
         this.source = param1 || [];
         this._reset.dispatch(this);
      }
      
      public function getReset() : ISignal
      {
         return this._reset;
      }
      
      public function getItemsUpdated() : ISignal
      {
         return this._itemsUpdated;
      }
      
      public function getItemsAdded() : ISignal
      {
         return this._itemsAdded;
      }
      
      public function getItemsRemoved() : ISignal
      {
         return this._itemsRemoved;
      }
      
      public function addItem(param1:Object) : void
      {
         this.source[this.source.length] = param1;
         if(this._itemsAdded.getHasListeners())
         {
            this._itemsAdded.dispatch(this,[param1]);
         }
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         this.source.splice(param2,0,param1);
         if(this._itemsAdded.getHasListeners())
         {
            this._itemsAdded.dispatch(this,[param1]);
         }
      }
      
      public function setItemAt(param1:Object, param2:int) : void
      {
         var _loc3_:Object = this.source[param2];
         if(_loc3_ != null && this._itemsRemoved.getHasListeners())
         {
            this._itemsRemoved.dispatch(this,[_loc3_]);
         }
         this.source[param2] = param1;
         if(param1 != null && this._itemsAdded.getHasListeners())
         {
            this._itemsAdded.dispatch(this,[param1]);
         }
      }
      
      public function getItemAt(param1:int) : Object
      {
         return this.source[param1];
      }
      
      public function getItemIndex(param1:Object, param2:int = 0) : int
      {
         return this.source.indexOf(param1,param2);
      }
      
      public function removeItem(param1:Object) : Boolean
      {
         var _loc2_:int = int(this.source.indexOf(param1));
         if(_loc2_ == -1)
         {
            return false;
         }
         if(this._itemsRemoved.getHasListeners())
         {
            this._itemsRemoved.dispatch(this,[param1]);
         }
         this.source.splice(_loc2_,1);
         return true;
      }
      
      public function removeItemAt(param1:int) : Object
      {
         var _loc3_:Object = null;
         var _loc2_:Object = this.source.splice(param1,1);
         if(_loc2_.length > 0)
         {
            _loc3_ = _loc2_[0];
            if(this._itemsRemoved.getHasListeners())
            {
               this._itemsRemoved.dispatch(this,[_loc3_]);
            }
            return _loc3_;
         }
         return null;
      }
      
      public function updateItems(param1:Array) : void
      {
         this._itemsUpdated.dispatch(this,param1);
      }
      
      public function removeAll() : void
      {
         this.source.length = 0;
         this._reset.dispatch(this);
      }
      
      public function getLength() : uint
      {
         return this.source.length;
      }
      
      public function setLength(param1:uint) : void
      {
         var _loc2_:* = undefined;
         if(this._itemsRemoved.getHasListeners())
         {
            _loc2_ = this.source.splice(param1,this.source.length - param1);
            if(_loc2_ is Array)
            {
               this._itemsRemoved.dispatch(this,_loc2_);
            }
            else if(Boolean(_loc2_.hasOwnProperty("toArray")))
            {
               this._itemsRemoved.dispatch(this,_loc2_.toArray());
            }
         }
         else
         {
            this.source.length = param1;
         }
      }
      
      public function getIterator(param1:int = -1) : IIterator
      {
         return new Iterator(this,param1);
      }
      
      public function toArray() : Array
      {
         var _loc1_:uint = 0;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(this.source is Array)
         {
            return (this.source as Array).slice();
         }
         if(this.source.hasOwnProperty("toArray"))
         {
            return this.source.toArray();
         }
         _loc1_ = this.getLength();
         _loc2_ = new Array(_loc1_);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_[_loc3_] = this.source[_loc3_];
            _loc3_++;
         }
         return _loc2_;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return param1 in this.source;
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         if(param1 in this.source)
         {
            this.setItemAt(null,param1);
            return true;
         }
         return false;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         return this.source[param1].apply(null,rest);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this.source[param1];
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         this.setItemAt(param2,param1);
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         if(param1 >= this.source.length)
         {
            return 0;
         }
         return param1 + 1;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return String(param1 - 1);
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         return this.source[param1 - 1];
      }
      
      public function destroy() : void
      {
         this._reset.removeAll();
         this._itemsRemoved.removeAll();
         this._itemsAdded.removeAll();
         this._itemsUpdated.removeAll();
         this.source = [];
      }
      
      public function toString() : String
      {
         return "[ListX " + String(this.source) + "]";
      }
   }
}

