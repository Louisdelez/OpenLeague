package flexlib.mdi.containers
{
   import flexlib.mdi.effects.IMDIEffectsDescriptor;
   import flexlib.mdi.managers.MDIManager;
   import mx.containers.Canvas;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   
   public class MDICanvas extends Canvas
   {
      
      public var windowManager:MDIManager;
      
      public function MDICanvas()
      {
         super();
         windowManager = new MDIManager(this);
         addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
      }
      
      public function set effectsLib(clazz:Class) : void
      {
         this.windowManager.effects = new clazz();
      }
      
      private function onCreationComplete(event:FlexEvent) : void
      {
         var child:UIComponent = null;
         for each(child in getChildren())
         {
            if(child is MDIWindow)
            {
               windowManager.add(child as MDIWindow);
            }
         }
         removeEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
      }
      
      public function set effects(effects:IMDIEffectsDescriptor) : void
      {
         this.windowManager.effects = effects;
      }
      
      public function set enforceBoundaries(value:Boolean) : void
      {
         windowManager.enforceBoundaries = value;
      }
      
      public function get enforceBoundaries() : Boolean
      {
         return windowManager.enforceBoundaries;
      }
   }
}

