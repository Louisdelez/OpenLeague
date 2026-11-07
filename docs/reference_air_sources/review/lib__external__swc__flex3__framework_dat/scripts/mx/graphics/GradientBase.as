package mx.graphics
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   use namespace mx_internal;
   
   [DefaultProperty("entries")]
   public class GradientBase extends EventDispatcher
   {
      
      mx_internal var ratios:Array = [];
      
      mx_internal var colors:Array = [];
      
      private var _entries:Array = [];
      
      mx_internal var alphas:Array = [];
      
      public function GradientBase()
      {
         super();
      }
      
      public function set entries(value:Array) : void
      {
         var oldValue:Array = _entries;
         _entries = value;
         processEntries();
         dispatchGradientChangedEvent("entries",oldValue,value);
      }
      
      private function processEntries() : void
      {
         var i:int = 0;
         var e:GradientEntry = null;
         var start:int = 0;
         var br:Number = NaN;
         var tr:Number = NaN;
         var j:int = 0;
         colors = [];
         ratios = [];
         alphas = [];
         if(!_entries || _entries.length == 0)
         {
            return;
         }
         var ratioConvert:Number = 255;
         var n:int = int(_entries.length);
         for(i = 0; i < n; i++)
         {
            e = _entries[i];
            e.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,entry_propertyChangeHandler,false,0,true);
            colors.push(e.color);
            alphas.push(e.alpha);
            ratios.push(e.ratio * ratioConvert);
         }
         if(isNaN(ratios[0]))
         {
            ratios[0] = 0;
         }
         if(isNaN(ratios[n - 1]))
         {
            ratios[n - 1] = 255;
         }
         i = 1;
         while(true)
         {
            while(i < n && !isNaN(ratios[i]))
            {
               i++;
            }
            if(i == n)
            {
               break;
            }
            start = i - 1;
            while(i < n && isNaN(ratios[i]))
            {
               i++;
            }
            br = Number(ratios[start]);
            tr = Number(ratios[i]);
            for(j = 1; j < i - start; j++)
            {
               ratios[j] = br + j * (tr - br) / (i - start);
            }
         }
      }
      
      mx_internal function dispatchGradientChangedEvent(prop:String, oldValue:*, value:*) : void
      {
         dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,prop,oldValue,value));
      }
      
      private function entry_propertyChangeHandler(event:Event) : void
      {
         processEntries();
         dispatchGradientChangedEvent("entries",entries,entries);
      }
      
      [Inspectable(category="General",arrayType="mx.graphics.GradientEntry")]
      [Bindable("propertyChange")]
      public function get entries() : Array
      {
         return _entries;
      }
   }
}

