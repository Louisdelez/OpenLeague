package mx.containers
{
   import flash.events.Event;
   import mx.core.FlexVersion;
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleClient;
   
   [Alternative(replacement="none",since="4.0")]
   [IconFile("ApplicationControlBar.png")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="backgroundSize",kind="style")]
   [Exclude(name="backgroundImage",kind="style")]
   [Exclude(name="backgroundAttachment",kind="style")]
   [Exclude(name="backgroundAlpha",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Exclude(name="direction",kind="property")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no")]
   public class ApplicationControlBar extends ControlBar
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var dockChanged:Boolean = false;
      
      private var _dock:Boolean = false;
      
      public function ApplicationControlBar()
      {
         super();
      }
      
      [Bindable("dockChanged")]
      [Inspectable(category="General",enumeration="false,true",defaultValue="false")]
      public function get dock() : Boolean
      {
         return this._dock;
      }
      
      public function set dock(value:Boolean) : void
      {
         if(this._dock != value)
         {
            this._dock = value;
            this.dockChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("dockChanged"));
         }
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         var oldBlocker:Object = blocker;
         super.enabled = value;
         if(Boolean(blocker) && blocker != oldBlocker)
         {
            if(blocker is IStyleClient)
            {
               IStyleClient(blocker).setStyle("borderStyle","applicationControlBar");
            }
         }
      }
      
      override public function set moduleFactory(factory:IFlexModuleFactory) : void
      {
         var typeSelector:CSSStyleDeclaration = null;
         super.moduleFactory = factory;
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
         {
            typeSelector = styleManager.getStyleDeclaration("mx.containers.ApplicationControlBar");
            if(Boolean(typeSelector))
            {
               if(typeSelector.getStyle("borderStyle") === undefined)
               {
                  typeSelector.setStyle("borderStyle","applicationControlBar");
               }
               if(typeSelector.getStyle("docked") === undefined)
               {
                  typeSelector.setStyle("docked",false);
               }
               if(typeSelector.getStyle("dropShadowEnabled") === undefined)
               {
                  typeSelector.setStyle("dropShadowEnabled",true);
               }
               if(typeSelector.getStyle("shadowDistance") === undefined)
               {
                  typeSelector.setStyle("shadowDistance",5);
               }
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         var applicationClass:Class = null;
         super.commitProperties();
         if(this.dockChanged)
         {
            this.dockChanged = false;
            applicationClass = Class(systemManager.getDefinitionByName("mx.core::Application"));
            if(Boolean(applicationClass) && parent is applicationClass)
            {
               applicationClass(parent).dockControlBar(this,this._dock);
            }
         }
      }
      
      public function resetDock(value:Boolean) : void
      {
         this._dock = !value;
         this.dock = value;
      }
   }
}

