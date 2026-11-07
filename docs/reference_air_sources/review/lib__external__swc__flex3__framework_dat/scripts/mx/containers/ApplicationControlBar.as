package mx.containers
{
   import flash.events.Event;
   import mx.core.Application;
   import mx.core.mx_internal;
   import mx.styles.IStyleClient;
   
   use namespace mx_internal;
   
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
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var dockChanged:Boolean = false;
      
      private var _dock:Boolean = false;
      
      public function ApplicationControlBar()
      {
         super();
      }
      
      public function set dock(value:Boolean) : void
      {
         if(_dock != value)
         {
            _dock = value;
            dockChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("dockChanged"));
         }
      }
      
      public function resetDock(value:Boolean) : void
      {
         _dock = !value;
         dock = value;
      }
      
      [Bindable("dockChanged")]
      [Inspectable(category="General",enumeration="false,true",defaultValue="false")]
      public function get dock() : Boolean
      {
         return _dock;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(dockChanged)
         {
            dockChanged = false;
            if(parent is Application)
            {
               Application(parent).dockControlBar(this,_dock);
            }
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
   }
}

