package spark.effects
{
   import mx.effects.Effect;
   import mx.effects.IEffectInstance;
   import spark.effects.supportClasses.CallActionInstance;
   
   [Exclude(name="duration",kind="property")]
   public class CallAction extends Effect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var functionName:String;
      
      public var args:Array;
      
      public function CallAction(target:Object = null)
      {
         super(target);
         duration = 0;
         instanceClass = CallActionInstance;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var callInstance:CallActionInstance = CallActionInstance(instance);
         callInstance.functionName = this.functionName;
         callInstance.args = this.args;
      }
   }
}

