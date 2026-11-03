package mx.states
{
   import mx.core.mx_internal;
   import mx.effects.IEffect;
   
   use namespace mx_internal;
   
   [DefaultProperty("effect")]
   public class Transition
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var effect:IEffect;
      
      [Inspectable(category="General")]
      public var toState:String = "*";
      
      [Inspectable(category="General")]
      public var fromState:String = "*";
      
      public function Transition()
      {
         super();
      }
   }
}

