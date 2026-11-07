package mx.controls
{
   import mx.controls.fileSystemClasses.FileSystemControlHelper;
   import mx.core.IUIComponent;
   import mx.events.MenuEvent;
   
   [ResourceBundle("aircontrols")]
   [IconFile("FileSystemHistoryButton.png")]
   [Event(name="itemClick",type="mx.events.MenuEvent")]
   public class FileSystemHistoryButton extends PopUpButton
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      private var popUpMenu:Menu;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var helper:FileSystemControlHelper;
      
      public function FileSystemHistoryButton()
      {
         super();
         helper = new FileSystemControlHelper(this,false);
         popUpMenu = new Menu();
         popUpMenu.labelFunction = helper.fileLabelFunction;
         popUpMenu.owner = this;
         popUpMenu.addEventListener(MenuEvent.ITEM_CLICK,itemClickHandler);
         super.popUp = popUpMenu;
      }
      
      private function itemClickHandler(event:MenuEvent) : void
      {
         dispatchEvent(event);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getPopUp() : IUIComponent
      {
         super.getPopUp();
         return popUpMenu;
      }
      
      public function get dataProvider() : Object
      {
         return popUpMenu.dataProvider;
      }
      
      public function set dataProvider(value:Object) : void
      {
         popUpMenu.dataProvider = value;
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         if(Boolean(popUpMenu))
         {
            popUpMenu.invalidateSize();
            popUpMenu.invalidateDisplayList();
         }
      }
   }
}

