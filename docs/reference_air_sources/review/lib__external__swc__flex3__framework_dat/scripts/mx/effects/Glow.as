package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.GlowInstance;
   
   use namespace mx_internal;
   
   public class Glow extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var AFFECTED_PROPERTIES:Array = ["filters"];
      
      [Inspectable(defaultValue="false")]
      public var knockout:Boolean;
      
      [Inspectable(category="General",format="Color",defaultValue="0xFFFFFFFF")]
      public var color:uint = 4294967295;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var alphaFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var blurXTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var blurYTo:Number;
      
      [Inspectable(category="General",defaultValue="2")]
      public var strength:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var alphaTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var blurXFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var blurYFrom:Number;
      
      [Inspectable(category="General",defaultValue="false")]
      public var inner:Boolean;
      
      public function Glow(target:Object = null)
      {
         super(target);
         instanceClass = GlowInstance;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var glowInstance:GlowInstance = null;
         super.initInstance(instance);
         glowInstance = GlowInstance(instance);
         glowInstance.alphaFrom = alphaFrom;
         glowInstance.alphaTo = alphaTo;
         glowInstance.blurXFrom = blurXFrom;
         glowInstance.blurXTo = blurXTo;
         glowInstance.blurYFrom = blurYFrom;
         glowInstance.blurYTo = blurYTo;
         glowInstance.color = color;
         glowInstance.inner = inner;
         glowInstance.knockout = knockout;
         glowInstance.strength = strength;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
   }
}

