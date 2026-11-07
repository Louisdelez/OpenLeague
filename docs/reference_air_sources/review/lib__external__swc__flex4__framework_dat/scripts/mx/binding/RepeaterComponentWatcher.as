package mx.binding
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class RepeaterComponentWatcher extends PropertyWatcher
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var clones:Array;
      
      private var original:Boolean = true;
      
      public function RepeaterComponentWatcher(propertyName:String, events:Object, listeners:Array, propertyGetter:Function = null)
      {
         super(propertyName,events,listeners,propertyGetter);
      }
      
      override public function updateChildren() : void
      {
         if(this.original)
         {
            this.updateClones();
         }
         else
         {
            super.updateChildren();
         }
      }
      
      override protected function shallowClone() : Watcher
      {
         return new RepeaterComponentWatcher(propertyName,events,listeners,propertyGetter);
      }
      
      private function updateClones() : void
      {
         var i:int = 0;
         var clone:RepeaterComponentWatcher = null;
         var components:Array = value as Array;
         if(Boolean(components))
         {
            if(Boolean(this.clones))
            {
               this.clones = this.clones.splice(0,components.length);
            }
            else
            {
               this.clones = [];
            }
            for(i = 0; i < components.length; i++)
            {
               clone = RepeaterComponentWatcher(this.clones[i]);
               if(!clone)
               {
                  clone = RepeaterComponentWatcher(deepClone(i));
                  clone.original = false;
                  this.clones[i] = clone;
               }
               clone.value = components[i];
               clone.updateChildren();
            }
         }
      }
      
      override public function notifyListeners(commitEvent:Boolean) : void
      {
         var i:int = 0;
         if(this.original)
         {
            if(Boolean(this.clones))
            {
               for(i = 0; i < this.clones.length; i++)
               {
                  RepeaterComponentWatcher(this.clones[i]).notifyListeners(commitEvent);
               }
            }
         }
         super.notifyListeners(commitEvent);
      }
   }
}

