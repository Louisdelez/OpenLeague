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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var statusBarBackground:IFlexDisplayObject;
      
      private var _status:String = "";
      
      private var statusChanged:Boolean = false;
      
      public var statusTextField:IUITextField;
      
      public function StatusBar()
      {
         super();
      }
      
      public function get status() : String
      {
         return this._status;
      }
      
      public function set status(value:String) : void
      {
         this._status = value;
         this.statusChanged = true;
         invalidateProperties();
         invalidateSize();
      }
      
      override protected function createChildren() : void
      {
         var backgroundUIComponent:IStyleClient = null;
         var backgroundStyleable:ISimpleStyleClient = null;
         super.createChildren();
         var statusBarBackgroundClass:Class = getStyle("statusBarBackgroundSkin");
         if(Boolean(statusBarBackgroundClass))
         {
            this.statusBarBackground = new statusBarBackgroundClass();
            backgroundUIComponent = this.statusBarBackground as IStyleClient;
            if(Boolean(backgroundUIComponent))
            {
               backgroundUIComponent.setStyle("backgroundImage",undefined);
            }
            backgroundStyleable = this.statusBarBackground as ISimpleStyleClient;
            if(Boolean(backgroundStyleable))
            {
               backgroundStyleable.styleName = this;
            }
            addChild(DisplayObject(this.statusBarBackground));
         }
         if(!this.statusTextField)
         {
            this.statusTextField = IUITextField(createInFontContext(UITextField));
            this.statusTextField.text = this._status;
            this.statusTextField.styleName = getStyle("statusTextStyleName");
            this.statusTextField.enabled = true;
            addChild(DisplayObject(this.statusTextField));
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.statusChanged)
         {
            this.statusTextField.text = this._status;
            this.statusChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.statusTextField.validateNow();
         if(this.statusTextField.textHeight == 0)
         {
            this.statusTextField.text = " ";
            this.statusTextField.validateNow();
         }
         measuredHeight = this.statusTextField.textHeight + UITextField.TEXT_HEIGHT_PADDING;
         measuredWidth = this.statusTextField.textWidth;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.statusBarBackground.setActualSize(unscaledWidth,unscaledHeight);
         this.statusTextField.text = this._status;
         this.statusTextField.width = unscaledWidth;
         this.statusTextField.truncateToFit("...");
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
               if(Boolean(this.statusBarBackground))
               {
                  removeChild(DisplayObject(this.statusBarBackground));
                  this.statusBarBackground = null;
               }
               this.statusBarBackground = new statusBarBackgroundClass();
               backgroundUIComponent = this.statusBarBackground as IStyleClient;
               if(Boolean(backgroundUIComponent))
               {
                  backgroundUIComponent.setStyle("backgroundImage",undefined);
               }
               backgroundStyleable = this.statusBarBackground as ISimpleStyleClient;
               if(Boolean(backgroundStyleable))
               {
                  backgroundStyleable.styleName = this;
               }
               addChildAt(DisplayObject(this.statusBarBackground),0);
            }
         }
         if(allStyles || styleProp == "statusTextStyleName")
         {
            if(Boolean(this.statusTextField))
            {
               this.statusTextField.styleName = getStyle("statusTextStyleName");
            }
         }
      }
   }
}

