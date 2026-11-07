package mx.controls
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventPhase;
   import mx.containers.Panel;
   import mx.controls.alertClasses.AlertForm;
   import mx.core.EdgeMetrics;
   import mx.core.FlexGlobals;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.events.CloseEvent;
   import mx.events.FlexEvent;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("controls")]
   [RequiresDataBinding("true")]
   [AccessibilityClass(implementation="mx.accessibility.AlertAccImpl")]
   [Style(name="titleStyleName",type="String",inherit="no")]
   [Style(name="messageStyleName",type="String",inherit="no")]
   [Style(name="buttonStyleName",type="String",inherit="no")]
   public class Alert extends Panel
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      private static var _resourceManager:IResourceManager;
      
      private static var _cancelLabel:String;
      
      private static var cancelLabelOverride:String;
      
      private static var _noLabel:String;
      
      private static var noLabelOverride:String;
      
      private static var _okLabel:String;
      
      private static var okLabelOverride:String;
      
      private static var _yesLabel:String;
      
      private static var yesLabelOverride:String;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const YES:uint = 1;
      
      public static const NO:uint = 2;
      
      public static const OK:uint = 4;
      
      public static const CANCEL:uint = 8;
      
      public static const NONMODAL:uint = 32768;
      
      private static var initialized:Boolean = false;
      
      [Inspectable(category="Size")]
      public static var buttonHeight:Number = 22;
      
      [Inspectable(category="Size")]
      public static var buttonWidth:Number = 65;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var alertForm:AlertForm;
      
      public var buttonFlags:uint = 4;
      
      [Inspectable(category="General")]
      public var defaultButtonFlag:uint = 4;
      
      [Inspectable(category="Other")]
      public var iconClass:Class;
      
      [Inspectable(category="General")]
      public var text:String = "";
      
      public function Alert()
      {
         super();
         title = "";
      }
      
      private static function get resourceManager() : IResourceManager
      {
         if(!_resourceManager)
         {
            _resourceManager = ResourceManager.getInstance();
         }
         return _resourceManager;
      }
      
      [Inspectable(category="General")]
      public static function get cancelLabel() : String
      {
         initialize();
         return _cancelLabel;
      }
      
      public static function set cancelLabel(value:String) : void
      {
         cancelLabelOverride = value;
         _cancelLabel = value != null ? value : resourceManager.getString("controls","cancelLabel");
      }
      
      [Inspectable(category="General")]
      public static function get noLabel() : String
      {
         initialize();
         return _noLabel;
      }
      
      public static function set noLabel(value:String) : void
      {
         noLabelOverride = value;
         _noLabel = value != null ? value : resourceManager.getString("controls","noLabel");
      }
      
      [Inspectable(category="General")]
      public static function get okLabel() : String
      {
         initialize();
         return _okLabel;
      }
      
      public static function set okLabel(value:String) : void
      {
         okLabelOverride = value;
         _okLabel = value != null ? value : resourceManager.getString("controls","okLabel");
      }
      
      [Inspectable(category="General")]
      public static function get yesLabel() : String
      {
         initialize();
         return _yesLabel;
      }
      
      public static function set yesLabel(value:String) : void
      {
         yesLabelOverride = value;
         _yesLabel = value != null ? value : resourceManager.getString("controls","yesLabel");
      }
      
      public static function show(text:String = "", title:String = "", flags:uint = 4, parent:Sprite = null, closeHandler:Function = null, iconClass:Class = null, defaultButtonFlag:uint = 4, moduleFactory:IFlexModuleFactory = null) : Alert
      {
         var sm:ISystemManager = null;
         var mp:Object = null;
         var modal:Boolean = Boolean(flags & Alert.NONMODAL) ? false : true;
         if(!parent)
         {
            sm = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
            mp = sm.getImplementation("mx.managers::IMarshalSystemManager");
            if(Boolean(mp) && Boolean(mp.useSWFBridge()))
            {
               parent = Sprite(sm.getSandboxRoot());
            }
            else
            {
               parent = Sprite(FlexGlobals.topLevelApplication);
            }
         }
         var alert:Alert = new Alert();
         if(Boolean(flags & Alert.OK) || Boolean(flags & Alert.CANCEL) || Boolean(flags & Alert.YES) || Boolean(flags & Alert.NO))
         {
            alert.buttonFlags = flags;
         }
         if(defaultButtonFlag == Alert.OK || defaultButtonFlag == Alert.CANCEL || defaultButtonFlag == Alert.YES || defaultButtonFlag == Alert.NO)
         {
            alert.defaultButtonFlag = defaultButtonFlag;
         }
         alert.text = text;
         alert.title = title;
         alert.iconClass = iconClass;
         if(closeHandler != null)
         {
            alert.addEventListener(CloseEvent.CLOSE,closeHandler);
         }
         if(Boolean(moduleFactory))
         {
            alert.moduleFactory = moduleFactory;
         }
         else if(parent is IFlexModule)
         {
            alert.moduleFactory = IFlexModule(parent).moduleFactory;
         }
         else
         {
            if(parent is IFlexModuleFactory)
            {
               alert.moduleFactory = IFlexModuleFactory(parent);
            }
            else
            {
               alert.moduleFactory = FlexGlobals.topLevelApplication.moduleFactory;
            }
            if(!parent is UIComponent)
            {
               alert.document = FlexGlobals.topLevelApplication.document;
            }
         }
         alert.addEventListener(FlexEvent.CREATION_COMPLETE,static_creationCompleteHandler);
         PopUpManager.addPopUp(alert,parent,modal);
         return alert;
      }
      
      private static function initialize() : void
      {
         if(!initialized)
         {
            resourceManager.addEventListener(Event.CHANGE,static_resourceManager_changeHandler,false,0,true);
            static_resourcesChanged();
            initialized = true;
         }
      }
      
      private static function static_resourcesChanged() : void
      {
         cancelLabel = cancelLabelOverride;
         noLabel = noLabelOverride;
         okLabel = okLabelOverride;
         yesLabel = yesLabelOverride;
      }
      
      private static function static_resourceManager_changeHandler(event:Event) : void
      {
         static_resourcesChanged();
      }
      
      private static function static_creationCompleteHandler(event:FlexEvent) : void
      {
         var alert:Alert = null;
         if(event.target is IFlexDisplayObject && event.eventPhase == EventPhase.AT_TARGET)
         {
            alert = Alert(event.target);
            alert.removeEventListener(FlexEvent.CREATION_COMPLETE,static_creationCompleteHandler);
            alert.setActualSize(alert.getExplicitOrMeasuredWidth(),alert.getExplicitOrMeasuredHeight());
            PopUpManager.centerPopUp(IFlexDisplayObject(alert));
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Alert.createAccessibilityImplementation != null)
         {
            Alert.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var messageStyleName:String = getStyle("messageStyleName");
         if(Boolean(messageStyleName))
         {
            styleName = messageStyleName;
         }
         if(!this.alertForm)
         {
            this.alertForm = new AlertForm();
            this.alertForm.styleName = this;
            addChild(this.alertForm);
         }
      }
      
      override protected function measure() : void
      {
         var m:EdgeMetrics = null;
         var headerHeight:Number = NaN;
         super.measure();
         m = viewMetrics;
         measuredWidth = Math.max(measuredWidth,this.alertForm.getExplicitOrMeasuredWidth() + m.left + m.right);
         measuredHeight = this.alertForm.getExplicitOrMeasuredHeight() + m.top + m.bottom;
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
         {
            headerHeight = Number(getStyle("headerHeight"));
            if(m.top == 0)
            {
               measuredHeight += headerHeight;
            }
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var vm:EdgeMetrics = viewMetrics;
         this.alertForm.setActualSize(unscaledWidth - vm.left - vm.right - getStyle("paddingLeft") - getStyle("paddingRight"),unscaledHeight - vm.top - vm.bottom - getStyle("paddingTop") - getStyle("paddingBottom"));
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var messageStyleName:String = null;
         super.styleChanged(styleProp);
         if(styleProp == "messageStyleName")
         {
            messageStyleName = getStyle("messageStyleName");
            styleName = messageStyleName;
         }
         if(Boolean(this.alertForm))
         {
            this.alertForm.styleChanged(styleProp);
         }
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         static_resourcesChanged();
      }
   }
}

