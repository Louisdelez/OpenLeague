package mx.binding
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class RepeaterComponentWatcher extends PropertyWatcher
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var original:Boolean = true;
      
      private var clones:Array;
      
      public function RepeaterComponentWatcher(propertyName:String, events:Object, listeners:Array, propertyGetter:Function = null)
      {
         super(propertyName,events,listeners,propertyGetter);
      }
      
      override public function updateChildren() : void
      {
         if(original)
         {
            updateClones();
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
      
      override public function notifyListeners(commitEvent:Boolean) : void
      {
         var i:int = 0;
         if(original)
         {
            if(Boolean(clones))
            {
               for(i = 0; i < clones.length; i++)
               {
                  RepeaterComponentWatcher(clones[i]).notifyListeners(commitEvent);
               }
            }
         }
         super.notifyListeners(commitEvent);
      }
      
      private function updateClones() : void
      {
         var i:int = 0;
         var clone:RepeaterComponentWatcher = null;
         var components:Array = value as Array;
         if(Boolean(components))
         {
            if(Boolean(clones))
            {
               clones = clones.splice(0,components.length);
            }
            else
            {
               clones = [];
            }
            for(i = 0; i < components.length; i++)
            {
               clone = RepeaterComponentWatcher(clones[i]);
               if(!clone)
               {
                  clone = RepeaterComponentWatcher(deepClone(i));
                  clone.original = false;
                  clones[i] = clone;
               }
               clone.value = components[i];
               clone.updateChildren();
            }
         }
      }
   }
}

