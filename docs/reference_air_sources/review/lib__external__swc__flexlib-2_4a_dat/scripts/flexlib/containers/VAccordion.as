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
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   [IconFile("VAccordion.png")]
   public class VAccordion extends AccordionBase
   {
      
      initializeStyles();
      
      [Inspectable(enumeration="below,above",defaultValue="above")]
      public var headerLocation:String = AccordionHeaderLocation.ABOVE;
      
      public function VAccordion()
      {
         super();
      }
      
      private static function initializeStyles() : void
      {
         var selector:CSSStyleDeclaration = null;
         selector = StyleManager.getStyleDeclaration("VAccordion");
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
         StyleManager.setStyleDeclaration("VAccordion",selector,false);
      }
      
      override protected function measure() : void
      {
         var minWidth:Number = NaN;
         var minHeight:Number = NaN;
         var preferredWidth:Number = NaN;
         var preferredHeight:Number = NaN;
         var paddingLeft:Number = NaN;
         var paddingRight:Number = NaN;
         var headerHeight:Number = NaN;
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
         headerHeight = getHeaderHeight();
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
            minWidth = Math.max(minWidth,button.minWidth);
            minHeight += headerHeight;
            preferredWidth = Math.max(preferredWidth,minWidth);
            preferredHeight += headerHeight;
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
         var verticalGap:Number = NaN;
         var headerHeight:Number = NaN;
         var localContentWidth:Number = NaN;
         var localContentHeight:Number = NaN;
         var y:Number = NaN;
         var content:Container = null;
         var n:int = 0;
         var i:int = 0;
         var header:Button = null;
         bSliding = false;
         oldSelectedIndex = tweenOldSelectedIndex;
         vm = tweenViewMetrics;
         verticalGap = Number(getStyle("verticalGap"));
         headerHeight = getHeaderHeight();
         localContentWidth = calcContentWidth();
         localContentHeight = calcContentHeight();
         y = Number(vm.top);
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            header = getHeaderAt(i);
            if(headerLocation == AccordionHeaderLocation.ABOVE)
            {
               header.$y = y;
               y += headerHeight;
            }
            if(i == selectedIndex)
            {
               content = Container(getChildAt(i));
               content.cacheAsBitmap = false;
               content.scrollRect = null;
               content.visible = true;
               y += localContentHeight;
            }
            if(headerLocation == AccordionHeaderLocation.BELOW)
            {
               header.$y = y;
               y += headerHeight;
            }
            y += verticalGap;
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
      
      override protected function startTween(oldSelectedIndex:int, newSelectedIndex:int) : void
      {
         if(Boolean(tween))
         {
            tween.pause();
         }
         super.startTween(oldSelectedIndex,newSelectedIndex);
         invalidateSize();
         invalidateDisplayList();
         validateNow();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenUpdate(value:Number) : void
      {
         var vm:EdgeMetrics = null;
         var contentWidth:Number = NaN;
         var contentHeight:Number = NaN;
         var oldSelectedIndex:int = 0;
         var newSelectedIndex:int = 0;
         var newContentHeight:Number = NaN;
         var oldContentHeight:Number = NaN;
         var oldOffset:Number = NaN;
         var newOffset:Number = NaN;
         var y:Number = NaN;
         var verticalGap:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var header:Button = null;
         var content:Container = null;
         vm = tweenViewMetrics;
         contentWidth = tweenContentWidth;
         contentHeight = tweenContentHeight;
         oldSelectedIndex = tweenOldSelectedIndex;
         newSelectedIndex = tweenNewSelectedIndex;
         newContentHeight = value;
         oldContentHeight = contentHeight - value;
         oldOffset = oldSelectedIndex < newSelectedIndex ? -newContentHeight : newContentHeight;
         newOffset = newSelectedIndex > oldSelectedIndex ? oldContentHeight : -oldContentHeight;
         y = Number(vm.top);
         verticalGap = Number(getStyle("verticalGap"));
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            header = getHeaderAt(i);
            content = Container(getChildAt(i));
            if(headerLocation == AccordionHeaderLocation.ABOVE)
            {
               header.$y = y;
               y += header.height;
            }
            if(i == oldSelectedIndex)
            {
               content.cacheAsBitmap = true;
               content.scrollRect = new Rectangle(0,-oldOffset,contentWidth,contentHeight);
               content.visible = true;
               y += oldContentHeight;
            }
            else if(i == newSelectedIndex)
            {
               content.cacheAsBitmap = true;
               content.scrollRect = new Rectangle(0,-newOffset,contentWidth,contentHeight);
               content.visible = true;
               y += newContentHeight;
            }
            if(headerLocation == AccordionHeaderLocation.BELOW)
            {
               header.$y = y;
               y += header.height;
            }
            y += verticalGap;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var bm:EdgeMetrics = null;
         var paddingLeft:Number = NaN;
         var paddingRight:Number = NaN;
         var paddingTop:Number = NaN;
         var verticalGap:Number = NaN;
         var localContentWidth:Number = NaN;
         var localContentHeight:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         var contentX:Number = NaN;
         var adjContentWidth:Number = NaN;
         var headerHeight:Number = NaN;
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
         verticalGap = Number(getStyle("verticalGap"));
         localContentWidth = calcContentWidth();
         localContentHeight = calcContentHeight();
         x = bm.left + paddingLeft;
         y = bm.top + paddingTop;
         contentX = x;
         adjContentWidth = localContentWidth;
         headerHeight = getHeaderHeight();
         if(paddingLeft < 0)
         {
            contentX -= paddingLeft;
            adjContentWidth += paddingLeft;
         }
         if(paddingRight < 0)
         {
            adjContentWidth += paddingRight;
         }
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            header = getHeaderAt(i);
            content = IUIComponent(getChildAt(i));
            if(headerLocation != AccordionHeaderLocation.BELOW)
            {
               header.move(x,y);
               header.setActualSize(localContentWidth,headerHeight);
               y += headerHeight;
            }
            if(i == selectedIndex)
            {
               content.move(contentX,y);
               content.visible = true;
               contentW = adjContentWidth;
               contentH = localContentHeight;
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
               y += localContentHeight;
            }
            else
            {
               content.move(contentX,i < selectedIndex ? y : y - localContentHeight);
               content.visible = false;
            }
            if(headerLocation == AccordionHeaderLocation.BELOW)
            {
               header.move(x,y);
               header.setActualSize(localContentWidth,headerHeight);
               y += headerHeight;
            }
            y += verticalGap;
         }
         if(Boolean(blocker))
         {
            rawChildren.setChildIndex(blocker,numChildren - 1);
         }
         drawHeaderFocus(focusedIndex,showFocusIndicator);
      }
   }
}

