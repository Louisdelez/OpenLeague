package flexlib.containers
{
   import flash.geom.Rectangle;
   import flexlib.baseClasses.AccordionBase;
   import flexlib.containers.accordionClasses.AccordionHeaderLocation;
   import mx.controls.Button;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.effects.Tween;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   [Exclude(name="headerHeight",kind="style")]
   [Style(name="headerWidth",type="Number",format="Length",inherit="no")]
   [Style(name="keepIconVertical",type="Boolean")]
   [IconFile("HAccordion.png")]
   public class HAccordion extends AccordionBase
   {
      
      initializeStyles();
      
      [Inspectable(enumeration="left,right",defaultValue="left")]
      public var headerLocation:String = AccordionHeaderLocation.LEFT;
      
      public function HAccordion()
      {
         super();
      }
      
      private static function initializeStyles() : void
      {
         var selector:CSSStyleDeclaration = null;
         selector = StyleManager.getStyleDeclaration("HAccordion");
         if(!selector)
         {
            selector = new CSSStyleDeclaration();
         }
         selector.defaultFactory = function():void
         {
            this.backgroundColor = 16777215;
            this.borderStyle = "solid";
            this.paddingBottom = -1;
            this.paddingLeft = -1;
            this.paddingRight = -1;
            this.paddingTop = -1;
            this.verticalGap = -1;
            this.horizontalGap = -1;
         };
         StyleManager.setStyleDeclaration("HAccordion",selector,false);
      }
      
      override protected function get contentWidth() : Number
      {
         var contentWidth:Number = NaN;
         var vm:EdgeMetrics = null;
         var horizontalGap:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         contentWidth = Number(unscaledWidth);
         vm = viewMetricsAndPadding;
         contentWidth -= vm.left + vm.right;
         horizontalGap = Number(getStyle("horizontalGap"));
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            contentWidth -= getHeaderAt(i).width;
            if(i > 0)
            {
               contentWidth -= horizontalGap;
            }
         }
         return contentWidth;
      }
      
      override protected function measure() : void
      {
         var minWidth:Number = NaN;
         var minHeight:Number = NaN;
         var preferredWidth:Number = NaN;
         var preferredHeight:Number = NaN;
         var paddingLeft:Number = NaN;
         var paddingRight:Number = NaN;
         var paddingTop:Number = NaN;
         var paddingBottom:Number = NaN;
         var headerWidth:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var vm:EdgeMetrics = null;
         var widthPadding:Number = NaN;
         var heightPadding:Number = NaN;
         var button:Button = null;
         var child:IUIComponent = null;
         super.measure();
         minWidth = 0;
         minHeight = 0;
         preferredWidth = 0;
         preferredHeight = 0;
         paddingLeft = Number(getStyle("paddingLeft"));
         paddingRight = Number(getStyle("paddingRight"));
         paddingTop = Number(getStyle("paddingTop"));
         paddingBottom = Number(getStyle("paddingBottom"));
         headerWidth = getHeaderWidth();
         if(Boolean(accPreferredWidth) && Boolean(!_resizeToContent) && !layoutStyleChanged)
         {
            measuredMinWidth = accMinWidth;
            measuredMinHeight = accMinHeight;
            measuredWidth = accPreferredWidth;
            measuredHeight = accPreferredHeight;
            return;
         }
         layoutStyleChanged = false;
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            button = getHeaderAt(i);
            child = IUIComponent(getChildAt(i));
            minWidth += headerWidth;
            minHeight = Math.max(minHeight,button.minHeight);
            preferredHeight = Math.max(preferredHeight,minHeight);
            preferredWidth += headerWidth;
            if(i == selectedIndex)
            {
               preferredWidth = Math.max(preferredWidth,child.getExplicitOrMeasuredWidth());
               preferredHeight += child.getExplicitOrMeasuredHeight();
               minWidth = Math.max(minWidth,child.minWidth);
               minHeight += child.minHeight;
            }
         }
         vm = viewMetricsAndPadding;
         widthPadding = vm.left + vm.right;
         heightPadding = vm.top + vm.bottom;
         if(paddingLeft < 0)
         {
            widthPadding -= paddingLeft;
         }
         if(paddingRight < 0)
         {
            widthPadding -= paddingRight;
         }
         minWidth += widthPadding;
         preferredWidth += widthPadding;
         minHeight += heightPadding;
         preferredHeight += heightPadding;
         measuredMinWidth = minWidth;
         measuredMinHeight = minHeight;
         measuredWidth = preferredWidth;
         measuredHeight = preferredHeight;
         if(Boolean(selectedChild) && Container(selectedChild).numChildrenCreated == -1)
         {
            return;
         }
         if(numChildren == 0)
         {
            return;
         }
         accMinWidth = minWidth;
         accMinHeight = minHeight;
         accPreferredWidth = preferredWidth;
         accPreferredHeight = preferredHeight;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenEnd(value:Number) : void
      {
         var oldSelectedIndex:int = 0;
         var vm:EdgeMetrics = null;
         var horizontalGap:Number = NaN;
         var headerWidth:Number = NaN;
         var localContentWidth:Number = NaN;
         var localContentHeight:Number = NaN;
         var x:Number = NaN;
         var content:Container = null;
         var n:int = 0;
         var i:int = 0;
         var header:Button = null;
         bSliding = false;
         oldSelectedIndex = tweenOldSelectedIndex;
         vm = tweenViewMetrics;
         horizontalGap = Number(getStyle("horizontalGap"));
         headerWidth = getHeaderWidth();
         localContentWidth = calcContentWidth();
         localContentHeight = calcContentHeight();
         x = Number(vm.left);
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            header = getHeaderAt(i);
            if(headerLocation != AccordionHeaderLocation.RIGHT)
            {
               header.$x = x;
               x += headerWidth;
            }
            if(i == selectedIndex)
            {
               content = Container(getChildAt(i));
               content.cacheAsBitmap = false;
               content.scrollRect = null;
               content.visible = true;
               x += localContentWidth;
            }
            if(headerLocation == AccordionHeaderLocation.RIGHT)
            {
               header.$x = x;
               x += headerWidth;
            }
            x += horizontalGap;
         }
         if(oldSelectedIndex != -1)
         {
            content = Container(getChildAt(oldSelectedIndex));
            content.cacheAsBitmap = false;
            content.scrollRect = null;
            content.visible = false;
            content.tweeningProperties = null;
         }
         tweenViewMetrics = null;
         tweenContentWidth = NaN;
         tweenContentHeight = NaN;
         tweenOldSelectedIndex = 0;
         tweenNewSelectedIndex = 0;
         tween = null;
         UIComponent.resumeBackgroundProcessing();
         Container(getChildAt(selectedIndex)).tweeningProperties = null;
         if(Boolean(currentDissolveEffect))
         {
            if(currentDissolveEffect.target != null)
            {
               currentDissolveEffect.play();
            }
            else
            {
               currentDissolveEffect.play([this]);
            }
         }
         callLater(instantiateSelectedChild);
      }
      
      override protected function getHeaderWidth() : Number
      {
         var headerWidth:Number = NaN;
         headerWidth = Number(getStyle("headerWidth"));
         if(isNaN(headerWidth))
         {
            headerWidth = 0;
            if(numChildren > 0)
            {
               headerWidth = Number(getHeaderAt(0).measuredHeight);
            }
         }
         return headerWidth;
      }
      
      override protected function calcContentHeight() : Number
      {
         var contentHeight:Number = NaN;
         var vm:EdgeMetrics = null;
         contentHeight = Number(unscaledHeight);
         vm = viewMetricsAndPadding;
         return contentHeight - (vm.top + vm.bottom);
      }
      
      override protected function get contentHeight() : Number
      {
         var contentHeight:Number = NaN;
         var vm:EdgeMetrics = null;
         contentHeight = Number(unscaledHeight);
         vm = viewMetricsAndPadding;
         contentHeight -= vm.top + vm.bottom;
         return contentHeight - (getStyle("paddingTop") + getStyle("paddingBottom"));
      }
      
      override protected function startTween(oldSelectedIndex:int, newSelectedIndex:int) : void
      {
         var openDuration:Number = NaN;
         var easingFunction:Function = null;
         var newSelectedChild:Container = null;
         var paddingTop:Number = NaN;
         var contentY:Number = NaN;
         bSliding = true;
         tweenViewMetrics = viewMetricsAndPadding;
         tweenContentWidth = calcContentWidth();
         tweenContentHeight = calcContentHeight();
         tweenOldSelectedIndex = oldSelectedIndex;
         tweenNewSelectedIndex = newSelectedIndex;
         openDuration = Number(getStyle("openDuration"));
         tween = new Tween(this,0,tweenContentWidth,openDuration);
         easingFunction = getStyle("openEasingFunction") as Function;
         if(easingFunction != null)
         {
            tween.easingFunction = easingFunction;
         }
         if(oldSelectedIndex != -1)
         {
            Container(getChildAt(oldSelectedIndex)).tweeningProperties = ["x","y","width","height"];
         }
         Container(getChildAt(newSelectedIndex)).tweeningProperties = ["x","y","width","height"];
         newSelectedChild = Container(getChildAt(newSelectedIndex));
         if(newSelectedChild.numChildren == 0)
         {
            paddingTop = Number(getStyle("paddingTop"));
            contentY = borderMetrics.top + (paddingTop > 0 ? paddingTop : 0);
            newSelectedChild.move(newSelectedChild.x,contentY);
            newSelectedChild.setActualSize(tweenContentWidth,tweenContentHeight);
         }
         UIComponent.suspendBackgroundProcessing();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenUpdate(value:Number) : void
      {
         var vm:EdgeMetrics = null;
         var contentWidth:Number = NaN;
         var contentHeight:Number = NaN;
         var oldSelectedIndex:int = 0;
         var newSelectedIndex:int = 0;
         var newContentWidth:Number = NaN;
         var oldContentWidth:Number = NaN;
         var oldOffset:Number = NaN;
         var newOffset:Number = NaN;
         var x:Number = NaN;
         var horizontalGap:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var header:Button = null;
         var content:Container = null;
         vm = tweenViewMetrics;
         contentWidth = tweenContentWidth;
         contentHeight = tweenContentHeight;
         oldSelectedIndex = tweenOldSelectedIndex;
         newSelectedIndex = tweenNewSelectedIndex;
         newContentWidth = value;
         oldContentWidth = contentWidth - value;
         oldOffset = oldSelectedIndex < newSelectedIndex ? -newContentWidth : newContentWidth;
         newOffset = newSelectedIndex > oldSelectedIndex ? oldContentWidth : -oldContentWidth;
         x = Number(vm.left);
         horizontalGap = Number(getStyle("horizontalGap"));
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            header = getHeaderAt(i);
            content = Container(getChildAt(i));
            if(headerLocation != AccordionHeaderLocation.RIGHT)
            {
               header.$x = x;
               x += header.height;
            }
            if(i == oldSelectedIndex)
            {
               content.cacheAsBitmap = true;
               content.scrollRect = new Rectangle(-oldOffset,0,contentWidth,contentHeight);
               content.visible = true;
               x += oldContentWidth;
            }
            else if(i == newSelectedIndex)
            {
               content.cacheAsBitmap = true;
               content.scrollRect = new Rectangle(-newOffset,0,contentWidth,contentHeight);
               content.visible = true;
               x += newContentWidth;
            }
            if(headerLocation == AccordionHeaderLocation.RIGHT)
            {
               header.$x = x;
               x += header.height;
            }
            x += horizontalGap;
         }
      }
      
      override protected function calcContentWidth() : Number
      {
         var contentWidth:Number = NaN;
         var vm:EdgeMetrics = null;
         var horizontalGap:Number = NaN;
         var headerWidth:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         contentWidth = Number(unscaledWidth);
         vm = viewMetricsAndPadding;
         contentWidth -= vm.left + vm.right;
         horizontalGap = Number(getStyle("horizontalGap"));
         headerWidth = getHeaderWidth();
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            contentWidth -= headerWidth;
            if(i > 0)
            {
               contentWidth -= horizontalGap;
            }
         }
         return contentWidth;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var bm:EdgeMetrics = null;
         var paddingLeft:Number = NaN;
         var paddingRight:Number = NaN;
         var paddingTop:Number = NaN;
         var paddingBottom:Number = NaN;
         var horizontalGap:Number = NaN;
         var localContentWidth:Number = NaN;
         var localContentHeight:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         var contentY:Number = NaN;
         var adjContentHeight:Number = NaN;
         var headerWidth:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var header:Button = null;
         var content:IUIComponent = null;
         var contentW:Number = NaN;
         var contentH:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(tween))
         {
            return;
         }
         bm = borderMetrics;
         paddingLeft = Number(getStyle("paddingLeft"));
         paddingRight = Number(getStyle("paddingRight"));
         paddingTop = Number(getStyle("paddingTop"));
         paddingBottom = Number(getStyle("paddingBottom"));
         horizontalGap = Number(getStyle("horizontalGap"));
         localContentWidth = calcContentWidth();
         localContentHeight = calcContentHeight();
         x = bm.left + paddingLeft;
         y = bm.top + paddingTop;
         contentY = y;
         adjContentHeight = localContentHeight;
         headerWidth = getHeaderWidth();
         if(paddingTop < 0)
         {
            contentY -= paddingTop;
            adjContentHeight += paddingTop;
         }
         if(paddingBottom < 0)
         {
            adjContentHeight += paddingBottom;
         }
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            header = getHeaderAt(i);
            content = IUIComponent(getChildAt(i));
            header.rotation = -90;
            if(headerLocation != AccordionHeaderLocation.RIGHT)
            {
               header.move(x,y + localContentHeight);
               header.setActualSize(localContentHeight,headerWidth);
               x += headerWidth;
            }
            if(i == selectedIndex)
            {
               content.move(x,contentY);
               content.visible = true;
               contentW = localContentWidth;
               contentH = adjContentHeight;
               if(!isNaN(content.percentWidth))
               {
                  if(contentW > content.maxWidth)
                  {
                     contentW = Number(content.maxWidth);
                  }
               }
               else if(contentW > content.getExplicitOrMeasuredWidth())
               {
                  contentW = Number(content.getExplicitOrMeasuredWidth());
               }
               if(!isNaN(content.percentHeight))
               {
                  if(contentH > content.maxHeight)
                  {
                     contentH = Number(content.maxHeight);
                  }
               }
               else if(contentH > content.getExplicitOrMeasuredHeight())
               {
                  contentH = Number(content.getExplicitOrMeasuredHeight());
               }
               if(content.width != contentW || content.height != contentH)
               {
                  content.setActualSize(contentW,contentH);
               }
               x += localContentWidth;
            }
            else
            {
               content.move(i < selectedIndex ? x : x - localContentWidth,contentY);
               content.visible = false;
            }
            if(headerLocation == AccordionHeaderLocation.RIGHT)
            {
               header.move(x,y + localContentHeight);
               header.setActualSize(localContentHeight,headerWidth);
               x += headerWidth;
            }
            x += horizontalGap;
         }
         if(Boolean(blocker))
         {
            rawChildren.setChildIndex(blocker,numChildren - 1);
         }
         drawHeaderFocus(focusedIndex,showFocusIndicator);
      }
   }
}

