package flexlib.containers.accordionClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flexlib.controls.CanvasButton;
   import mx.core.Container;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.skins.halo.AccordionHeaderSkin;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleManager;
   
   [AccessibilityClass(implementation="mx.accessibility.AccordionHeaderAccImpl")]
   public class CanvasButtonAccordionHeader extends CanvasButton implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      initializeStyles();
      
      private var _data:Object;
      
      private var focusObj:DisplayObject;
      
      private var focusSkin:IFlexDisplayObject;
      
      public function CanvasButtonAccordionHeader()
      {
         super();
         toggleChanged = false;
         mouseFocusEnabled = false;
         tabEnabled = false;
      }
      
      private static function initializeStyles() : void
      {
         var selector:CSSStyleDeclaration = null;
         selector = StyleManager.getStyleDeclaration("CanvasButtonAccordionHeader");
         if(!selector)
         {
            selector = new CSSStyleDeclaration();
         }
         selector.defaultFactory = function():void
         {
            this.fontSize = 10;
            this.fontWeight = "bold";
            this.disabledSkin = AccordionHeaderSkin;
            this.downSkin = AccordionHeaderSkin;
            this.horizontalGap = 2;
            this.overSkin = AccordionHeaderSkin;
            this.paddingLeft = 5;
            this.paddingRight = 5;
            this.selectedDisabledSkin = AccordionHeaderSkin;
            this.selectedDownSkin = AccordionHeaderSkin;
            this.selectedOverSkin = AccordionHeaderSkin;
            this.selectedUpSkin = AccordionHeaderSkin;
            this.skin = AccordionHeaderSkin;
            this.textAlign = "left";
            this.upSkin = AccordionHeaderSkin;
         };
         StyleManager.setStyleDeclaration("CanvasButtonAccordionHeader",selector,false);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function layoutContents(unscaledWidth:Number, unscaledHeight:Number, offset:Boolean) : void
      {
         super.layoutContents(unscaledWidth,unscaledHeight,offset);
         if(Boolean(focusObj))
         {
            setChildIndex(focusObj,numChildren - 1);
         }
      }
      
      override public function set selected(value:Boolean) : void
      {
         _selected = value;
         invalidateDisplayList();
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         var focusClass:Class = null;
         var focusStyleable:ISimpleStyleClient = null;
         if(isFocused && !isEffectStarted)
         {
            if(!focusObj)
            {
               focusClass = getStyle("focusSkin");
               focusObj = new focusClass();
               focusStyleable = focusObj as ISimpleStyleClient;
               if(Boolean(focusStyleable))
               {
                  focusStyleable.styleName = this;
               }
               addChild(focusObj);
               focusSkin = focusObj as IFlexDisplayObject;
            }
            if(Boolean(focusSkin))
            {
               focusSkin.move(0,0);
               focusSkin.setActualSize(unscaledWidth,unscaledHeight);
            }
            focusObj.visible = true;
            dispatchEvent(new Event("focusDraw"));
         }
         else if(Boolean(focusObj))
         {
            focusObj.visible = false;
         }
      }
      
      override protected function rollOverHandler(event:MouseEvent) : void
      {
         var accordion:Container = null;
         super.rollOverHandler(event);
         accordion = Container(parent);
         if(accordion.enabled)
         {
            accordion.rawChildren.setChildIndex(this,accordion.rawChildren.numChildren - 1);
         }
      }
      
      override protected function createChildren() : void
      {
         var styleDecl:CSSStyleDeclaration = null;
         var value:Number = NaN;
         super.createChildren();
         styleDecl = StyleManager.getStyleDeclaration(className);
         if(Boolean(styleDecl))
         {
            value = Number(styleDecl.getStyle("paddingLeft"));
            if(!isNaN(value))
            {
               setStyle("paddingLeft",value);
            }
            value = Number(styleDecl.getStyle("paddingRight"));
            if(!isNaN(value))
            {
               setStyle("paddingRight",value);
            }
         }
      }
      
      override public function set data(value:Object) : void
      {
         _data = value;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(CanvasButtonAccordionHeader.createAccessibilityImplementation != null)
         {
            CanvasButtonAccordionHeader.createAccessibilityImplementation(this);
         }
      }
      
      override public function get data() : Object
      {
         return _data;
      }
   }
}

