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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var helper:FileSystemControlHelper;
      
      private var popUpMenu:Menu;
      
      public function FileSystemHistoryButton()
      {
         super();
         this.helper = new FileSystemControlHelper(this,false);
         this.popUpMenu = new Menu();
         this.popUpMenu.labelFunction = this.helper.fileLabelFunction;
         this.popUpMenu.owner = this;
         this.popUpMenu.addEventListener(MenuEvent.ITEM_CLICK,this.itemClickHandler);
         super.popUp = this.popUpMenu;
      }
      
      public function get dataProvider() : Object
      {
         return this.popUpMenu.dataProvider;
      }
      
      public function set dataProvider(value:Object) : void
      {
         this.popUpMenu.dataProvider = value;
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         if(Boolean(this.popUpMenu))
         {
            this.popUpMenu.invalidateSize();
            this.popUpMenu.invalidateDisplayList();
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getPopUp() : IUIComponent
      {
         super.getPopUp();
         return this.popUpMenu;
      }
      
      private function itemClickHandler(event:MenuEvent) : void
      {
         dispatchEvent(event);
      }
   }
}

