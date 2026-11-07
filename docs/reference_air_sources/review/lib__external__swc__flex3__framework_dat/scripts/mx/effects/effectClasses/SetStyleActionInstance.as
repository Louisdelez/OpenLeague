package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class SetStyleActionInstance extends ActionEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _value:*;
      
      public var name:String;
      
      public function SetStyleActionInstance(target:Object)
      {
         super(target);
      }
      
      public function get value() : *
      {
         if(mx_internal::playReversed)
         {
            return getStartValue();
         }
         return _value;
      }
      
      public function set value(val:*) : void
      {
         _value = val;
      }
      
      override public function play() : void
      {
         var currentValue:Object = null;
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
            currentValue = target.getStyle(name);
            if(currentValue is Number)
            {
               if(name.toLowerCase().indexOf("color") != -1)
               {
                  target.setStyle(name,StyleManager.getColorName(value));
               }
               else
               {
                  target.setStyle(name,Number(value));
               }
            }
            else if(currentValue is Boolean)
            {
               if(value is String)
               {
                  target.setStyle(name,value.toLowerCase() == "true");
               }
               else
               {
                  target.setStyle(name,value);
               }
            }
            else
            {
               target.setStyle(name,value);
            }
         }
         finishRepeat();
      }
      
      override protected function saveStartValue() : *
      {
         return target.getStyle(name);
      }
   }
}

