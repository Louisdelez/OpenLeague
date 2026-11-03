package mx.effects.effectClasses
{
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class SetStyleActionInstance extends ActionEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public var name:String;
      
      private var _value:*;
      
      public function SetStyleActionInstance(target:Object)
      {
         super(target);
      }
      
      public function get value() : *
      {
         if(playReversed)
         {
            return getStartValue();
         }
         return this._value;
      }
      
      public function set value(val:*) : void
      {
         this._value = val;
      }
      
      override public function play() : void
      {
         var currentValue:Object = null;
         var moduleFactory:IFlexModuleFactory = null;
         super.play();
         if(this.value === undefined && Boolean(propertyChanges))
         {
            if(this.name in propertyChanges.end && propertyChanges.start[this.name] != propertyChanges.end[this.name])
            {
               this.value = propertyChanges.end[this.name];
            }
         }
         if(Boolean(target) && Boolean(this.name) && this.value !== undefined)
         {
            currentValue = target.getStyle(this.name);
            if(currentValue is Number)
            {
               if(this.name.toLowerCase().indexOf("color") != -1)
               {
                  moduleFactory = null;
                  if(target is IFlexModule)
                  {
                     moduleFactory = target.moduleFactory;
                  }
                  target.setStyle(this.name,StyleManager.getStyleManager(moduleFactory).getColorName(this.value));
               }
               else
               {
                  target.setStyle(this.name,Number(this.value));
               }
            }
            else if(currentValue is Boolean)
            {
               if(this.value is String)
               {
                  target.setStyle(this.name,this.value.toLowerCase() == "true");
               }
               else
               {
                  target.setStyle(this.name,this.value);
               }
            }
            else
            {
               target.setStyle(this.name,this.value);
            }
         }
         finishRepeat();
      }
      
      override protected function saveStartValue() : *
      {
         return target.getStyle(this.name);
      }
   }
}

