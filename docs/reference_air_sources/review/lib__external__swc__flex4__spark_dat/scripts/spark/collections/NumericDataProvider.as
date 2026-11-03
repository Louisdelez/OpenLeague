package spark.collections
{
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.OnDemandEventDispatcher;
   
   public class NumericDataProvider extends OnDemandEventDispatcher implements IList
   {
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _maximum:Number = 100;
      
      private var _minimum:Number = 0;
      
      private var _stepSize:Number = 1;
      
      public function NumericDataProvider()
      {
         super();
      }
      
      public function get length() : int
      {
         this.normalizeMinMax();
         return (this._maximum - this._minimum) / Math.abs(this.stepSize) + 1;
      }
      
      public function get maximum() : Number
      {
         this.normalizeMinMax();
         return this._maximum;
      }
      
      public function set maximum(value:Number) : void
      {
         if(this._maximum == value)
         {
            return;
         }
         this._maximum = value;
         this.reset();
      }
      
      public function get minimum() : Number
      {
         this.normalizeMinMax();
         return this._minimum;
      }
      
      public function set minimum(value:Number) : void
      {
         if(this._minimum == value)
         {
            return;
         }
         this._minimum = value;
         this.reset();
      }
      
      public function get stepSize() : Number
      {
         return this._stepSize;
      }
      
      public function set stepSize(value:Number) : void
      {
         var message:String = null;
         if(this._stepSize == value)
         {
            return;
         }
         if(value == 0)
         {
            message = this.resourceManager.getString("collections","stepSizeError");
            throw new Error(message);
         }
         this._stepSize = value;
         this.reset();
      }
      
      public function addItem(item:Object) : void
      {
         var message:String = this.resourceManager.getString("collections","addItemError");
         throw new Error(message);
      }
      
      public function addItemAt(item:Object, index:int) : void
      {
         var message:String = this.resourceManager.getString("collections","addItemAtError");
         throw new Error(message);
      }
      
      public function getItemAt(index:int, prefetch:int = 0) : Object
      {
         var value:Number = NaN;
         var message:String = null;
         var parts:Array = null;
         if(index < 0 || index >= this.length)
         {
            message = this.resourceManager.getString("collections","outOfBounds",[index]);
            throw new RangeError(message);
         }
         var scale:Number = 1;
         var scaledStepSize:Number = this.stepSize;
         var baseValue:Number = this.stepSize > 0 ? this.minimum : this.maximum;
         if(this.stepSize != Math.round(this.stepSize))
         {
            parts = new String(1 + this.stepSize).split(".");
            scale = Math.pow(10,parts[1].length);
            scaledStepSize = Math.round(this.stepSize * scale);
            value = Math.round(index * scaledStepSize) / scale;
         }
         else
         {
            value = index * this.stepSize;
         }
         return Math.min(Math.max(value + baseValue,this.minimum),this.maximum);
      }
      
      public function getItemIndex(item:Object) : int
      {
         var baseValue:Number = this.stepSize > 0 ? this.minimum : this.maximum;
         return Math.max(Math.min((Number(item) - baseValue) / this.stepSize,this.length - 1),0);
      }
      
      public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null) : void
      {
         var message:String = this.resourceManager.getString("collections","itemUpdatedError");
         throw new Error(message);
      }
      
      public function removeAll() : void
      {
         var message:String = this.resourceManager.getString("collections","removeAllError");
         throw new Error(message);
      }
      
      public function removeItemAt(index:int) : Object
      {
         var message:String = this.resourceManager.getString("collections","removeItemAtError");
         throw new Error(message);
      }
      
      public function setItemAt(item:Object, index:int) : Object
      {
         var message:String = this.resourceManager.getString("collections","setItemAtError");
         throw new Error(message);
      }
      
      public function toArray() : Array
      {
         var result:Array = [];
         var numItems:int = this.length;
         var baseValue:Number = this.stepSize > 0 ? this.minimum : this.maximum;
         for(var i:int = 0; i < numItems; i++)
         {
            result.push(Math.min(Math.max(baseValue + i * this.stepSize,this.minimum),this.maximum));
         }
         return result;
      }
      
      private function normalizeMinMax() : void
      {
         if(this._minimum > this._maximum)
         {
            this._maximum = this._minimum;
         }
      }
      
      private function reset() : void
      {
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.RESET;
         dispatchEvent(event);
      }
   }
}

