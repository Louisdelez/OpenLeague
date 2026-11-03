package mx.effects.effectClasses
{
   import flash.events.Event;
   import mx.containers.Panel;
   import mx.core.Application;
   import mx.core.Container;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   import mx.events.EffectEvent;
   import mx.events.ResizeEvent;
   import mx.styles.IStyleClient;
   
   use namespace mx_internal;
   
   public class ResizeInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var left:*;
      
      private var origPercentHeight:Number;
      
      private var parentOrigHorizontalScrollPolicy:String = "";
      
      private var explicitWidthSet:Boolean;
      
      public var widthFrom:Number;
      
      private var origExplicitHeight:Number;
      
      private var _widthTo:Number;
      
      private var parentOrigVerticalScrollPolicy:String = "";
      
      private var right:*;
      
      private var origExplicitWidth:Number;
      
      private var restoreAutoLayoutArray:Array;
      
      private var restoreVisibleArray:Array;
      
      private var bottom:*;
      
      private var heightSet:Boolean;
      
      private var _heightBy:Number;
      
      private var widthSet:Boolean;
      
      private var origHorizontalScrollPolicy:String = "";
      
      private var numHideEffectsPlaying:Number = 0;
      
      private var top:*;
      
      private var origVerticalScrollPolicy:String = "";
      
      private var _heightTo:Number;
      
      private var explicitHeightSet:Boolean;
      
      public var hideChildrenTargets:Array;
      
      private var origPercentWidth:Number;
      
      public var heightFrom:Number;
      
      private var _widthBy:Number;
      
      public function ResizeInstance(target:Object)
      {
         super(target);
         mx_internal::needToLayout = true;
      }
      
      public function set widthBy(value:Number) : void
      {
         _widthBy = value;
         widthSet = !isNaN(value);
      }
      
      public function get heightTo() : Number
      {
         return _heightTo;
      }
      
      public function set heightTo(value:Number) : void
      {
         _heightTo = value;
         heightSet = !isNaN(value);
      }
      
      private function hidePanelChildren() : Boolean
      {
         var p:Object = null;
         var prevNumHideEffectsPlaying:Number = NaN;
         if(!hideChildrenTargets)
         {
            return false;
         }
         restoreVisibleArray = [];
         restoreAutoLayoutArray = [];
         var n:int = int(hideChildrenTargets.length);
         for(var i:int = 0; i < n; i++)
         {
            p = hideChildrenTargets[i];
            if(p is Panel)
            {
               prevNumHideEffectsPlaying = numHideEffectsPlaying;
               p.addEventListener(EffectEvent.EFFECT_START,eventHandler);
               p.dispatchEvent(new Event("resizeStart"));
               p.removeEventListener(EffectEvent.EFFECT_START,eventHandler);
               if(numHideEffectsPlaying == prevNumHideEffectsPlaying)
               {
                  makePanelChildrenInvisible(Panel(p),i);
               }
            }
         }
         return numHideEffectsPlaying > 0;
      }
      
      override public function play() : void
      {
         super.play();
         calculateExplicitDimensionChanges();
         var childrenHiding:Boolean = hidePanelChildren();
         if(target is IStyleClient)
         {
            left = target.getStyle("left");
            if(left != undefined)
            {
               target.setStyle("left",undefined);
            }
            right = target.getStyle("right");
            if(right != undefined)
            {
               target.setStyle("right",undefined);
            }
            top = target.getStyle("top");
            if(top != undefined)
            {
               target.setStyle("top",undefined);
            }
            bottom = target.getStyle("bottom");
            if(bottom != undefined)
            {
               target.setStyle("bottom",undefined);
            }
         }
         if(!childrenHiding)
         {
            startResizeTween();
         }
      }
      
      public function set heightBy(value:Number) : void
      {
         _heightBy = value;
         heightSet = !isNaN(value);
      }
      
      override public function initEffect(event:Event) : void
      {
         super.initEffect(event);
         if(event is ResizeEvent && event.type == ResizeEvent.RESIZE)
         {
            if(isNaN(widthBy))
            {
               if(isNaN(widthFrom))
               {
                  widthFrom = ResizeEvent(event).oldWidth;
               }
               if(isNaN(widthTo))
               {
                  _widthTo = target.width;
               }
            }
            if(isNaN(heightBy))
            {
               if(isNaN(heightFrom))
               {
                  heightFrom = ResizeEvent(event).oldHeight;
               }
               if(isNaN(heightTo))
               {
                  _heightTo = target.height;
               }
            }
         }
      }
      
      public function get widthBy() : Number
      {
         return _widthBy;
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
      
      override mx_internal function eventHandler(event:Event) : void
      {
         var n:int = 0;
         var i:int = 0;
         var panel:Container = event.target as Container;
         super.mx_internal::eventHandler(event);
         if(event.type == EffectEvent.EFFECT_START)
         {
            panel.addEventListener(EffectEvent.EFFECT_END,eventHandler);
            ++numHideEffectsPlaying;
         }
         else if(event.type == EffectEvent.EFFECT_END)
         {
            panel.removeEventListener(EffectEvent.EFFECT_END,eventHandler);
            n = int(hideChildrenTargets.length);
            for(i = 0; i < n; i++)
            {
               if(hideChildrenTargets[i] == panel)
               {
                  break;
               }
            }
            makePanelChildrenInvisible(panel,i);
            if(--numHideEffectsPlaying == 0)
            {
               startResizeTween();
            }
         }
      }
      
      public function set widthTo(value:Number) : void
      {
         _widthTo = value;
         widthSet = !isNaN(value);
      }
      
      private function calculateExplicitDimensionChanges() : void
      {
         var targetAsContainer:Container = null;
         var parentAsContainer:Container = null;
         var explicitWidth:* = Boolean(propertyChanges) ? propertyChanges.end["explicitWidth"] : undefined;
         var explicitHeight:* = Boolean(propertyChanges) ? propertyChanges.end["explicitHeight"] : undefined;
         var percentWidth:* = Boolean(propertyChanges) ? propertyChanges.end["percentWidth"] : undefined;
         var percentHeight:* = Boolean(propertyChanges) ? propertyChanges.end["percentHeight"] : undefined;
         if(!heightSet)
         {
            if(percentHeight !== undefined)
            {
               origPercentHeight = percentHeight;
            }
            else
            {
               origPercentHeight = target.percentHeight;
            }
            if(isNaN(origPercentHeight))
            {
               if(explicitHeight !== undefined)
               {
                  origExplicitHeight = explicitHeight;
               }
               else
               {
                  origExplicitHeight = target.explicitHeight;
               }
            }
            targetAsContainer = target as Container;
            if(Boolean(targetAsContainer) && targetAsContainer.verticalScrollBar == null)
            {
               origVerticalScrollPolicy = targetAsContainer.verticalScrollPolicy;
               targetAsContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            }
            if(Boolean(target.parent))
            {
               parentAsContainer = target.parent as Container;
               if(Boolean(parentAsContainer) && parentAsContainer.verticalScrollBar == null)
               {
                  parentOrigVerticalScrollPolicy = parentAsContainer.verticalScrollPolicy;
                  parentAsContainer.verticalScrollPolicy = ScrollPolicy.OFF;
               }
            }
         }
         if(!widthSet)
         {
            if(percentWidth !== undefined)
            {
               origPercentWidth = percentWidth;
            }
            else
            {
               origPercentWidth = target.percentWidth;
            }
            if(isNaN(origPercentWidth))
            {
               if(explicitWidth !== undefined)
               {
                  origExplicitWidth = explicitWidth;
               }
               else
               {
                  origExplicitWidth = target.explicitWidth;
               }
            }
            targetAsContainer = target as Container;
            if(Boolean(targetAsContainer) && targetAsContainer.horizontalScrollBar == null)
            {
               origHorizontalScrollPolicy = targetAsContainer.horizontalScrollPolicy;
               targetAsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            }
            if(Boolean(target.parent))
            {
               parentAsContainer = target.parent as Container;
               if(Boolean(parentAsContainer) && parentAsContainer.horizontalScrollBar == null)
               {
                  parentOrigHorizontalScrollPolicy = parentAsContainer.horizontalScrollPolicy;
                  parentAsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
               }
            }
         }
         if(isNaN(widthFrom))
         {
            widthFrom = !isNaN(widthTo) && !isNaN(widthBy) ? widthTo - widthBy : Number(target.width);
         }
         if(isNaN(widthTo))
         {
            if(Boolean(isNaN(widthBy)) && Boolean(propertyChanges) && (propertyChanges.end["width"] !== undefined || explicitWidth !== undefined))
            {
               if(explicitWidth !== undefined && !isNaN(explicitWidth))
               {
                  explicitWidthSet = true;
                  _widthTo = explicitWidth;
               }
               else
               {
                  _widthTo = propertyChanges.end["width"];
               }
            }
            else
            {
               _widthTo = !isNaN(widthBy) ? widthFrom + widthBy : Number(target.width);
            }
         }
         if(isNaN(heightFrom))
         {
            heightFrom = !isNaN(heightTo) && !isNaN(heightBy) ? heightTo - heightBy : Number(target.height);
         }
         if(isNaN(heightTo))
         {
            if(Boolean(isNaN(heightBy)) && Boolean(propertyChanges) && (propertyChanges.end["height"] !== undefined || explicitHeight !== undefined))
            {
               if(explicitHeight !== undefined && !isNaN(explicitHeight))
               {
                  explicitHeightSet = true;
                  _heightTo = explicitHeight;
               }
               else
               {
                  _heightTo = propertyChanges.end["height"];
               }
            }
            else
            {
               _heightTo = !isNaN(heightBy) ? heightFrom + heightBy : Number(target.height);
            }
         }
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
         restoreVisibleArray[panelIndex] = childArray;
         if(panel.autoLayout)
         {
            panel.autoLayout = false;
            restoreAutoLayoutArray[panelIndex] = true;
         }
      }
      
      override public function end() : void
      {
         if(!tween)
         {
            calculateExplicitDimensionChanges();
            onTweenEnd(playReversed ? [widthFrom,heightFrom] : [widthTo,heightTo]);
         }
         super.end();
      }
      
      private function startResizeTween() : void
      {
         EffectManager.startVectorEffect(IUIComponent(target));
         tween = createTween(this,[widthFrom,heightFrom],[widthTo,heightTo],duration);
         applyTweenStartValues();
      }
      
      public function get heightBy() : Number
      {
         return _heightBy;
      }
      
      private function restorePanelChildren() : void
      {
         var n:int = 0;
         var i:int = 0;
         var p:IUIComponent = null;
         var childArray:Array = null;
         var m:int = 0;
         var j:int = 0;
         if(Boolean(hideChildrenTargets))
         {
            n = int(hideChildrenTargets.length);
            for(i = 0; i < n; i++)
            {
               p = hideChildrenTargets[i];
               childArray = restoreVisibleArray[i];
               if(Boolean(childArray))
               {
                  m = int(childArray.length);
                  for(j = 0; j < m; j++)
                  {
                     childArray[j].setVisible(true,true);
                  }
               }
               if(Boolean(restoreAutoLayoutArray[i]))
               {
                  Container(p).autoLayout = true;
               }
               p.dispatchEvent(new Event("resizeEnd"));
            }
         }
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         var targetAsContainer:Container = null;
         var parentAsContainer:Container = null;
         EffectManager.endVectorEffect(IUIComponent(target));
         Application.application.callLater(restorePanelChildren);
         super.onTweenEnd(value);
         EffectManager.suspendEventHandling();
         if(!heightSet)
         {
            target.percentHeight = origPercentHeight;
            target.explicitHeight = origExplicitHeight;
            if(origVerticalScrollPolicy != "")
            {
               targetAsContainer = target as Container;
               if(Boolean(targetAsContainer))
               {
                  targetAsContainer.verticalScrollPolicy = origVerticalScrollPolicy;
                  origVerticalScrollPolicy = "";
               }
            }
            if(parentOrigVerticalScrollPolicy != "" && Boolean(target.parent))
            {
               parentAsContainer = target.parent as Container;
               if(Boolean(parentAsContainer))
               {
                  parentAsContainer.verticalScrollPolicy = parentOrigVerticalScrollPolicy;
                  parentOrigVerticalScrollPolicy = "";
               }
            }
         }
         if(!widthSet)
         {
            target.percentWidth = origPercentWidth;
            target.explicitWidth = origExplicitWidth;
            if(origHorizontalScrollPolicy != "")
            {
               targetAsContainer = target as Container;
               if(Boolean(targetAsContainer))
               {
                  targetAsContainer.horizontalScrollPolicy = origHorizontalScrollPolicy;
                  origHorizontalScrollPolicy = "";
               }
            }
            if(parentOrigHorizontalScrollPolicy != "" && Boolean(target.parent))
            {
               parentAsContainer = target.parent as Container;
               if(Boolean(parentAsContainer))
               {
                  parentAsContainer.horizontalScrollPolicy = parentOrigHorizontalScrollPolicy;
                  parentOrigHorizontalScrollPolicy = "";
               }
            }
         }
         if(left != undefined)
         {
            target.setStyle("left",left);
         }
         if(right != undefined)
         {
            target.setStyle("right",right);
         }
         if(top != undefined)
         {
            target.setStyle("top",top);
         }
         if(bottom != undefined)
         {
            target.setStyle("bottom",bottom);
         }
         EffectManager.resumeEventHandling();
      }
      
      public function get widthTo() : Number
      {
         return _widthTo;
      }
   }
}

