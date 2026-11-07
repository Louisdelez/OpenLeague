package mx.effects.effectClasses
{
   import flash.events.Event;
   import mx.containers.Panel;
   import mx.core.Container;
   import mx.core.FlexGlobals;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.effects.EffectManager;
   import mx.events.EffectEvent;
   import mx.events.ResizeEvent;
   import mx.styles.IStyleClient;
   
   public class ResizeInstance extends TweenEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var restoreVisibleArray:Array;
      
      private var restoreAutoLayoutArray:Array;
      
      private var numHideEffectsPlaying:Number = 0;
      
      private var origPercentHeight:Number;
      
      private var origPercentWidth:Number;
      
      private var origExplicitHeight:Number;
      
      private var origExplicitWidth:Number;
      
      private var heightSet:Boolean;
      
      private var widthSet:Boolean;
      
      private var explicitWidthSet:Boolean;
      
      private var explicitHeightSet:Boolean;
      
      private var origVerticalScrollPolicy:String = "";
      
      private var origHorizontalScrollPolicy:String = "";
      
      private var parentOrigVerticalScrollPolicy:String = "";
      
      private var parentOrigHorizontalScrollPolicy:String = "";
      
      private var left:*;
      
      private var right:*;
      
      private var top:*;
      
      private var bottom:*;
      
      private var _heightBy:Number;
      
      public var heightFrom:Number;
      
      private var _heightTo:Number;
      
      public var hideChildrenTargets:Array;
      
      private var _widthBy:Number;
      
      public var widthFrom:Number;
      
      private var _widthTo:Number;
      
      public function ResizeInstance(target:Object)
      {
         super(target);
         needToLayout = true;
      }
      
      public function get heightBy() : Number
      {
         return this._heightBy;
      }
      
      public function set heightBy(value:Number) : void
      {
         this._heightBy = value;
         this.heightSet = !isNaN(value);
      }
      
      public function get heightTo() : Number
      {
         return this._heightTo;
      }
      
      public function set heightTo(value:Number) : void
      {
         this._heightTo = value;
         this.heightSet = !isNaN(value);
      }
      
      public function get widthBy() : Number
      {
         return this._widthBy;
      }
      
      public function set widthBy(value:Number) : void
      {
         this._widthBy = value;
         this.widthSet = !isNaN(value);
      }
      
      public function get widthTo() : Number
      {
         return this._widthTo;
      }
      
      public function set widthTo(value:Number) : void
      {
         this._widthTo = value;
         this.widthSet = !isNaN(value);
      }
      
      override public function initEffect(event:Event) : void
      {
         super.initEffect(event);
         if(event is ResizeEvent && event.type == ResizeEvent.RESIZE)
         {
            if(isNaN(this.widthBy))
            {
               if(isNaN(this.widthFrom))
               {
                  this.widthFrom = ResizeEvent(event).oldWidth;
               }
               if(isNaN(this.widthTo))
               {
                  this._widthTo = target.width;
               }
            }
            if(isNaN(this.heightBy))
            {
               if(isNaN(this.heightFrom))
               {
                  this.heightFrom = ResizeEvent(event).oldHeight;
               }
               if(isNaN(this.heightTo))
               {
                  this._heightTo = target.height;
               }
            }
         }
      }
      
      override public function play() : void
      {
         super.play();
         this.calculateExplicitDimensionChanges();
         var childrenHiding:Boolean = this.hidePanelChildren();
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
         }
         if(!childrenHiding)
         {
            this.startResizeTween();
         }
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         EffectManager.suspendEventHandling();
         target.width = Math.round(value[0]);
         target.height = Math.round(value[1]);
         if(Boolean(tween))
         {
            tween.needToLayout = true;
         }
         needToLayout = true;
         EffectManager.resumeEventHandling();
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         var targetAsContainer:Container = null;
         var parentAsContainer:Container = null;
         EffectManager.endVectorEffect(IUIComponent(target));
         FlexGlobals.topLevelApplication.callLater(this.restorePanelChildren);
         super.onTweenEnd(value);
         EffectManager.suspendEventHandling();
         if(!this.heightSet)
         {
            target.percentHeight = this.origPercentHeight;
            target.explicitHeight = this.origExplicitHeight;
            if(this.origVerticalScrollPolicy != "")
            {
               targetAsContainer = target as Container;
               if(Boolean(targetAsContainer))
               {
                  targetAsContainer.verticalScrollPolicy = this.origVerticalScrollPolicy;
                  this.origVerticalScrollPolicy = "";
               }
            }
            if(this.parentOrigVerticalScrollPolicy != "" && Boolean(target.parent))
            {
               parentAsContainer = target.parent as Container;
               if(Boolean(parentAsContainer))
               {
                  parentAsContainer.verticalScrollPolicy = this.parentOrigVerticalScrollPolicy;
                  this.parentOrigVerticalScrollPolicy = "";
               }
            }
         }
         if(!this.widthSet)
         {
            target.percentWidth = this.origPercentWidth;
            target.explicitWidth = this.origExplicitWidth;
            if(this.origHorizontalScrollPolicy != "")
            {
               targetAsContainer = target as Container;
               if(Boolean(targetAsContainer))
               {
                  targetAsContainer.horizontalScrollPolicy = this.origHorizontalScrollPolicy;
                  this.origHorizontalScrollPolicy = "";
               }
            }
            if(this.parentOrigHorizontalScrollPolicy != "" && Boolean(target.parent))
            {
               parentAsContainer = target.parent as Container;
               if(Boolean(parentAsContainer))
               {
                  parentAsContainer.horizontalScrollPolicy = this.parentOrigHorizontalScrollPolicy;
                  this.parentOrigHorizontalScrollPolicy = "";
               }
            }
         }
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
         EffectManager.resumeEventHandling();
      }
      
      override public function end() : void
      {
         if(!tween)
         {
            this.calculateExplicitDimensionChanges();
            this.onTweenEnd(playReversed ? [this.widthFrom,this.heightFrom] : [this.widthTo,this.heightTo]);
         }
         super.end();
      }
      
      private function startResizeTween() : void
      {
         EffectManager.startVectorEffect(IUIComponent(target));
         tween = createTween(this,[this.widthFrom,this.heightFrom],[this.widthTo,this.heightTo],duration);
         applyTweenStartValues();
      }
      
      private function hidePanelChildren() : Boolean
      {
         var p:Object = null;
         var prevNumHideEffectsPlaying:Number = NaN;
         if(!this.hideChildrenTargets)
         {
            return false;
         }
         this.restoreVisibleArray = [];
         this.restoreAutoLayoutArray = [];
         var n:int = int(this.hideChildrenTargets.length);
         for(var i:int = 0; i < n; i++)
         {
            p = this.hideChildrenTargets[i];
            if(p is Panel)
            {
               prevNumHideEffectsPlaying = this.numHideEffectsPlaying;
               p.addEventListener(EffectEvent.EFFECT_START,this.eventHandler);
               p.dispatchEvent(new Event("resizeStart"));
               p.removeEventListener(EffectEvent.EFFECT_START,this.eventHandler);
               if(this.numHideEffectsPlaying == prevNumHideEffectsPlaying)
               {
                  this.makePanelChildrenInvisible(Panel(p),i);
               }
            }
         }
         return this.numHideEffectsPlaying > 0;
      }
      
      private function makePanelChildrenInvisible(panel:Container, panelIndex:Number) : void
      {
         var child:IUIComponent = null;
         var childArray:Array = [];
         var n:int = panel.numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = IUIComponent(panel.getChildAt(i));
            if(child.visible)
            {
               childArray.push(child);
               child.setVisible(false,true);
            }
         }
         child = panel.horizontalScrollBar;
         if(Boolean(child) && Boolean(child.visible))
         {
            childArray.push(child);
            child.setVisible(false,true);
         }
         child = panel.verticalScrollBar;
         if(Boolean(child) && Boolean(child.visible))
         {
            childArray.push(child);
            child.setVisible(false,true);
         }
         this.restoreVisibleArray[panelIndex] = childArray;
         if(panel.autoLayout)
         {
            panel.autoLayout = false;
            this.restoreAutoLayoutArray[panelIndex] = true;
         }
      }
      
      private function calculateExplicitDimensionChanges() : void
      {
         var targetAsContainer:Container = null;
         var parentAsContainer:Container = null;
         var explicitWidth:* = Boolean(propertyChanges) ? propertyChanges.end["explicitWidth"] : undefined;
         var explicitHeight:* = Boolean(propertyChanges) ? propertyChanges.end["explicitHeight"] : undefined;
         var percentWidth:* = Boolean(propertyChanges) ? propertyChanges.end["percentWidth"] : undefined;
         var percentHeight:* = Boolean(propertyChanges) ? propertyChanges.end["percentHeight"] : undefined;
         if(!this.heightSet)
         {
            if(percentHeight !== undefined)
            {
               this.origPercentHeight = percentHeight;
            }
            else
            {
               this.origPercentHeight = target.percentHeight;
            }
            if(isNaN(this.origPercentHeight))
            {
               if(explicitHeight !== undefined)
               {
                  this.origExplicitHeight = explicitHeight;
               }
               else
               {
                  this.origExplicitHeight = target.explicitHeight;
               }
            }
            targetAsContainer = target as Container;
            if(Boolean(targetAsContainer) && targetAsContainer.verticalScrollBar == null)
            {
               this.origVerticalScrollPolicy = targetAsContainer.verticalScrollPolicy;
               targetAsContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            }
            if(Boolean(target.parent))
            {
               parentAsContainer = target.parent as Container;
               if(Boolean(parentAsContainer) && parentAsContainer.verticalScrollBar == null)
               {
                  this.parentOrigVerticalScrollPolicy = parentAsContainer.verticalScrollPolicy;
                  parentAsContainer.verticalScrollPolicy = ScrollPolicy.OFF;
               }
            }
         }
         if(!this.widthSet)
         {
            if(percentWidth !== undefined)
            {
               this.origPercentWidth = percentWidth;
            }
            else
            {
               this.origPercentWidth = target.percentWidth;
            }
            if(isNaN(this.origPercentWidth))
            {
               if(explicitWidth !== undefined)
               {
                  this.origExplicitWidth = explicitWidth;
               }
               else
               {
                  this.origExplicitWidth = target.explicitWidth;
               }
            }
            targetAsContainer = target as Container;
            if(Boolean(targetAsContainer) && targetAsContainer.horizontalScrollBar == null)
            {
               this.origHorizontalScrollPolicy = targetAsContainer.horizontalScrollPolicy;
               targetAsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            }
            if(Boolean(target.parent))
            {
               parentAsContainer = target.parent as Container;
               if(Boolean(parentAsContainer) && parentAsContainer.horizontalScrollBar == null)
               {
                  this.parentOrigHorizontalScrollPolicy = parentAsContainer.horizontalScrollPolicy;
                  parentAsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
               }
            }
         }
         if(isNaN(this.widthFrom))
         {
            if(!isNaN(this.widthTo) && !isNaN(this.widthBy))
            {
               this.widthFrom = this.widthTo - this.widthBy;
            }
            else if(Boolean(propertyChanges) && propertyChanges.start["width"] != undefined)
            {
               this.widthFrom = propertyChanges.start["width"];
            }
            else
            {
               this.widthFrom = target.width;
            }
         }
         if(isNaN(this.widthTo))
         {
            if(Boolean(isNaN(this.widthBy)) && Boolean(propertyChanges) && (propertyChanges.end["width"] !== undefined || explicitWidth !== undefined))
            {
               if(explicitWidth !== undefined && !isNaN(explicitWidth))
               {
                  this.explicitWidthSet = true;
                  this._widthTo = explicitWidth;
               }
               else
               {
                  this._widthTo = propertyChanges.end["width"];
               }
            }
            else
            {
               this._widthTo = !isNaN(this.widthBy) ? this.widthFrom + this.widthBy : Number(target.width);
            }
         }
         if(isNaN(this.heightFrom))
         {
            if(!isNaN(this.heightTo) && !isNaN(this.heightBy))
            {
               this.heightFrom = this.heightTo - this.heightBy;
            }
            else if(Boolean(propertyChanges) && propertyChanges.start["height"] != undefined)
            {
               this.heightFrom = propertyChanges.start["height"];
            }
            else
            {
               this.heightFrom = target.height;
            }
         }
         if(isNaN(this.heightTo))
         {
            if(Boolean(isNaN(this.heightBy)) && Boolean(propertyChanges) && (propertyChanges.end["height"] !== undefined || explicitHeight !== undefined))
            {
               if(explicitHeight !== undefined && !isNaN(explicitHeight))
               {
                  this.explicitHeightSet = true;
                  this._heightTo = explicitHeight;
               }
               else
               {
                  this._heightTo = propertyChanges.end["height"];
               }
            }
            else
            {
               this._heightTo = !isNaN(this.heightBy) ? this.heightFrom + this.heightBy : Number(target.height);
            }
         }
      }
      
      private function restorePanelChildren() : void
      {
         var n:int = 0;
         var i:int = 0;
         var p:IUIComponent = null;
         var childArray:Array = null;
         var m:int = 0;
         var j:int = 0;
         if(Boolean(this.hideChildrenTargets))
         {
            n = int(this.hideChildrenTargets.length);
            for(i = 0; i < n; i++)
            {
               p = this.hideChildrenTargets[i];
               childArray = this.restoreVisibleArray[i];
               if(Boolean(childArray))
               {
                  m = int(childArray.length);
                  for(j = 0; j < m; j++)
                  {
                     childArray[j].setVisible(true,true);
                  }
               }
               if(Boolean(this.restoreAutoLayoutArray[i]))
               {
                  Container(p).autoLayout = true;
               }
               p.dispatchEvent(new Event("resizeEnd"));
            }
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function eventHandler(event:Event) : void
      {
         var n:int = 0;
         var i:int = 0;
         var panel:Container = event.target as Container;
         super.eventHandler(event);
         if(event.type == EffectEvent.EFFECT_START)
         {
            panel.addEventListener(EffectEvent.EFFECT_END,this.eventHandler);
            ++this.numHideEffectsPlaying;
         }
         else if(event.type == EffectEvent.EFFECT_END)
         {
            panel.removeEventListener(EffectEvent.EFFECT_END,this.eventHandler);
            n = int(this.hideChildrenTargets.length);
            for(i = 0; i < n; i++)
            {
               if(this.hideChildrenTargets[i] == panel)
               {
                  break;
               }
            }
            this.makePanelChildrenInvisible(panel,i);
            if(--this.numHideEffectsPlaying == 0)
            {
               this.startResizeTween();
            }
         }
      }
   }
}

