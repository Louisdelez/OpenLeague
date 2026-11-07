package spark.effects.interpolation
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("sparkEffects")]
   public class NumberInterpolator implements IInterpolator
   {
      
      private static var theInstance:NumberInterpolator;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function NumberInterpolator()
      {
         super();
      }
      
      public static function getInstance() : NumberInterpolator
      {
         if(!theInstance)
         {
            theInstance = new NumberInterpolator();
         }
         return theInstance;
      }
      
      public function interpolate(fraction:Number, startValue:Object, endValue:Object) : Object
      {
         if(fraction == 0)
         {
            return startValue;
         }
         if(fraction == 1)
         {
            return endValue;
         }
         if(startValue is Number && isNaN(Number(startValue)) || endValue is Number && isNaN(Number(endValue)))
         {
            throw new Error(this.resourceManager.getString("sparkEffects","cannotCalculateValue",[startValue,endValue]));
         }
         return Number(startValue) + fraction * (Number(endValue) - Number(startValue));
      }
      
      public function increment(baseValue:Object, incrementValue:Object) : Object
      {
         return Number(baseValue) + Number(incrementValue);
      }
      
      public function decrement(baseValue:Object, decrementValue:Object) : Object
      {
         return Number(baseValue) - Number(decrementValue);
      }
   }
}

