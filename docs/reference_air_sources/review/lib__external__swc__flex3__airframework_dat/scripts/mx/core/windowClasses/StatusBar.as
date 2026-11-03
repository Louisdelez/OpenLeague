package mx.core.windowClasses
{
   import flash.display.DisplayObject;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.IStyleClient;
   
   public class StatusBar extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      private var statusChanged:Boolean = false;
      
      public var statusTextField:IUITextField;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var statusBarBackground:IFlexDisplayObject;
      
      private var _status:String = "";
      
      public function StatusBar()
      {
         super();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var statusBarBackgroundClass:Class = null;
         var backgroundUIComponent:IStyleClient = null;
         var backgroundStyleable:ISimpleStyleClient = null;
         super.styleChanged(styleProp);
         invalidateDisplayList();
         var allStyles:Boolean = !styleProp || styleProp == "styleName";
         if(allStyles || styleProp == "statusBarBackgroundSkin")
         {
            statusBarBackgroundClass = getStyle("statusBarBackgroundSkin");
            if(Boolean(statusBarBackgroundClass))
            {
               if(Boolean(statusBarBackground))
               {
                  removeChild(DisplayObject(statusBarBackground));
                  statusBarBackground = null;
               }
               statusBarBackground = new statusBarBackgroundClass();
               backgroundUIComponent = statusBarBackground as IStyleClient;
               if(Boolean(backgroundUIComponent))
               {
                  backgroundUIComponent.setStyle("backgroundImage",undefined);
               }
               backgroundStyleable = statusBarBackground as ISimpleStyleClient;
               if(Boolean(backgroundStyleable))
               {
                  backgroundStyleable.styleName = this;
               }
               addChildAt(DisplayObject(statusBarBackground),0);
            }
         }
         if(allStyles || styleProp == "statusTextStyleName")
         {
            if(Boolean(statusTextField))
            {
               statusTextField.styleName = getStyle("statusTextStyleName");
            }
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         statusTextField.validateNow();
         if(statusTextField.textHeight == 0)
         {
            statusTextField.text = " ";
            statusTextField.validateNow();
         }
         measuredHeight = statusTextField.textHeight + UITextField.TEXT_HEIGHT_PADDING;
         measuredWidth = statusTextField.textWidth;
      }
      
      public function set status(value:String) : void
      {
         _status = value;
         statusChanged = true;
         invalidateProperties();
         invalidateSize();
      }
      
      public function get status() : String
      {
         return _status;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         statusBarBackground.setActualSize(unscaledWidth,unscaledHeight);
         statusTextField.text = _status;
         statusTextField.width = unscaledWidth;
         statusTextField.truncateToFit("...");
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(statusChanged)
         {
            statusTextField.text = _status;
            statusChanged = false;
         }
      }
      
      override protected function createChildren() : void
      {
         var backgroundUIComponent:IStyleClient = null;
         var backgroundStyleable:ISimpleStyleClient = null;
         super.createChildren();
         var statusBarBackgroundClass:Class = getStyle("statusBarBackgroundSkin");
         if(Boolean(statusBarBackgroundClass))
         {
            statusBarBackground = new statusBarBackgroundClass();
            backgroundUIComponent = statusBarBackground as IStyleClient;
            if(Boolean(backgroundUIComponent))
            {
               backgroundUIComponent.setStyle("backgroundImage",undefined);
            }
            backgroundStyleable = statusBarBackground as ISimpleStyleClient;
            if(Boolean(backgroundStyleable))
            {
               backgroundStyleable.styleName = this;
            }
            addChild(DisplayObject(statusBarBackground));
         }
         if(!statusTextField)
         {
            statusTextField = IUITextField(createInFontContext(UITextField));
            statusTextField.text = _status;
            statusTextField.styleName = getStyle("statusTextStyleName");
            statusTextField.enabled = true;
            addChild(DisplayObject(statusTextField));
         }
      }
   }
}

