package spark.components
{
   import flash.events.Event;
   import mx.collections.IList;
   import mx.core.EventPriority;
   import mx.core.IFactory;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.managers.IFocusManagerComponent;
   import spark.components.supportClasses.ButtonBarBase;
   
   [IconFile("ButtonBar.png")]
   public class ButtonBar extends ButtonBarBase implements IFocusManagerComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "dataGroup":false,
         "lastButton":false,
         "firstButton":false,
         "middleButton":true
      };
      
      [SkinPart(required="false",type="mx.core.IVisualElement")]
      public var firstButton:IFactory;
      
      [SkinPart(required="false",type="mx.core.IVisualElement")]
      public var lastButton:IFactory;
      
      [SkinPart(required="true",type="mx.core.IVisualElement")]
      public var middleButton:IFactory;
      
      public function ButtonBar()
      {
         super();
         itemRendererFunction = this.defaultButtonBarItemRendererFunction;
      }
      
      [Inspectable(category="Data")]
      override public function set dataProvider(value:IList) : void
      {
         if(Boolean(dataProvider))
         {
            dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.resetCollectionChangeHandler);
         }
         if(Boolean(value))
         {
            value.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.resetCollectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
         }
         super.dataProvider = value;
      }
      
      private function resetCollectionChangeHandler(event:Event) : void
      {
         var ce:CollectionEvent = null;
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.ADD || ce.kind == CollectionEventKind.REMOVE)
            {
               if(Boolean(dataGroup))
               {
                  dataGroup.layout.useVirtualLayout = true;
                  dataGroup.layout.useVirtualLayout = false;
               }
            }
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setCurrentCaretIndex(value:Number) : void
      {
         if(value == -1)
         {
            return;
         }
         super.setCurrentCaretIndex(value);
      }
      
      private function defaultButtonBarItemRendererFunction(data:Object) : IFactory
      {
         var i:int = int(dataProvider.getItemIndex(data));
         if(i == 0)
         {
            return Boolean(this.firstButton) ? this.firstButton : this.middleButton;
         }
         var n:int = dataProvider.length - 1;
         if(i == n)
         {
            return Boolean(this.lastButton) ? this.lastButton : this.middleButton;
         }
         return this.middleButton;
      }
   }
}

