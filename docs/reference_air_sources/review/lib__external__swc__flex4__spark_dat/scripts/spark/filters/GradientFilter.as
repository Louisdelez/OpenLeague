package spark.filters
{
   import flash.events.Event;
   import mx.events.PropertyChangeEvent;
   import mx.filters.BaseDimensionFilter;
   import mx.graphics.GradientEntry;
   
   [DefaultProperty("entries")]
   public class GradientFilter extends BaseDimensionFilter
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var colors:Array = [];
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var ratios:Array = [];
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var alphas:Array = [];
      
      private var _angle:Number = 45;
      
      private var _distance:Number = 4;
      
      private var _entries:Array = [];
      
      private var _type:String = "inner";
      
      public function GradientFilter(colors:Array = null, alphas:Array = null, ratios:Array = null)
      {
         var newEntry:GradientEntry = null;
         super();
         var newEntries:Array = [];
         var colorsLen:int = Boolean(colors) ? int(colors.length) : 0;
         var alphasLen:int = Boolean(alphas) ? int(alphas.length) : 0;
         var ratiosLen:int = Boolean(ratios) ? int(ratios.length) : 0;
         var maxLen:int = Math.max(colorsLen,alphasLen,ratiosLen);
         for(var i:int = 0; i < maxLen; i++)
         {
            newEntry = new GradientEntry();
            if(colorsLen > i)
            {
               newEntry.color = colors[i];
            }
            if(alphasLen > i)
            {
               newEntry.alpha = alphas[i];
            }
            if(ratiosLen > i)
            {
               newEntry.ratio = ratios[i];
            }
            newEntries.push(newEntry);
         }
         this.entries = newEntries;
      }
      
      public function get angle() : Number
      {
         return this._angle;
      }
      
      public function set angle(value:Number) : void
      {
         if(value != this._angle)
         {
            this._angle = value;
            notifyFilterChanged();
         }
      }
      
      public function get distance() : Number
      {
         return this._distance;
      }
      
      public function set distance(value:Number) : void
      {
         if(value != this._distance)
         {
            this._distance = value;
            notifyFilterChanged();
         }
      }
      
      [Inspectable(category="General",arrayType="mx.graphics.GradientEntry")]
      [Bindable("propertyChange")]
      public function get entries() : Array
      {
         return this._entries;
      }
      
      public function set entries(value:Array) : void
      {
         var oldValue:Array = this._entries;
         this._entries = value;
         this.processEntries();
         notifyFilterChanged();
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(value:String) : void
      {
         if(value != this._type)
         {
            this._type = value;
            notifyFilterChanged();
         }
      }
      
      private function processEntries() : void
      {
         var i:int = 0;
         var e:GradientEntry = null;
         var start:int = 0;
         var br:Number = NaN;
         var tr:Number = NaN;
         var j:int = 0;
         this.colors = [];
         this.ratios = [];
         this.alphas = [];
         if(!this._entries || this._entries.length == 0)
         {
            return;
         }
         var ratioConvert:Number = 255;
         var n:int = int(this._entries.length);
         for(i = 0; i < n; i++)
         {
            e = this._entries[i];
            e.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.entry_propertyChangeHandler,false,0,true);
            this.colors.push(e.color);
            this.alphas.push(e.alpha);
            this.ratios.push(e.ratio * ratioConvert);
         }
         if(isNaN(this.ratios[0]))
         {
            this.ratios[0] = 0;
         }
         if(isNaN(this.ratios[n - 1]))
         {
            this.ratios[n - 1] = 255;
         }
         i = 1;
         while(true)
         {
            while(i < n && !isNaN(this.ratios[i]))
            {
               i++;
            }
            if(i == n)
            {
               break;
            }
            start = i - 1;
            while(i < n && isNaN(this.ratios[i]))
            {
               i++;
            }
            br = Number(this.ratios[start]);
            tr = Number(this.ratios[i]);
            for(j = 1; j < i - start; j++)
            {
               this.ratios[j] = br + j * (tr - br) / (i - start);
            }
         }
      }
      
      private function entry_propertyChangeHandler(event:Event) : void
      {
         this.processEntries();
      }
   }
}

