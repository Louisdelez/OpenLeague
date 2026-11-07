package mx.binding
{
   import mx.collections.errors.ItemPendingError;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class Watcher
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      protected var listeners:Array;
      
      protected var children:Array;
      
      public var value:Object;
      
      protected var cloneIndex:int;
      
      public function Watcher(listeners:Array = null)
      {
         super();
         this.listeners = listeners;
      }
      
      public function updateParent(parent:Object) : void
      {
      }
      
      public function addChild(child:Watcher) : void
      {
         if(!this.children)
         {
            this.children = [child];
         }
         else
         {
            this.children.push(child);
         }
         child.updateParent(this);
      }
      
      public function removeChildren(startingIndex:int) : void
      {
         this.children.splice(startingIndex);
      }
      
      public function updateChildren() : void
      {
         var n:int = 0;
         var i:int = 0;
         if(Boolean(this.children))
         {
            n = int(this.children.length);
            for(i = 0; i < n; i++)
            {
               this.children[i].updateParent(this);
            }
         }
      }
      
      private function valueChanged(oldval:Object) : Boolean
      {
         if(oldval == null && this.value == null)
         {
            return false;
         }
         var valType:String = typeof this.value;
         if(valType == "string")
         {
            if(oldval == null && this.value == "")
            {
               return false;
            }
            return oldval != this.value;
         }
         if(valType == "number")
         {
            if(oldval == null && this.value == 0)
            {
               return false;
            }
            return oldval != this.value;
         }
         if(valType == "boolean")
         {
            if(oldval == null && this.value == false)
            {
               return false;
            }
            return oldval != this.value;
         }
         return true;
      }
      
      protected function wrapUpdate(wrappedFunction:Function) : void
      {
         try
         {
            wrappedFunction.apply(this);
         }
         catch(itemPendingError:ItemPendingError)
         {
            value = null;
         }
         catch(rangeError:RangeError)
         {
            value = null;
         }
         catch(error:Error)
         {
            if(error.errorID != 1006 && error.errorID != 1009 && error.errorID != 1010 && error.errorID != 1055 && error.errorID != 1069 && error.errorID != 1507)
            {
               throw error;
            }
         }
      }
      
      protected function deepClone(index:int) : Watcher
      {
         var n:int = 0;
         var i:int = 0;
         var clonedChild:Watcher = null;
         var w:Watcher = this.shallowClone();
         w.cloneIndex = index;
         if(Boolean(this.listeners))
         {
            w.listeners = this.listeners.concat();
         }
         if(Boolean(this.children))
         {
            n = int(this.children.length);
            for(i = 0; i < n; i++)
            {
               clonedChild = this.children[i].deepClone(index);
               w.addChild(clonedChild);
            }
         }
         return w;
      }
      
      protected function shallowClone() : Watcher
      {
         return new Watcher();
      }
      
      public function notifyListeners(commitEvent:Boolean) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(Boolean(this.listeners))
         {
            n = int(this.listeners.length);
            for(i = 0; i < n; i++)
            {
               this.listeners[i].watcherFired(commitEvent,this.cloneIndex);
            }
         }
      }
   }
}

