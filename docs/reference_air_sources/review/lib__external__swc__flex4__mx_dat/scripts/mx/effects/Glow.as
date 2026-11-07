package mx.effects
{
   import mx.core.FlexGlobals;
   import mx.effects.effectClasses.GlowInstance;
   import mx.styles.StyleManager;
   
   [Alternative(replacement="spark.effects.AnimateFilter",since="4.0")]
   public class Glow extends TweenEffect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["filters"];
      
      [Inspectable(category="General",defaultValue="1")]
      public var alphaFrom:Number = 1;
      
      [Inspectable(category="General",defaultValue="0")]
      public var alphaTo:Number = 0;
      
      [Inspectable(category="General",defaultValue="5")]
      public var blurXFrom:Number = 5;
      
      [Inspectable(category="General",defaultValue="0")]
      public var blurXTo:Number = 0;
      
      [Inspectable(category="General",defaultValue="5")]
      public var blurYFrom:Number = 5;
      
      [Inspectable(category="General",defaultValue="0")]
      public var blurYTo:Number = 0;
      
      [Inspectable(category="General",format="Color",defaultValue="0xFFFFFFFF")]
      public var color:uint = 4294967295;
      
      [Inspectable(category="General",defaultValue="false")]
      public var inner:Boolean;
      
      [Inspectable(defaultValue="false")]
      public var knockout:Boolean;
      
      [Inspectable(category="General",defaultValue="2")]
      public var strength:Number = 2;
      
      public function Glow(target:Object = null)
      {
         super(target);
         instanceClass = GlowInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var glowInstance:GlowInstance = GlowInstance(instance);
         glowInstance.alphaFrom = this.alphaFrom;
         glowInstance.alphaTo = this.alphaTo;
         glowInstance.blurXFrom = this.blurXFrom;
         glowInstance.blurXTo = this.blurXTo;
         glowInstance.blurYFrom = this.blurYFrom;
         glowInstance.blurYTo = this.blurYTo;
         glowInstance.color = this.color != StyleManager.NOT_A_COLOR ? this.color : uint(FlexGlobals.topLevelApplication.getStyle("themeColor"));
         glowInstance.inner = this.inner;
         glowInstance.knockout = this.knockout;
         glowInstance.strength = this.strength;
      }
   }
}

