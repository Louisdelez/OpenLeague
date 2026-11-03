package mx.controls
{
   import mx.controls.listClasses.BaseListData;
   import mx.core.IFlexModuleFactory;
   import mx.core.ITextInput;
   import mx.events.FlexEvent;
   import mx.managers.IFocusManagerComponent;
   import spark.components.TextInput;
   
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class MXFTETextInput extends TextInput implements ITextInput
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "promptDisplay":false,
         "textDisplay":false
      };
      
      private var oldContentBackgroundAlpha:Number;
      
      private var _data:Object;
      
      private var _listData:BaseListData;
      
      private var _parentDrawsFocus:Boolean = false;
      
      public function MXFTETextInput()
      {
         super();
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         var newText:* = undefined;
         this._data = value;
         if(Boolean(this._listData))
         {
            newText = this._listData.label;
         }
         else if(this._data != null)
         {
            if(this._data is String)
            {
               newText = String(this._data);
            }
            else
            {
               newText = this._data.toString();
            }
         }
         if(newText !== undefined)
         {
            text = newText;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return null;
      }
      
      public function set fontContext(value:IFlexModuleFactory) : void
      {
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return Boolean(textDisplay) ? textDisplay.horizontalScrollPosition : 0;
      }
      
      public function set horizontalScrollPosition(value:Number) : void
      {
         if(Boolean(textDisplay))
         {
            textDisplay.horizontalScrollPosition = value;
         }
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return this._listData;
      }
      
      public function set listData(value:BaseListData) : void
      {
         this._listData = value;
      }
      
      public function get parentDrawsFocus() : Boolean
      {
         return this._parentDrawsFocus;
      }
      
      public function set parentDrawsFocus(value:Boolean) : void
      {
         this._parentDrawsFocus = value;
      }
      
      public function showBorderAndBackground(visible:Boolean) : void
      {
         setStyle("borderVisible",visible);
         var contentBackgroundAlpha:Number = Number(getStyle("contentBackgroundAlpha"));
         if(!visible)
         {
            if(isNaN(contentBackgroundAlpha) || contentBackgroundAlpha != 0)
            {
               this.oldContentBackgroundAlpha = getStyle("contentBackgroundAlpha");
               setStyle("contentBackgroundAlpha",0);
            }
         }
         else if(!isNaN(this.oldContentBackgroundAlpha))
         {
            setStyle("contentBackgroundAlpha",this.oldContentBackgroundAlpha);
            this.oldContentBackgroundAlpha = NaN;
         }
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         if(this._parentDrawsFocus)
         {
            IFocusManagerComponent(parent).drawFocus(isFocused);
            return;
         }
         super.drawFocus(isFocused);
      }
   }
}

