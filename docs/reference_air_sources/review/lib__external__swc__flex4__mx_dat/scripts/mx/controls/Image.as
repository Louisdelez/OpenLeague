package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import mx.events.FlexEvent;
   
   [Alternative(replacement="spark.components.Image",since="4.5")]
   [IconFile("Image.png")]
   [DefaultTriggerEvent("complete")]
   [DefaultBindingProperty(source="progress",destination="source")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class Image extends SWFLoader implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var makeContentVisible:Boolean = false;
      
      private var sourceSet:Boolean;
      
      private var settingBrokenImage:Boolean;
      
      private var _data:Object;
      
      private var _listData:BaseListData;
      
      public function Image()
      {
         super();
         tabChildren = false;
         tabEnabled = true;
         tabFocusEnabled = true;
         showInAutomationHierarchy = true;
      }
      
      [Inspectable(category="General",defaultValue="",format="File")]
      [Bindable("sourceChanged")]
      override public function set source(value:Object) : void
      {
         this.settingBrokenImage = value == getStyle("brokenImageSkin");
         this.sourceSet = !this.settingBrokenImage;
         super.source = value;
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value;
         if(!this.sourceSet)
         {
            this.source = Boolean(this.listData) ? this.listData.label : this.data;
            this.sourceSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
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
      
      override public function invalidateSize() : void
      {
         if(Boolean(this.data) && this.settingBrokenImage)
         {
            return;
         }
         super.invalidateSize();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.makeContentVisible && Boolean(contentHolder))
         {
            contentHolder.visible = true;
            this.makeContentVisible = false;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function contentLoaderInfo_completeEventHandler(event:Event) : void
      {
         var obj:DisplayObject = DisplayObject(event.target.loader);
         super.contentLoaderInfo_completeEventHandler(event);
         obj.visible = false;
         this.makeContentVisible = true;
         invalidateDisplayList();
      }
   }
}

