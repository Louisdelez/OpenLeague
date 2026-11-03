package mx.effects.effectClasses
{
   import flash.events.Event;
   import mx.core.EdgeMetrics;
   import mx.core.IContainer;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   import mx.events.MoveEvent;
   import mx.styles.IStyleClient;
   
   use namespace mx_internal;
   
   public class MoveInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var left:*;
      
      private var right:*;
      
      private var top:*;
      
      private var bottom:*;
      
      private var horizontalCenter:*;
      
      private var verticalCenter:*;
      
      private var forceClipping:Boolean = false;
      
      private var checkClipping:Boolean = true;
      
      private var oldWidth:Number;
      
      private var oldHeight:Number;
      
      public var xBy:Number;
      
      public var xFrom:Number;
      
      public var xTo:Number;
      
      public var yBy:Number;
      
      public var yFrom:Number;
      
      public var yTo:Number;
      
      public function MoveInstance(target:Object)
      {
         super(target);
      }
      
      override public function initEffect(event:Event) : void
      {
         super.initEffect(event);
         if(event is MoveEvent && event.type == MoveEvent.MOVE)
         {
            if(isNaN(this.xFrom) && isNaN(this.xTo) && isNaN(this.xBy) && isNaN(this.yFrom) && isNaN(this.yTo) && isNaN(this.yBy))
            {
               this.xFrom = MoveEvent(event).oldX;
               this.xTo = target.x;
               this.yFrom = MoveEvent(event).oldY;
               this.yTo = target.y;
            }
         }
      }
      
      override public function play() : void
      {
         var vm:EdgeMetrics = null;
         var l:Number = NaN;
         var r:Number = NaN;
         var t:Number = NaN;
         var b:Number = NaN;
         var w:Number = NaN;
         var h:Number = NaN;
         super.play();
         EffectManager.startBitmapEffect(IUIComponent(target));
         if(isNaN(this.xFrom))
         {
            this.xFrom = !isNaN(this.xTo) && !isNaN(this.xBy) ? this.xTo - this.xBy : Number(target.x);
         }
         if(isNaN(this.xTo))
         {
            if(Boolean(isNaN(this.xBy)) && Boolean(propertyChanges) && propertyChanges.end["x"] !== undefined)
            {
               this.xTo = propertyChanges.end["x"];
            }
            else
            {
               this.xTo = !isNaN(this.xBy) ? this.xFrom + this.xBy : Number(target.x);
            }
         }
         if(isNaN(this.yFrom))
         {
            this.yFrom = !isNaN(this.yTo) && !isNaN(this.yBy) ? this.yTo - this.yBy : Number(target.y);
         }
         if(isNaN(this.yTo))
         {
            if(Boolean(isNaN(this.yBy)) && Boolean(propertyChanges) && propertyChanges.end["y"] !== undefined)
            {
               this.yTo = propertyChanges.end["y"];
            }
            else
            {
               this.yTo = !isNaN(this.yBy) ? this.yFrom + this.yBy : Number(target.y);
            }
         }
         tween = createTween(this,[this.xFrom,this.yFrom],[this.xTo,this.yTo],duration);
         var p:IContainer = target.parent as IContainer;
         if(Boolean(p))
         {
            vm = p.viewMetrics;
            l = vm.left;
            r = p.width - vm.right;
            t = vm.top;
            b = p.height - vm.bottom;
            if(this.xFrom < l || this.xTo < l || this.xFrom + target.width > r || this.xTo + target.width > r || this.yFrom < t || this.yTo < t || this.yFrom + target.height > b || this.yTo + target.height > b)
            {
               this.forceClipping = true;
               if("forceClipping" in p)
               {
                  p["forceClipping"] = true;
               }
            }
         }
         applyTweenStartValues();
         if(target is IStyleClient)
         {
            this.left = target.getStyle("left");
            if(this.left != undefined)
            {
               target.setStyle("left",undefined);
            }
            this.right = target.getStyle("right");
            if(this.right != undefined)
            {
               target.setStyle("right",undefined);
            }
            this.top = target.getStyle("top");
            if(this.top != undefined)
            {
               target.setStyle("top",undefined);
            }
            this.bottom = target.getStyle("bottom");
            if(this.bottom != undefined)
            {
               target.setStyle("bottom",undefined);
            }
            this.horizontalCenter = target.getStyle("horizontalCenter");
            if(this.horizontalCenter != undefined)
            {
               target.setStyle("horizontalCenter",undefined);
            }
            this.verticalCenter = target.getStyle("verticalCenter");
            if(this.verticalCenter != undefined)
            {
               target.setStyle("verticalCenter",undefined);
            }
            if(this.left != undefined && this.right != undefined)
            {
               w = Number(target.width);
               this.oldWidth = target.explicitWidth;
               target.width = w;
            }
            if(this.top != undefined && this.bottom != undefined)
            {
               h = Number(target.height);
               this.oldHeight = target.explicitHeight;
               target.height = h;
            }
         }
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         var p:IContainer = null;
         var vm:EdgeMetrics = null;
         var l:Number = NaN;
         var r:Number = NaN;
         var t:Number = NaN;
         var b:Number = NaN;
         EffectManager.suspendEventHandling();
         if(!this.forceClipping && this.checkClipping)
         {
            p = target.parent as IContainer;
            if(Boolean(p))
            {
               vm = p.viewMetrics;
               l = vm.left;
               r = p.width - vm.right;
               t = vm.top;
               b = p.height - vm.bottom;
               if(value[0] < l || value[0] + target.width > r || value[1] < t || value[1] + target.height > b)
               {
                  this.forceClipping = true;
                  if("forceClipping" in p)
                  {
                     p["forceClipping"] = true;
                  }
               }
            }
         }
         target.move(value[0],value[1]);
         EffectManager.resumeEventHandling();
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         var p:IContainer = null;
         EffectManager.endBitmapEffect(IUIComponent(target));
         if(this.left != undefined)
         {
            target.setStyle("left",this.left);
         }
         if(this.right != undefined)
         {
            target.setStyle("right",this.right);
         }
         if(this.top != undefined)
         {
            target.setStyle("top",this.top);
         }
         if(this.bottom != undefined)
         {
            target.setStyle("bottom",this.bottom);
         }
         if(this.horizontalCenter != undefined)
         {
            target.setStyle("horizontalCenter",this.horizontalCenter);
         }
         if(this.verticalCenter != undefined)
         {
            target.setStyle("verticalCenter",this.verticalCenter);
         }
         if(this.left != undefined && this.right != undefined)
         {
            target.explicitWidth = this.oldWidth;
         }
         if(this.top != undefined && this.bottom != undefined)
         {
            target.explicitHeight = this.oldHeight;
         }
         if(this.forceClipping)
         {
            p = target.parent as IContainer;
            if(Boolean(p))
            {
               this.forceClipping = false;
               if("forceClipping" in p)
               {
                  p["forceClipping"] = false;
               }
            }
         }
         this.checkClipping = false;
         super.onTweenEnd(value);
      }
   }
}

