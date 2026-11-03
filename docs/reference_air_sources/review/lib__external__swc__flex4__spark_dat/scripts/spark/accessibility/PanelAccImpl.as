package spark.accessibility
{
   import flash.accessibility.AccessibilityImplementation;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import mx.accessibility.AccConst;
   import mx.accessibility.AccImpl;
   import mx.core.UIComponent;
   import mx.events.ResizeEvent;
   import spark.components.Panel;
   import spark.events.SkinPartEvent;
   
   public class PanelAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var accImplSprite:Sprite;
      
      private var titleDisplayAccImpl:AccessibilityImplementation;
      
      public function PanelAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_GROUPING;
      }
      
      public static function enableAccessibility() : void
      {
         Panel.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         var accImpl:PanelAccImpl = new PanelAccImpl(component);
         accImpl.attach();
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat([ResizeEvent.RESIZE,SkinPartEvent.PART_ADDED,SkinPartEvent.PART_REMOVED]);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         return uint(getState(childID));
      }
      
      override protected function getName(childID:uint) : String
      {
         return Panel(master).title;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function attach() : Sprite
      {
         var panel:Panel = Panel(master);
         this.accImplSprite = new Sprite();
         panel.$addChildAt(this.accImplSprite,0);
         this.accImplSprite.accessibilityImplementation = this;
         if(Boolean(panel.titleDisplay))
         {
            this.titleDisplayAccImpl = InteractiveObject(panel.titleDisplay).accessibilityImplementation;
            InteractiveObject(panel.titleDisplay).accessibilityImplementation = null;
         }
         if(panel.tabIndex > 0 && this.accImplSprite.tabIndex == -1)
         {
            this.accImplSprite.tabIndex = panel.tabIndex;
         }
         return this.accImplSprite;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var titleDisplay:InteractiveObject = null;
         var panel:Panel = null;
         var g:Graphics = null;
         super.eventHandler(event);
         switch(event.type)
         {
            case ResizeEvent.RESIZE:
               panel = Panel(master);
               g = this.accImplSprite.graphics;
               g.clear();
               g.lineStyle(0,0,0);
               g.drawRect(0,0,panel.width,panel.height);
               break;
            case SkinPartEvent.PART_ADDED:
               titleDisplay = Panel(master).titleDisplay as InteractiveObject;
               if(SkinPartEvent(event).instance == titleDisplay)
               {
                  this.titleDisplayAccImpl = titleDisplay.accessibilityImplementation;
                  titleDisplay.accessibilityImplementation = null;
               }
               break;
            case SkinPartEvent.PART_REMOVED:
               titleDisplay = Panel(master).titleDisplay as InteractiveObject;
               if(SkinPartEvent(event).instance == titleDisplay)
               {
                  titleDisplay.accessibilityImplementation = this.titleDisplayAccImpl;
                  this.titleDisplayAccImpl = null;
               }
         }
      }
   }
}

