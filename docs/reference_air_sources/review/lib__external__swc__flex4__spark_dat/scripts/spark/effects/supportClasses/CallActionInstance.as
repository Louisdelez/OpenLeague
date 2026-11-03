package spark.effects.supportClasses
{
   import mx.effects.effectClasses.ActionEffectInstance;
   
   public class CallActionInstance extends ActionEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var functionName:String;
      
      public var args:Array;
      
      public function CallActionInstance(target:Object)
      {
         super(target);
      }
      
      override public function play() : void
      {
         var theFunction:Function = null;
         super.play();
         if(Boolean(this.args))
         {
            theFunction = target[this.functionName];
            theFunction.apply(target,this.args);
         }
         else
         {
            target[this.functionName]();
         }
         finishRepeat();
      }
   }
}

