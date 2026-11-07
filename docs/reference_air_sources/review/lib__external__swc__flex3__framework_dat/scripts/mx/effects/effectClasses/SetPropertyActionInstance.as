package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class SetPropertyActionInstance extends ActionEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _value:*;
      
      public var name:String;
      
      public function SetPropertyActionInstance(target:Object)
      {
         super(target);
      }
      
      public function get value() : *
      {
         var val:* = undefined;
         if(mx_internal::playReversed)
         {
            val = getStartValue();
            if(val != undefined)
            {
               return val;
            }
         }
         return _value;
      }
      
      public function set value(val:*) : void
      {
         _value = val;
      }
      
      override public function play() : void
      {
         var propName:String = null;
         var val:Object = null;
         super.play();
         if(value === undefined && Boolean(propertyChanges))
         {
            if(name in propertyChanges.end && propertyChanges.start[name] != propertyChanges.end[name])
            {
               value = propertyChanges.end[name];
            }
         }
         if(Boolean(target) && Boolean(name) && value !== undefined)
         {
            if(target[name] is Number)
            {
               propName = name;
               val = value;
               if(name == "width" || name == "height")
               {
                  if(val is String && val.indexOf("%") >= 0)
                  {
                     propName = name == "width" ? "percentWidth" : "percentHeight";
                     val = val.slice(0,val.indexOf("%"));
                  }
               }
               target[propName] = Number(val);
            }
            else if(target[name] is Boolean)
            {
               if(value is String)
               {
                  target[name] = value.toLowerCase() == "true";
               }
               else
               {
                  target[name] = value;
               }
            }
            else
            {
               target[name] = value;
            }
         }
         finishRepeat();
      }
      
      override protected function saveStartValue() : *
      {
         if(name != null)
         {
            try
            {
               return target[name];
            }
            catch(e:Error)
            {
            }
         }
         return undefined;
      }
   }
}

