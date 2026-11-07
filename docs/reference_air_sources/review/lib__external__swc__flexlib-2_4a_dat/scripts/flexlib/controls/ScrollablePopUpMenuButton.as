package flexlib.controls
{
   import flexlib.baseClasses.PopUpMenuButtonBase;
   import mx.core.IUIComponent;
   import mx.events.FlexEvent;
   import mx.events.MenuEvent;
   import mx.managers.PopUpManager;
   
   public class ScrollablePopUpMenuButton extends PopUpMenuButtonBase
   {
      
      private var _arrowScrollPolicy:String;
      
      private var _verticalScrollPolicy:String;
      
      public function ScrollablePopUpMenuButton()
      {
         super();
      }
      
      public function get verticalScrollPolicy() : String
      {
         return this._verticalScrollPolicy;
      }
      
      public function get arrowScrollPolicy() : String
      {
         return this._arrowScrollPolicy;
      }
      
      public function set verticalScrollPolicy(value:String) : void
      {
         var newPolicy:String = null;
         newPolicy = value.toLowerCase();
         if(_verticalScrollPolicy != newPolicy)
         {
            _verticalScrollPolicy = newPolicy;
         }
         if(Boolean(this.popUpMenu))
         {
            popUpMenu.verticalScrollPolicy = this.verticalScrollPolicy;
         }
      }
      
      public function set arrowScrollPolicy(value:String) : void
      {
         var newPolicy:String = null;
         newPolicy = value.toLowerCase();
         if(_arrowScrollPolicy != newPolicy)
         {
            _arrowScrollPolicy = newPolicy;
         }
         if(Boolean(this.popUpMenu))
         {
            (popUpMenu as ScrollableArrowMenu).arrowScrollPolicy = this.arrowScrollPolicy;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getPopUp() : IUIComponent
      {
         if(!popUpMenu)
         {
            popUpMenu = new ScrollableArrowMenu();
            popUpMenu.maxHeight = this.maxHeight;
            popUpMenu.labelField = labelField;
            popUpMenu.labelFunction = labelFunction;
            popUpMenu.showRoot = showRoot;
            popUpMenu.dataDescriptor = dataDescriptor;
            popUpMenu.dataProvider = dataProvider;
            popUpMenu.addEventListener(MenuEvent.ITEM_CLICK,menuChangeHandler);
            popUpMenu.addEventListener(FlexEvent.VALUE_COMMIT,menuValueCommitHandler);
            super.popUp = popUpMenu;
            PopUpManager.addPopUp(super.popUp,this,false);
            super.popUp.owner = this;
         }
         else
         {
            popUpMenu.invalidateDisplayList();
         }
         if(popUpMenu.verticalScrollPolicy != this.verticalScrollPolicy)
         {
            popUpMenu.verticalScrollPolicy = this.verticalScrollPolicy;
         }
         if((popUpMenu as ScrollableArrowMenu).arrowScrollPolicy != this.arrowScrollPolicy)
         {
            (popUpMenu as ScrollableArrowMenu).arrowScrollPolicy = this.arrowScrollPolicy;
         }
         return popUpMenu;
      }
      
      override public function set maxHeight(value:Number) : void
      {
         if(Boolean(popUpMenu))
         {
            popUpMenu.maxHeight = value;
         }
         super.maxHeight = value;
      }
   }
}

