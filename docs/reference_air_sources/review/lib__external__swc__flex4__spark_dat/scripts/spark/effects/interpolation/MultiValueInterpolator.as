package spark.effects.interpolation
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("sparkEffects")]
   public class MultiValueInterpolator implements IInterpolator
   {
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _elementInterpolator:IInterpolator = NumberInterpolator.getInstance();
      
      public function MultiValueInterpolator(elementInterpolator:IInterpolator = null)
      {
         super();
         if(elementInterpolator != null)
         {
            this.elementInterpolator = elementInterpolator;
         }
      }
      
      public function get elementInterpolator() : IInterpolator
      {
         return this._elementInterpolator;
      }
      
      public function set elementInterpolator(value:IInterpolator) : void
      {
         this._elementInterpolator = Boolean(value) ? value : NumberInterpolator.getInstance();
      }
      
      public function interpolate(fraction:Number, startValue:Object, endValue:Object) : Object
      {
         var returnObject:Object = null;
         if(startValue.length != endValue.length)
         {
            throw new Error(this.resourceManager.getString("sparkEffects","arraysNotOfEqualLength"));
         }
         if(startValue is Array)
         {
            returnObject = [];
         }
         else
         {
            returnObject = startValue.splice(0,0);
         }
         for(var i:int = 0; i < startValue.length; i++)
         {
            returnObject[i] = this._elementInterpolator.interpolate(fraction,startValue[i],endValue[i]);
         }
         return returnObject;
      }
      
      public function increment(baseValue:Object, incrementValue:Object) : Object
      {
         var returnObject:Object = null;
         if(baseValue is Array)
         {
            returnObject = [];
         }
         else
         {
            returnObject = baseValue.splice(0,0);
         }
         for(var i:int = 0; i < baseValue.length; i++)
         {
            returnObject[i] = this._elementInterpolator.increment(baseValue[i],incrementValue);
         }
         return returnObject;
      }
      
      public function decrement(baseValue:Object, decrementValue:Object) : Object
      {
         var returnObject:Object = null;
         if(baseValue is Array)
         {
            returnObject = [];
         }
         else
         {
            returnObject = baseValue.splice(0,0);
         }
         for(var i:int = 0; i < baseValue.length; i++)
         {
            returnObject[i] = this._elementInterpolator.decrement(baseValue[i],decrementValue);
         }
         return returnObject;
      }
   }
}

