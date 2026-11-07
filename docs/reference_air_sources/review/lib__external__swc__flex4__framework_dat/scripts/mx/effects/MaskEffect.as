package mx.effects
{
   import flash.events.EventDispatcher;
   import mx.core.mx_internal;
   import mx.effects.effectClasses.MaskEffectInstance;
   import mx.events.TweenEvent;
   
   use namespace mx_internal;
   
   [Event(name="tweenEnd",type="mx.events.TweenEvent")]
   [Event(name="tweenUpdate",type="mx.events.TweenEvent")]
   [Event(name="tweenStart",type="mx.events.TweenEvent")]
   public class MaskEffect extends Effect
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["visible"];
      
      public var createMaskFunction:Function;
      
      public var moveEasingFunction:Function;
      
      [Inspectable(category="General",format="Boolean",defaultValue="false")]
      mx_internal var persistAfterEnd:Boolean = false;
      
      public var scaleEasingFunction:Function;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleXFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleXTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleYFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleYTo:Number;
      
      private var _showTarget:Boolean = true;
      
      private var _showExplicitlySet:Boolean = false;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var xFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var xTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var yFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var yTo:Number;
      
      public function MaskEffect(target:Object = null)
      {
         super(target);
         instanceClass = MaskEffectInstance;
         this.hideFocusRing = true;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get showTarget() : Boolean
      {
         return this._showTarget;
      }
      
      public function set showTarget(value:Boolean) : void
      {
         this._showTarget = value;
         this._showExplicitlySet = true;
      }
      
      override public function set hideFocusRing(value:Boolean) : void
      {
         super.hideFocusRing = value;
      }
      
      override public function get hideFocusRing() : Boolean
      {
         return super.hideFocusRing;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var maskEffectInstance:MaskEffectInstance = null;
         super.initInstance(instance);
         maskEffectInstance = MaskEffectInstance(instance);
         if(this._showExplicitlySet)
         {
            maskEffectInstance.showTarget = this.showTarget;
         }
         maskEffectInstance.xFrom = this.xFrom;
         maskEffectInstance.yFrom = this.yFrom;
         maskEffectInstance.xTo = this.xTo;
         maskEffectInstance.yTo = this.yTo;
         maskEffectInstance.scaleXFrom = this.scaleXFrom;
         maskEffectInstance.scaleXTo = this.scaleXTo;
         maskEffectInstance.scaleYFrom = this.scaleYFrom;
         maskEffectInstance.scaleYTo = this.scaleYTo;
         maskEffectInstance.moveEasingFunction = this.moveEasingFunction;
         maskEffectInstance.scaleEasingFunction = this.scaleEasingFunction;
         maskEffectInstance.createMaskFunction = this.createMaskFunction;
         maskEffectInstance.persistAfterEnd = this.persistAfterEnd;
         EventDispatcher(maskEffectInstance).addEventListener(TweenEvent.TWEEN_START,this.tweenEventHandler);
         EventDispatcher(maskEffectInstance).addEventListener(TweenEvent.TWEEN_UPDATE,this.tweenEventHandler);
         EventDispatcher(maskEffectInstance).addEventListener(TweenEvent.TWEEN_END,this.tweenEventHandler);
      }
      
      protected function tweenEventHandler(event:TweenEvent) : void
      {
         dispatchEvent(event);
      }
   }
}

